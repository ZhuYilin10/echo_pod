import ActivityKit
import Flutter
import UIKit

#if canImport(WidgetKit)
  import WidgetKit
#endif

@main
@objc class AppDelegate: FlutterAppDelegate {
  private var activity: Any?

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
