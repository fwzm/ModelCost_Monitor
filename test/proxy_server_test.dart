import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:modelcost_monitor/core/models/models.dart';
import 'package:modelcost_monitor/core/proxy/proxy_server.dart';

void main() {
  group('ProxyServer usability safeguards', () {
    test('falls back when requested port is occupied', () async {
      final occupied = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      final server = ProxyServer(
        host: '127.0.0.1',
        port: occupied.port,
        accounts: const [],
        prices: const [],
      );

      try {
        final actualPort = await server.start();
        expect(actualPort, isNot(equals(occupied.port)));

        final response = await _get('http://127.0.0.1:$actualPort/__health');
        expect(response.statusCode, HttpStatus.ok);
        expect(jsonDecode(response.body)['ok'], isTrue);
      } finally {
        await server.stop();
        await occupied.close(force: true);
      }
    });

    test(
      'creates default provider route and forwards OpenAI-compatible request',
      () async {
        var upstreamHits = 0;
        final upstream = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
        upstream.listen((request) async {
          upstreamHits++;
          expect(
            request.headers.value(HttpHeaders.authorizationHeader),
            equals('Bearer sk-test'),
          );
          request.response.headers.contentType = ContentType.json;
          request.response.write(
            jsonEncode({
              'id': 'cmpl-test',
              'model': 'deepseek-chat',
              'usage': {
                'prompt_tokens': 10,
                'completion_tokens': 4,
                'total_tokens': 14,
              },
              'choices': [
                {
                  'message': {'role': 'assistant', 'content': 'ok'},
                },
              ],
            }),
          );
          await request.response.close();
        });

        final usageLogs = <Map<String, dynamic>>[];
        final server = ProxyServer(
          host: '127.0.0.1',
          port: 0,
          accounts: [
            AccountConfig(
              accountId: 1,
              providerType: ProviderType.deepseek,
              displayName: 'DeepSeek',
              baseUrl: 'http://127.0.0.1:${upstream.port}',
              apiKey: 'sk-test',
              currency: 'USD',
              enabled: true,
              proxyEnabled: true,
            ),
          ],
          prices: const [],
          onUsageLog: usageLogs.add,
        );

        try {
          final port = await server.start();
          final response = await _postJson(
            'http://127.0.0.1:$port/proxy/deepseek/v1/chat/completions',
            {'model': 'deepseek-chat', 'messages': []},
          );

          expect(response.statusCode, HttpStatus.ok);
          expect(upstreamHits, equals(1));
          expect(jsonDecode(response.body)['model'], equals('deepseek-chat'));
          await _waitFor(() => usageLogs.isNotEmpty);
          expect(usageLogs.single['promptTokens'], equals(10));
          expect(usageLogs.single['estimated'], isFalse);
        } finally {
          await server.stop();
          await upstream.close(force: true);
        }
      },
    );

    test('handles CORS preflight locally', () async {
      var upstreamHits = 0;
      final upstream = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      upstream.listen((request) async {
        upstreamHits++;
        request.response.statusCode = HttpStatus.internalServerError;
        await request.response.close();
      });

      final server = ProxyServer(
        host: '127.0.0.1',
        port: 0,
        accounts: [
          AccountConfig(
            accountId: 1,
            providerType: ProviderType.deepseek,
            displayName: 'DeepSeek',
            baseUrl: 'http://127.0.0.1:${upstream.port}',
            apiKey: 'sk-test',
            currency: 'USD',
            enabled: true,
            proxyEnabled: true,
          ),
        ],
        prices: const [],
      );

      try {
        final port = await server.start();
        final client = HttpClient();
        final request = await client.openUrl(
          'OPTIONS',
          Uri.parse(
            'http://127.0.0.1:$port/proxy/deepseek/v1/chat/completions',
          ),
        );
        request.headers.set(
          'Access-Control-Request-Headers',
          'x-custom-header',
        );
        final response = await request.close();

        expect(response.statusCode, HttpStatus.noContent);
        expect(
          response.headers.value('Access-Control-Allow-Origin'),
          equals('*'),
        );
        expect(
          response.headers.value('Access-Control-Allow-Headers'),
          contains('x-custom-header'),
        );
        expect(
          response.headers.value('Access-Control-Allow-Headers'),
          contains('Authorization'),
        );
        expect(upstreamHits, equals(0));
        client.close(force: true);
      } finally {
        await server.stop();
        await upstream.close(force: true);
      }
    });
  });
}

Future<_HttpResult> _get(String url) async {
  final client = HttpClient();
  try {
    final request = await client.getUrl(Uri.parse(url));
    final response = await request.close();
    final body = await response.transform(utf8.decoder).join();
    return _HttpResult(response.statusCode, body);
  } finally {
    client.close(force: true);
  }
}

Future<_HttpResult> _postJson(String url, Map<String, dynamic> body) async {
  final client = HttpClient();
  try {
    final request = await client.postUrl(Uri.parse(url));
    request.headers.contentType = ContentType.json;
    request.write(jsonEncode(body));
    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();
    return _HttpResult(response.statusCode, responseBody);
  } finally {
    client.close(force: true);
  }
}

class _HttpResult {
  final int statusCode;
  final String body;

  const _HttpResult(this.statusCode, this.body);
}

Future<void> _waitFor(bool Function() condition) async {
  for (var attempt = 0; attempt < 20; attempt++) {
    if (condition()) return;
    await Future<void>.delayed(const Duration(milliseconds: 25));
  }
}
