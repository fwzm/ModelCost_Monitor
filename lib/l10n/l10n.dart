import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_zh_cn.dart';
import '../l10n/app_zh_tw.dart';
import '../l10n/app_en.dart';

enum AppLocale {
  zhCN('zh_CN', '简体中文'),
  zhTW('zh_TW', '繁體中文'),
  en('en', 'English');

  final String code;
  final String label;
  const AppLocale(this.code, this.label);
}

class L10n {
  static const String _prefsKey = 'app_locale';
  static AppLocale _current = AppLocale.zhCN;
  static late Map<String, String> _strings;

  static AppLocale get current => _current;

  static Future<void> init({AppLocale? forceLocale}) async {
    if (forceLocale != null) {
      _current = forceLocale;
    } else {
      final prefs = await SharedPreferences.getInstance();
      final code = prefs.getString(_prefsKey);
      if (code != null) {
        _current = AppLocale.values.firstWhere(
          (e) => e.code == code,
          orElse: () => AppLocale.zhCN,
        );
      }
    }
    _loadStrings();
  }

  static void _loadStrings() {
    switch (_current) {
      case AppLocale.zhCN:
        _strings = zhCN;
      case AppLocale.zhTW:
        _strings = zhTW;
      case AppLocale.en:
        _strings = en;
    }
  }

  static Future<void> setLocale(AppLocale locale) async {
    _current = locale;
    _loadStrings();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, locale.code);
  }

  static String of(String key) {
    return _strings[key] ?? key;
  }
}

class L10nLocalizations {
  static L10nLocalizations of(BuildContext context) {
    return L10nLocalizations();
  }

  String get appTitle => L10n.of('app_title');
  String get navDashboard => L10n.of('nav_dashboard');
  String get navAccounts => L10n.of('nav_accounts');
  String get navPricing => L10n.of('nav_pricing');
  String get navLogs => L10n.of('nav_logs');
  String get navCharts => L10n.of('nav_charts');
  String get navSettings => L10n.of('nav_settings');
  String get navMore => L10n.of('nav_more');

  String get proxyStatusStopped => L10n.of('proxy_status_stopped');
  String get proxyStatusStarting => L10n.of('proxy_status_starting');
  String get proxyStatusRunning => L10n.of('proxy_status_running');
  String get proxyStatusStopping => L10n.of('proxy_status_stopping');
  String get proxyStatusDegraded => L10n.of('proxy_status_degraded');
  String get proxyStatusCrashed => L10n.of('proxy_status_crashed');

  String get proxyStarted => L10n.of('proxy_started');
  String get proxyStartFailed => L10n.of('proxy_start_failed');
  String get proxyStop => L10n.of('proxy_stop');
  String get proxyStart => L10n.of('proxy_start');
  String get proxyRestart => L10n.of('proxy_restart');
  String get currentProxyUrl => L10n.of('current_proxy_url');
  String get todayCost => L10n.of('today_cost');
  String get monthCost => L10n.of('month_cost');
  String get totalAccounts => L10n.of('total_accounts');
  String get totalRequests => L10n.of('total_requests');
  String get estimatedRecords => L10n.of('estimated_records');
  String get totalTokens => L10n.of('total_tokens');
  String get recentActivity => L10n.of('recent_activity');

  String get addAccount => L10n.of('add_account');
  String get editAccount => L10n.of('edit_account');
  String get deleteAccount => L10n.of('delete_account');
  String get deleteAccountConfirm => L10n.of('delete_account_confirm');
  String get cancel => L10n.of('cancel');
  String get delete => L10n.of('delete');
  String get displayName => L10n.of('display_name');
  String get baseUrl => L10n.of('base_url');
  String get apiKey => L10n.of('api_key');
  String get currency => L10n.of('currency');
  String get provider => L10n.of('provider');
  String get accountAdded => L10n.of('account_added');
  String get accountDeleted => L10n.of('account_deleted');
  String get accountUpdated => L10n.of('account_updated');

  String get addPrice => L10n.of('add_price');
  String get modelName => L10n.of('model_name');
  String get inputPricePer1M => L10n.of('input_price_per_1m');
  String get outputPricePer1M => L10n.of('output_price_per_1m');
  String get cachedInputPrice => L10n.of('cached_input_price');
  String get reasoningOutputPrice => L10n.of('reasoning_output_price');
  String get priceAdded => L10n.of('price_added');
  String get priceDeleted => L10n.of('price_deleted');

  String get proxySettings => L10n.of('proxy_settings');
  String get proxyHost => L10n.of('proxy_host');
  String get proxyPort => L10n.of('proxy_port');
  String get enableCors => L10n.of('enable_cors');
  String get enableCorsSubtitle => L10n.of('enable_cors_subtitle');
  String get enableHttps => L10n.of('enable_https');
  String get enableHttpsSubtitle => L10n.of('enable_https_subtitle');
  String get security => L10n.of('security');
  String get apiKeyStorage => L10n.of('api_key_storage');
  String get apiKeyStorageSubtitle => L10n.of('api_key_storage_subtitle');
  String get apiKeyMasking => L10n.of('api_key_masking');
  String get apiKeyMaskingSubtitle => L10n.of('api_key_masking_subtitle');
  String get noDataUpload => L10n.of('no_data_upload');
  String get noDataUploadSubtitle => L10n.of('no_data_upload_subtitle');
  String get about => L10n.of('about');
  String get version => L10n.of('version');
  String get license => L10n.of('license');

  String get language => L10n.of('language');
  String get languageZhCN => L10n.of('language_zh_cn');
  String get languageZhTW => L10n.of('language_zh_tw');
  String get languageEn => L10n.of('language_en');

  String get settingsSaved => L10n.of('settings_saved');
  String get noAccounts => L10n.of('no_accounts');
  String get tapToAddAccount => L10n.of('tap_to_add_account');
  String get noPrices => L10n.of('no_prices');
  String get tapToAddPrice => L10n.of('tap_to_add_price');
  String get required => L10n.of('required');
  String get invalidNumber => L10n.of('invalid_number');

  String get providerDeepseek => L10n.of('provider_deepseek');
  String get providerMimo => L10n.of('provider_mimo');
  String get providerGemini => L10n.of('provider_gemini');
  String get providerOpenrouter => L10n.of('provider_openrouter');
  String get providerCustomOpenai => L10n.of('provider_custom_openai');

  String get logsPageTitle => L10n.of('logs_page_title');
  String get filter => L10n.of('filter');
  String get filterProvider => L10n.of('filter_provider');
  String get filterModel => L10n.of('filter_model');
  String get filterDate => L10n.of('filter_date');
  String get filterSource => L10n.of('filter_source');
  String get filterEstimated => L10n.of('filter_estimated');
  String get filterLowConfidence => L10n.of('filter_low_confidence');
  String get filterStatus => L10n.of('filter_status');
  String get exportCsv => L10n.of('export_csv');
  String get exportJson => L10n.of('export_json');
  String get recalculateCost => L10n.of('recalculate_cost');
  String get manualCorrect => L10n.of('manual_correct');
  String get noLogs => L10n.of('no_logs');

  String get chartDailyCost => L10n.of('chart_daily_cost');
  String get chartModelCost => L10n.of('chart_model_cost');
  String get chartTokenComparison => L10n.of('chart_token_comparison');
  String get chartCacheTrend => L10n.of('chart_cache_trend');
  String get chartReasoningTrend => L10n.of('chart_reasoning_trend');
  String get chartFeeTrend => L10n.of('chart_fee_trend');
  String get chartEstimatedVsOfficial => L10n.of('chart_estimated_vs_official');

  String get alertBalanceLow => L10n.of('alert_balance_low');
  String get alertDailyCost => L10n.of('alert_daily_cost');
  String get alertMonthlyBudget => L10n.of('alert_monthly_budget');
  String get alertModelAnomaly => L10n.of('alert_model_anomaly');
  String get alertFailureRate => L10n.of('alert_failure_rate');
  String get alertEstimatedRatio => L10n.of('alert_estimated_ratio');
  String get alertStreamInterrupt => L10n.of('alert_stream_interrupt');
  String get alertProxyCrash => L10n.of('alert_proxy_crash');
  String get alertPortChanged => L10n.of('alert_port_changed');
  String get alertAndroidRestricted => L10n.of('alert_android_restricted');

  String get notificationChannelProxy => L10n.of('notification_channel_proxy');
  String get notificationChannelAlert => L10n.of('notification_channel_alert');
  String get notificationProxyRunning => L10n.of('notification_proxy_running');
  String get notificationProxyStopped => L10n.of('notification_proxy_stopped');
  String get notificationStopProxy => L10n.of('notification_stop_proxy');
  String get notificationLowBalance => L10n.of('notification_low_balance');
  String get notificationBudgetExceeded =>
      L10n.of('notification_budget_exceeded');

  String get widgetTitle => L10n.of('widget_title');
  String get widgetToday => L10n.of('widget_today');
  String get widgetMonth => L10n.of('widget_month');
  String get widgetStatus => L10n.of('widget_status');

  String get statusCompleted => L10n.of('status_completed');
  String get statusInterrupted => L10n.of('status_interrupted');
  String get statusTimeout => L10n.of('status_timeout');
  String get statusClientCancelled => L10n.of('status_client_cancelled');
  String get statusProviderError => L10n.of('status_provider_error');
  String get statusParseError => L10n.of('status_parse_error');
  String get statusEstimatedOnly => L10n.of('status_estimated_only');

  String get sourceOfficialApi => L10n.of('source_official_api');
  String get sourceProxy => L10n.of('source_proxy');
  String get sourceManualImport => L10n.of('source_manual_import');
  String get sourceLocalEstimator => L10n.of('source_local_estimator');
  String get sourceCountTokensApi => L10n.of('source_count_tokens_api');

  String get lanAccess => L10n.of('lan_access');
  String get lanAccessWarning => L10n.of('lan_access_warning');
  String get lanAccessToken => L10n.of('lan_access_token');
  String get enableLanAccess => L10n.of('enable_lan_access');
  String get proxyAddress => L10n.of('proxy_address');
  String get copyAddress => L10n.of('copy_address');
  String get addressCopied => L10n.of('address_copied');
  String get confirmCopyApiKey => L10n.of('confirm_copy_api_key');
  String get confirm => L10n.of('confirm');
  String get copy => L10n.of('copy');

  String get errorStartingProxy => L10n.of('error_starting_proxy');
  String get errorProxyCrashed => L10n.of('error_proxy_crashed');
  String get crashDialogReason => L10n.of('crash_dialog_reason');
  String get crashDialogSolution => L10n.of('crash_dialog_solution');
  String get crashSolutionPortInUse => L10n.of('crash_solution_port_in_use');
  String get crashSolutionPermission => L10n.of('crash_solution_permission');
  String get crashSolutionTimeout => L10n.of('crash_solution_timeout');
  String get portInUse => L10n.of('port_in_use');
  String get autoSwitchPort => L10n.of('auto_switch_port');
  String get sleepWakeRecovered => L10n.of('sleep_wake_recovered');
  String get healthCheckFailed => L10n.of('health_check_failed');
  String get healthCheckSuccess => L10n.of('health_check_success');
  String get configUpdated => L10n.of('config_updated');

  String get accountsCount => L10n.of('accounts_count');
  String get routesCount => L10n.of('routes_count');
  String get pendingQueue => L10n.of('pending_queue');
  String get uptime => L10n.of('uptime');
  String get databaseStatus => L10n.of('database_status');

  String get clearLogs => L10n.of('clear_logs');
  String get debugLogs => L10n.of('debug_logs');
  String get clearDebugLogs => L10n.of('clear_debug_logs');
  String get debugLogsCleared => L10n.of('debug_logs_cleared');
  String get logRetentionDays => L10n.of('log_retention_days');
  String get uiRefreshInterval => L10n.of('ui_refresh_interval');
  String get tokenizerStrategy => L10n.of('tokenizer_strategy');
  String get timeoutPolicy => L10n.of('timeout_policy');
  String get balanceThreshold => L10n.of('balance_threshold');
  String get monthlyBudget => L10n.of('monthly_budget');

  String get enableWindowsStartup => L10n.of('enable_windows_startup');
  String get enableTray => L10n.of('enable_tray');
  String get enableAndroidWidget => L10n.of('enable_android_widget');

  String get navHelp => L10n.of('nav_help');
  String get helpQuickStart => L10n.of('help_quick_start');
  String get helpStep1AddAccount => L10n.of('help_step1_add_account');
  String get helpStep2ConfigPrice => L10n.of('help_step2_config_price');
  String get helpStep3StartProxy => L10n.of('help_step3_start_proxy');
  String get helpStep4UseProxy => L10n.of('help_step4_use_proxy');
  String get helpDashboardTitle => L10n.of('help_dashboard_title');
  String get helpDashboardDesc => L10n.of('help_dashboard_desc');
  String get helpAccountsTitle => L10n.of('help_accounts_title');
  String get helpAccountsDesc => L10n.of('help_accounts_desc');
  String get helpPricingTitle => L10n.of('help_pricing_title');
  String get helpPricingDesc => L10n.of('help_pricing_desc');
  String get helpLogsTitle => L10n.of('help_logs_title');
  String get helpLogsDesc => L10n.of('help_logs_desc');
  String get helpChartsTitle => L10n.of('help_charts_title');
  String get helpChartsDesc => L10n.of('help_charts_desc');
  String get helpProxyTitle => L10n.of('help_proxy_title');
  String get helpProxyDesc => L10n.of('help_proxy_desc');
  String get helpSettingsTitle => L10n.of('help_settings_title');
  String get helpSettingsDesc => L10n.of('help_settings_desc');
  String get helpFaqTitle => L10n.of('help_faq_title');
  String get helpFaq1Q => L10n.of('help_faq1_q');
  String get helpFaq1A => L10n.of('help_faq1_a');
  String get helpFaq2Q => L10n.of('help_faq2_q');
  String get helpFaq2A => L10n.of('help_faq2_a');
  String get helpFaq3Q => L10n.of('help_faq3_q');
  String get helpFaq3A => L10n.of('help_faq3_a');
  String get helpFaq4Q => L10n.of('help_faq4_q');
  String get helpFaq4A => L10n.of('help_faq4_a');
  String get helpTipsTitle => L10n.of('help_tips_title');
  String get helpTip1 => L10n.of('help_tip1');
  String get helpTip2 => L10n.of('help_tip2');
  String get helpTip3 => L10n.of('help_tip3');
  String get helpTip4 => L10n.of('help_tip4');
  String get helpContactTitle => L10n.of('help_contact_title');
  String get helpContactDesc => L10n.of('help_contact_desc');

  String providerName(String providerType) {
    switch (providerType) {
      case 'deepseek':
        return providerDeepseek;
      case 'openai':
        return L10n.of('provider_openai');
      case 'anthropic':
        return L10n.of('provider_anthropic');
      case 'mimo':
        return providerMimo;
      case 'gemini':
        return providerGemini;
      case 'openrouter':
        return providerOpenrouter;
      case 'azureOpenAI':
        return L10n.of('provider_azure_openai');
      case 'groq':
        return L10n.of('provider_groq');
      case 'mistral':
        return L10n.of('provider_mistral');
      case 'togetherAI':
        return L10n.of('provider_together_ai');
      case 'fireworksAI':
        return L10n.of('provider_fireworks_ai');
      case 'perplexity':
        return L10n.of('provider_perplexity');
      case 'xai':
        return L10n.of('provider_xai');
      case 'cohere':
        return L10n.of('provider_cohere');
      case 'cerebras':
        return L10n.of('provider_cerebras');
      case 'moonshot':
        return L10n.of('provider_moonshot');
      case 'qwen':
        return L10n.of('provider_qwen');
      case 'zhipu':
        return L10n.of('provider_zhipu');
      case 'siliconFlow':
        return L10n.of('provider_silicon_flow');
      case 'volcengineArk':
        return L10n.of('provider_volcengine_ark');
      case 'tencentHunyuan':
        return L10n.of('provider_tencent_hunyuan');
      case 'minimax':
        return L10n.of('provider_minimax');
      case 'novita':
        return L10n.of('provider_novita');
      case 'customOpenAI':
        return providerCustomOpenai;
      default:
        return providerType;
    }
  }

  String requestStatusName(String status) {
    switch (status) {
      case 'completed':
        return statusCompleted;
      case 'interrupted':
        return statusInterrupted;
      case 'timeout':
        return statusTimeout;
      case 'clientCancelled':
        return statusClientCancelled;
      case 'providerError':
        return statusProviderError;
      case 'parseError':
        return statusParseError;
      case 'estimatedOnly':
        return statusEstimatedOnly;
      default:
        return status;
    }
  }

  String sourceName(String source) {
    switch (source) {
      case 'officialApi':
        return sourceOfficialApi;
      case 'proxy':
        return sourceProxy;
      case 'manualImport':
        return sourceManualImport;
      case 'localEstimator':
        return sourceLocalEstimator;
      case 'countTokensApi':
        return sourceCountTokensApi;
      default:
        return source;
    }
  }
}
