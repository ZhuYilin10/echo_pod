# EchoPod AI Podcast App

EchoPod 是一款采用 Flutter 开发的下一代 AI 赋能播客播放器。它结合了传统的播客收听体验与现代 AI 总结技术。

## 核心功能

1.  **高品质音频播放**：基于 `just_audio` 和 `audio_service` 实现，支持后台播放、锁屏控制、进度跳转、**倍速播放**以及**智能跳过空白 (Silence Trimming)**。
2.  **播客搜索与发现**：集成 iTunes Search API，支持搜索全球海量播客资源，并针对**中国区 (CN)** 进行专项优化。
3.  **RSS 订阅管理**：使用 `webfeed_plus` 高效解析播客 RSS Feed，支持本地订阅存储及**离线下载 (Offline Download)**。
4.  **AI 剧集总结**：集成 OpenAI API，一键生成剧集内容摘要，帮助用户快速筛选感兴趣的内容。
5.  **现代 UI 设计**：
    *   Material 3 设计语言。
    *   深度适配暗黑模式（Dark Mode）。
    *   响应式迷你播放器。

## 技术栈

*   **Framework**: Flutter
*   **State Management**: Riverpod
*   **Audio**: just_audio, audio_service
*   **Storage**: SharedPreferences
*   **AI**: openai_dart
*   **Networking**: Dio
*   **UI**: FlexColorScheme, Google Fonts

## 如何运行

1.  **环境要求**：
    *   Flutter SDK (建议 3.0.0+)
    *   Android Studio / Xcode / VS Code

2.  **安装依赖**：
    ```bash
    flutter pub get
    ```

3.  **配置 OpenAI API Key (可选)**：
    在运行或构建时通过 `--dart-define` 传入 API Key，否则将使用模拟数据：
    ```bash
    flutter run --dart-define=OPENAI_API_KEY=your_key_here
    ```

4.  **运行项目**：
    ```bash
    flutter run
    ```

9.  **FreshRSS 深度集成 (v4.0 - 云端同步版)**：支持通过 Google Reader 兼容 API 与您的私有 FreshRSS 服务器进行数据同步。用户可以一键拉取云端订阅，并实时预览最新节目。

## 最新独立更新 (v4.0 - 云端同步版)

1.  **FreshRSS 核心引擎**：实现了 `FreshRssService`。支持 ClientLogin 认证、订阅列表拉取及最新剧集（Episodes）同步。
2.  **数据转换层**：自动将 RSS 数据结构映射为 EchoPod 原生数据模型，确保与播放器和下载模块无缝对接。
3.  **UI 快捷入口**：
    *   在“唱片架”页新增同步按钮及 FreshRSS 专属 Tab 页。
    *   集成了配置管理页面，支持服务器地址与凭据的本地加密持久化。

6.  **AI 金句卡片 (Card Generation)**：在播放界面点击“分享”，AI 会根据当前剧集自动提炼金句，并生成一张精美的、可以直接发朋友圈的“金句卡片”。
7.  **语义化内容搜索 (AI Search)**：搜索页新增“搜内容”模式。不再仅仅通过标题搜频道，而是通过 AI 检索播客内部的实际谈话内容，并精准定位到分钟数。

## 最新独立更新 (v2.0 - 智能进化版)

1.  **金句捕捉模块**：上线 `ShareScreen` 和 `QuoteCard`。通过 GPT-4o 深度理解音频语境，为用户生成极具社交属性的分享图。
2.  **内容级搜索引擎**：实现了 `SemanticSearchService`。用户搜索技术关键词时，AI 会在全网播客转录库中检索，直接给出包含该话题的剧集及具体时间戳。
3.  **UI/UX 深度重构**：
    *   搜索页升级为双 Tab 模式：搜频道 vs 搜内容。
    *   播放器增加“金句生成”快捷入口。
    *   优化了卡片式布局与动态反馈。

8.  **iOS 桌面金句小组件 (Home Screen Widget)**：支持在 iOS 桌面显示每日金句。系统每天会从用户的订阅中挑选一集，由 AI 提炼感悟并同步到桌面。

## 最新独立更新 (v3.5 - 桌面伴侣版)

1.  **桌面组件支持**：新增了 iOS Widget Extension 原生代码。用户现在可以将 EchoPod 的金句卡片添加至主屏幕。
2.  **AI 金句自动挑选逻辑**：实现了 `WidgetContentManager`。它能自动从用户订阅中“淘”出宝藏单集，并驱动 AI 进行“点睛之笔”的总结。
3.  **App Group 数据共享**：通过 iOS 原生的 `UserDefaults` 与 `App Group` 技术，打通了 Flutter 业务层与 iOS 桌面小组件的数据孤岛。

## 如何在 iOS 上运行小组件功能

由于跨端开发的特殊性，小组件功能需要在 Mac 上进行最后一步配置：

1.  **启用 App Group**：
    *   在 Xcode 中打开 `ios/Runner.xcworkspace`。
    *   在 `Runner` target 的 **Signing & Capabilities** 中添加 **App Groups**。
    *   新增一个名为 `group.com.echopod.ai` 的 group（或您自己的 bundle id 关联组）。
2.  **配置 Widget Target**：
    *   在 Xcode 中点击 `File -> New -> Target`，选择 **Widget Extension**。
    *   命名为 `EchoPodWidget`。
    *   将 `ios/EchoPodWidget/QuoteWidget.swift` 里的内容复制到新生成的 widget 文件中。
    *   确保该 Target 也启用了相同的 **App Groups**。

## 目录结构

*   `lib/core/models`: 数据模型
*   `lib/services`: 核心业务逻辑（音频、AI、存储、播客解析）
*   `lib/features`: 各个功能模块的 UI 界面
    *   `home`: 订阅列表
    *   `search`: 播客搜索
    *   `podcast_detail`: 剧集列表与详情
    *   `player`: 播放控制与 AI 总结

## iOS 实时活动 (Live Activities) 与 灵动岛 (Dynamic Island) 集成 (v1.2)

本版本新增了对 iOS 16.1+ 实时活动和灵动岛的支持，让用户在锁屏或灵动岛即可掌握播客进度并进行简单控制。

### 主要改动
1.  **Flutter 层**:
    *   新增 `lib/services/platform/live_activity_service.dart`：通过 `MethodChannel` 与 iOS 原生通信。
    *   更新 `EchoPodAudioHandler`：在播放、暂停和进度更新时自动同步状态至 iOS。
2.  **iOS 原生层**:
    *   `ios/Runner/Info.plist`: 添加了 `NSSupportsLiveActivities` 权限。
    *   `ios/Runner/AppDelegate.swift`: 实现了启动、更新和停止实时活动的逻辑。
    *   `ios/EchoPodWidget`: 新增了 Widget Extension 的 Swift 代码草案。

### 如何在 Mac 上完成构建
由于开发环境限制，以下步骤需要在 macOS 电脑上通过 Xcode 完成：

1.  **添加 Widget Target**:
    *   在 Xcode 中打开 `ios/Runner.xcworkspace`。
    *   点击 File -> New -> Target... 
    *   选择 **Widget Extension**，命名为 `EchoPodWidget`。
    *   **不要勾选** "Include Configuration Intent" (本例不需要配置)。
2.  **配置代码**:
    *   将项目根目录下 `ios/EchoPodWidget/` 中的 `EchoPodWidget.swift` 和 `EchoPodWidgetLiveActivity.swift` 内容复制到新创建的 Target 文件中，或将这两个文件直接添加到该 Target。
    *   确保 `EchoPodAttributes` 结构体在 `Runner` App 和 `EchoPodWidget` Extension 中均可访问（通常通过 Target Membership 勾选）。
3.  **签名与能力**:
    *   确保两个 Target (Runner 和 EchoPodWidget) 都配置了相同的 App Group (如果需要更复杂的数据共享)。
    *   在 Runner Target 的 "Signing & Capabilities" 中确认 "Live Activities" 已启用。
4.  **运行**:
    *   连接 iOS 16.1+ 的真机设备，点击运行。
