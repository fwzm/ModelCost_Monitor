# ModelCost Monitor

ModelCost Monitor 是一个本地运行的跨平台 AI 模型 API 用量监控软件，用来统计 DeepSeek、小米 MiMo、Gemini、OpenRouter 以及自定义 OpenAI-compatible 服务的 token 用量、费用、余额、历史趋势和预算风险。

项目目标是让个人用户和小团队在不依赖第三方服务器的前提下，看清楚每个模型、每个厂商、每天和每月到底花了多少钱。

## 核心特点

- **本地优先**：API Key 只保存在本机，不上传用户请求内容，不依赖第三方云服务。
- **跨平台**：支持 Windows 桌面端和 Android 端。
- **本地代理记账**：通过本地 HTTP 代理转发 API 请求，并从响应中的 `usage` 字段记录 token 消耗。
- **流式响应支持**：支持 SSE 流式响应转发，边转发边旁路解析统计数据。
- **余额与账单**：支持厂商官方余额接口；没有官方接口的厂商支持手动额度和本地代理记账。
- **价格表可编辑**：所有模型价格都存在本地数据库，用户可修改、导入、重新计算历史费用。
- **一键价格配置**：内置 DeepSeek、Gemini 常用公开价格；OpenRouter 支持从官方模型接口联网导入价格。
- **图表与导出**：支持费用趋势、模型占比、token 对比、estimated 记录比例，以及 CSV/JSON 导出。
- **Windows 体验**：支持系统托盘、开机自启、本地代理常驻、端口占用自动回退。
- **Android 体验**：支持桌面小组件、通知、前台服务合规配置；默认不静默后台长期监听代理端口。

## 支持的厂商

| 厂商 | 状态 | 说明 |
| --- | --- | --- |
| DeepSeek | 内置 | 支持 `/user/balance` 余额查询、OpenAI-compatible `usage` 解析、`deepseek-chat` 与 `deepseek-reasoner` 默认价格。 |
| 小米 MiMo | 内置 | 按 OpenAI-compatible 接口处理；当前不假设存在稳定官方余额接口，支持用户手动额度和价格。 |
| Gemini | 内置 | 支持 `usageMetadata` 中的 prompt、candidate、thoughts、cached token 解析；内置常用模型默认价格。 |
| OpenRouter | 内置 | 支持 credits 查询；支持联网从 `https://openrouter.ai/api/v1/models` 导入模型价格。 |
| 自定义 OpenAI-compatible | 内置 | 用户可填任意 Base URL，支持标准 Chat Completions `usage` 字段，并预留 JSONPath 映射扩展。 |

## 快速开始

1. 打开 Windows 桌面版或 Android 版 App。
2. 进入 **账号** 页面，点击添加账号。
3. 选择厂商后，软件会自动填写常用 Base URL 和显示名称；用户只需要填自己的 API Key。
4. 进入 **价格表** 页面：
   - 点击 **一键填入常用价格**，写入 DeepSeek 和 Gemini 的常用公开价格。
   - 点击 **联网导入 OpenRouter 价格**，从 OpenRouter 官方模型接口导入模型价格。
   - MiMo 或自定义服务如无公开价格，请手动添加。
5. 回到 **总览** 页面，启动本地代理。
6. 将外部客户端的 Base URL 改成总览页显示的代理地址，例如：

```text
http://127.0.0.1:8787
```

7. 正常调用模型。ModelCost Monitor 会记录请求次数、token、estimated 状态和费用。

## 本地代理路径

常用代理路径如下：

```text
/proxy/deepseek/v1/chat/completions
/proxy/mimo/v1/chat/completions
/proxy/gemini/v1beta/models/{model}:generateContent
/proxy/openrouter/v1/chat/completions
/proxy/custom/{accountId}/v1/chat/completions
```

代理默认监听：

```text
http://127.0.0.1:8787
```

如果端口被占用，会自动尝试 `8788` 到 `8899`，最后退到系统动态端口。实际地址会显示在总览页顶部。

## 安全边界

ModelCost Monitor 明确不做这些事情：

- 不使用第三方服务器保存 API Key 或请求内容。
- 不模拟登录厂商网页。
- 不抓取私有 Header。
- 不绕过厂商安全机制。
- 不实现全局流量劫持。
- 不自动安装系统根证书。
- 不默认监听 `0.0.0.0` 或暴露到局域网。
- 不保存完整 prompt 和 completion。

API Key 通过平台安全存储保存，UI 默认只显示后 4 位掩码。导出配置默认不包含 API Key。

## 价格数据说明

软件内置价格只是为了减少首次配置成本，价格来源来自厂商公开页面或公开 API，可能随厂商调价而变化。用户可以随时在价格表页面修改。

当前内置价格来源：

- DeepSeek 官方价格页：<https://api-docs.deepseek.com/quick_start/pricing-details-usd/>
- Gemini 官方价格页：<https://ai.google.dev/gemini-api/docs/pricing>
- OpenRouter 官方模型接口：<https://openrouter.ai/api/v1/models>
- OpenRouter 价格说明：<https://openrouter.ai/pricing>
- 小米 MiMo 官网：<https://mimo.mi.com/>

如果价格缺失，UsageLog 仍会保存 token，但 `cost` 为空，界面会显示缺少价格配置。

## 技术架构

主要模块：

- **Provider Adapter Layer**：厂商余额、模型列表和 usage 解析。
- **Local Proxy Layer**：本地 HTTP/HTTPS 代理、CORS、OPTIONS、SSE 转发。
- **Usage Collector Layer**：官方 usage、代理 usage、本地估算和失败重试队列。
- **Pricing Engine**：按模型价格计算费用。
- **Database Layer**：Drift + SQLite，本地保存账号、余额、用量、价格、设置和运行日志。
- **Dashboard UI**：总览、账号、价格表、日志、图表、设置和帮助页面。
- **Notification Layer**：Windows 托盘、Android 通知和桌面小组件。
- **Proxy Runtime Layer**：代理 isolate、状态机、端口探测、健康检查和崩溃恢复。

## 数据库

使用 Drift + SQLite，初始化时启用：

```sql
PRAGMA journal_mode=WAL;
PRAGMA synchronous=NORMAL;
PRAGMA foreign_keys=ON;
```

核心表：

- `Account`
- `BalanceSnapshot`
- `UsageLog`
- `ModelPrice`
- `AlertRule`
- `AppSetting`
- `ProviderCapability`
- `SchemaMigrationLog`
- `ProxyRuntimeLog`

数据库变更必须通过 Drift `MigrationStrategy` 处理，避免丢失历史账单和价格表。

## 开发环境

推荐环境：

- Flutter stable
- Dart 3.11 或兼容版本
- Windows 10/11 + Visual Studio C++ Desktop workload
- Android Studio / Android SDK

安装依赖：

```powershell
flutter pub get
```

生成 Drift 代码：

```powershell
dart run build_runner build --delete-conflicting-outputs
```

运行测试：

```powershell
flutter analyze
flutter test
```

构建 Windows：

```powershell
flutter build windows
```

输出路径：

```text
build/windows/x64/runner/Release/modelcost_monitor.exe
```

构建 Android Debug APK：

```powershell
flutter build apk --debug
```

输出路径：

```text
build/app/outputs/flutter-apk/app-debug.apk
```

## 当前状态

Windows MVP 已包含：

- 账号管理
- 价格表管理
- 默认价格填充
- OpenRouter 联网价格导入
- 基础 Dashboard
- 本地代理启动/停止
- 端口回退
- CORS 与健康检查基础能力
- CSV/JSON 导出
- Windows Release 构建
- Android Debug APK 构建

后续重点：

- 更完整的余额刷新 UI
- 更完整的 Android 前台服务运行控制
- 更细的 SSE 中断/超时统计
- migration 回归测试扩展
- 托盘菜单和桌面小组件状态联动完善
- 发布版安装包和自动更新

## 许可证

MIT License
