import ActivityKit
import Flutter
import UIKit

#if canImport(WidgetKit)
  import WidgetKit
#endif

@main
@objc class AppDelegate: FlutterAppDelegate {
  private var activity: Any?
  private func shareLog(_ message: String) {
    print("[AppDelegate][Share] \(message)")
  }

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(
      name: "com.echopod.live_activity",
      binaryMessenger: controller.binaryMessenger)

    let widgetChannel = FlutterMethodChannel(
      name: "com.echopod.ai/widget",
      binaryMessenger: controller.binaryMessenger)

    let shareChannel = FlutterMethodChannel(
      name: "com.echopod/share",
      binaryMessenger: controller.binaryMessenger)

    shareChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      let sharedDefaults = UserDefaults(suiteName: "group.com.zhuyl.echoPod")
      
      switch call.method {
      case "checkSharedFile":
        self.shareLog("checkSharedFile called")
        // 检查是否有新的分享文件
        if let timestamp = sharedDefaults?.double(forKey: "shared_file_timestamp"),
           timestamp > 0,
           let filePath = sharedDefaults?.string(forKey: "shared_file_path"),
           let fileName = sharedDefaults?.string(forKey: "shared_file_name") {
          self.shareLog(
            "checkSharedFile hit fileName=\(fileName), timestamp=\(timestamp), filePath=\(filePath)"
          )
          result([
            "timestamp": timestamp,
            "filePath": filePath,
            "fileName": fileName
          ])
        } else {
          self.shareLog("checkSharedFile no pending shared file")
          result(nil)
        }
      case "clearSharedFile":
        let prevTimestamp = sharedDefaults?.double(forKey: "shared_file_timestamp") ?? 0
        let prevFileName = sharedDefaults?.string(forKey: "shared_file_name") ?? "nil"
        self.shareLog(
          "clearSharedFile called prevFileName=\(prevFileName), prevTimestamp=\(prevTimestamp)"
        )
        // 清理已处理的文件
        sharedDefaults?.removeObject(forKey: "shared_file_timestamp")
        sharedDefaults?.removeObject(forKey: "shared_file_path")
        sharedDefaults?.removeObject(forKey: "shared_file_name")
        sharedDefaults?.synchronize()
        self.shareLog("clearSharedFile done")
        result(nil)
      default:
        result(FlutterMethodNotImplemented)
      }
    })

    channel.setMethodCallHandler({
      [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      switch call.method {
      case "startLiveActivity":
        self?.startLiveActivity(call: call, result: result)
      case "updateLiveActivity":
        self?.updateLiveActivity(call: call, result: result)
      case "stopLiveActivity":
        self?.stopLiveActivity(result: result)
      default:
        result(FlutterMethodNotImplemented)
      }
    })

    widgetChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      if call.method == "updateQuote" {
        guard let args = call.arguments as? [String: Any],
          let quote = args["quote"] as? String,
          let author = args["author"] as? String,
          let imageUrl = args["imageUrl"] as? String
        else {
          result(FlutterError(code: "INVALID_ARGS", message: "Missing arguments", details: nil))
          return
        }

        let defaults = UserDefaults(suiteName: "group.com.echopod.ai")
        defaults?.set(quote, forKey: "widget_quote")
        defaults?.set(author, forKey: "widget_author")
        defaults?.set(imageUrl, forKey: "widget_image")

        if #available(iOS 14.0, *) {
          #if canImport(WidgetKit)
            WidgetCenter.shared.reloadAllTimelines()
          #endif
        }

        result(nil)
      } else {
        result(FlutterMethodNotImplemented)
      }
    })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // 处理 URL Scheme 打开
  override func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey: Any] = [:]
  ) -> Bool {
    shareLog("application:openURL received url=\(url)")
    
    if url.scheme == "echopod" {
      // 保存标记，表示 App 是通过分享打开的
      let sharedDefaults = UserDefaults(suiteName: "group.com.zhuyl.echoPod")
      sharedDefaults?.set(true, forKey: "app_opened_via_share")
      sharedDefaults?.synchronize()
      shareLog("URL handled as echopod scheme")
      return true
    }
    
    shareLog("URL not handled by share scheme")
    return super.application(app, open: url, options: options)
  }

  private func startLiveActivity(call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard #available(iOS 16.1, *) else {
      result(
        FlutterError(
          code: "UNSUPPORTED", message: "Live Activities are not supported on this version",
          details: nil))
      return
    }

    guard let args = call.arguments as? [String: Any],
      let podcastTitle = args["podcastTitle"] as? String,
      let episodeTitle = args["episodeTitle"] as? String,
      let imageUrl = args["imageUrl"] as? String,
      let progress = args["progress"] as? Double,
      let isPlaying = args["isPlaying"] as? Bool
    else {
      result(FlutterError(code: "INVALID_ARGS", message: "Missing arguments", details: nil))
      return
    }

    let attributes = EchoPodAttributes(
      podcastTitle: podcastTitle, episodeTitle: episodeTitle, imageUrl: imageUrl)
    let contentState = EchoPodAttributes.ContentState(progress: progress, isPlaying: isPlaying)

    do {
      activity = try Activity.request(attributes: attributes, contentState: contentState)
      result(nil)
    } catch {
      result(FlutterError(code: "ERROR", message: error.localizedDescription, details: nil))
    }
  }

  private func updateLiveActivity(call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard #available(iOS 16.1, *) else { return }

    guard let args = call.arguments as? [String: Any],
      let progress = args["progress"] as? Double,
      let isPlaying = args["isPlaying"] as? Bool
    else {
      result(FlutterError(code: "INVALID_ARGS", message: "Missing arguments", details: nil))
      return
    }

    let updatedContentState = EchoPodAttributes.ContentState(
      progress: progress, isPlaying: isPlaying)

    Task {
      if let activity = activity as? Activity<EchoPodAttributes> {
        await activity.update(using: updatedContentState)
      }
      result(nil)
    }
  }

  private func stopLiveActivity(result: @escaping FlutterResult) {
    guard #available(iOS 16.1, *) else { return }

    Task {
      if let activity = activity as? Activity<EchoPodAttributes> {
        await activity.end(dismissalPolicy: .immediate)
      }
      self.activity = nil
      result(nil)
    }
  }
}

// Define the Attributes structure

@available(iOS 16.1, *)
struct EchoPodAttributes: ActivityAttributes {
  public struct ContentState: Codable, Hashable {
    var progress: Double
    var isPlaying: Bool
  }

  var podcastTitle: String
  var episodeTitle: String
  var imageUrl: String
}
