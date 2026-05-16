# ModelCost Monitor

ModelCost Monitor is a local-first Flutter app for tracking AI model API usage, token counts, balances, costs, trends, and proxy runtime health across Windows and Android.

## Current Focus

- Windows MVP with a local loopback proxy at `http://127.0.0.1:8787`
- Android-ready Flutter UI, launcher icon, widget resources, and foreground-service scaffolding
- Provider adapters for DeepSeek, MiMo, Gemini, OpenRouter, and custom OpenAI-compatible endpoints
- Drift + SQLite persistence with WAL settings
- SSE parsing, CORS preflight handling, health checks, and proxy port fallback

## Product Principles

- No third-party server
- API keys stay local and are stored through secure storage
- Full prompt and completion content is not persisted
- The proxy listens on `127.0.0.1` by default
- Browser clients are supported through CORS and local OPTIONS handling
- Android background proxy mode must use a foreground service with a persistent notification

## Quick Start

1. Install Flutter with Windows desktop and Android support enabled.
2. Fetch dependencies:

```powershell
flutter pub get
```

3. Run checks:

```powershell
flutter analyze
flutter test
```

4. Run on Windows:

```powershell
flutter run -d windows
```

5. Run on Android:

```powershell
flutter run -d android
```

## Local Proxy Routes

After adding an enabled account and starting the proxy, default routes are created automatically:

- `/proxy/deepseek/...`
- `/proxy/mimo/...`
- `/proxy/gemini/...`
- `/proxy/openrouter/...`
- `/proxy/custom/{accountId}/...`

If the configured port is occupied, the proxy first retries the preferred range and then falls back to an operating-system assigned dynamic port. The dashboard shows the actual base URL.

## Packaging

Windows:

```powershell
flutter build windows --release
```

Android APK:

```powershell
flutter build apk --release
```

Android App Bundle:

```powershell
flutter build appbundle --release
```

## Notes

Some platform integrations are intentionally guarded by local-only defaults. LAN proxy access and HTTPS proxy mode require explicit user action and must keep the documented security warnings in the UI.
