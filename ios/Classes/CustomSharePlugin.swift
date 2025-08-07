import Flutter
import UIKit

@objc public class CustomSharePlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "custom_share", binaryMessenger: registrar.messenger())
        let instance = CustomSharePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "shareText":
            shareText(call: call, result: result)
        case "shareFiles":
            shareFiles(call: call, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func shareText(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let text = call.arguments as? [String: String], let textValue = text["text"], !textValue.isEmpty else {
            result(FlutterError(code: "INVALID_TEXT", message: "Text cannot be null or empty", details: nil))
            return
        }

        let activityItems = [textValue]
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        if let controller = UIApplication.shared.windows.first?.rootViewController {
            activityVC.completionWithItemsHandler = { _, _, _, error in
                if let error = error {
                    result(FlutterError(code: "SHARE_FAILED", message: "Failed to open share sheet", details: error.localizedDescription))
                } else {
                    result("success")
                }
            }
            controller.present(activityVC, animated: true, completion: nil)
        } else {
            result(FlutterError(code: "NO_CONTROLLER", message: "No root view controller found", details: nil))
        }
    }

    private func shareFiles(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let filePaths = args["filePaths"] as? [String] else {
            result(FlutterError(code: "INVALID_PATH", message: "File paths cannot be null or empty", details: nil))
            return
        }
        let text = args["text"] as? String
        let activityItems: [Any] = filePaths.compactMap { path in
            let url = URL(fileURLWithPath: path)
            if FileManager.default.fileExists(atPath: path) {
                return url
            } else {
                result(FlutterError(code: "FILE_NOT_FOUND", message: "File does not exist: \(path)", details: nil))
                return nil
            }
        } + (text?.isEmpty == false ? [text!] : [])

        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        if let controller = UIApplication.shared.windows.first?.rootViewController {
            activityVC.completionWithItemsHandler = { _, _, _, error in
                if let error = error {
                    result(FlutterError(code: "SHARE_FAILED", message: "Failed to open share sheet", details: error.localizedDescription))
                } else {
                    result("success")
                }
            }
            controller.present(activityVC, animated: true, completion: nil)
        } else {
            result(FlutterError(code: "NO_CONTROLLER", message: "No root view controller found", details: nil))
        }
    }
}