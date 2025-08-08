import Flutter
import UIKit
import MobileCoreServices // For kUTType* constants

public class SwiftCustomSharePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "custom_share", binaryMessenger: registrar.messenger())
    let instance = SwiftCustomSharePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "shareText":
      guard let args = call.arguments as? [String: Any],
            let text = args["text"] as? String else {
        result(FlutterError(code: "INVALID_ARGUMENT", message: "Text cannot be nil", details: nil))
        return
      }
      let activityController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
      if let viewController = UIApplication.shared.windows.first?.rootViewController {
        viewController.present(activityController, animated: true, completion: nil)
      } else {
        result(FlutterError(code: "NO_WINDOW", message: "No window found to present share sheet", details: nil))
        return
      }
      result("success")
    case "shareFile":
      guard let args = call.arguments as? [String: Any],
            let filePath = args["filePath"] as? String,
            let mimeType = args["mimeType"] as? String else {
        result(FlutterError(code: "INVALID_ARGUMENT", message: "File path or MIME type cannot be nil", details: nil))
        return
      }
      let fileURL = URL(fileURLWithPath: filePath)
      guard FileManager.default.fileExists(atPath: filePath) else {
        result(FlutterError(code: "FILE_NOT_FOUND", message: "File does not exist: \(filePath)", details: nil))
        return
      }
      // Use kUTTypeData to share as a file attachment
      let uti = kUTTypeData as String
      print("Sharing file: \(filePath), MIME: \(mimeType), UTI: \(uti)")
      let itemProvider = NSItemProvider(contentsOf: fileURL)
      itemProvider?.registerFileRepresentation(forTypeIdentifier: uti, fileOptions: [], visibility: .all) { completion in
        completion(fileURL, false, nil) // false: do not open in place
        return nil
      }
      let activityController = UIActivityViewController(activityItems: [itemProvider], applicationActivities: nil)
      activityController.setValue("Share File: \(fileURL.lastPathComponent)", forKey: "subject")
      if let viewController = UIApplication.shared.windows.first?.rootViewController {
        viewController.present(activityController, animated: true, completion: nil)
      } else {
        result(FlutterError(code: "NO_WINDOW", message: "No window found to present share sheet", details: nil))
        return
      }
      result("success")
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}