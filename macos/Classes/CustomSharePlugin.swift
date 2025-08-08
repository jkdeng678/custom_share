import FlutterMacOS
import AppKit

public class CustomSharePlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "custom_share", binaryMessenger: registrar.messenger)
        let instance = CustomSharePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "shareText":
            guard let args = call.arguments as? [String: String],
                  let text = args["text"],
                  !text.isEmpty else {
                result(FlutterError(code: "INVALID_TEXT", message: "Text cannot be null or empty", details: nil))
                return
            }
            let picker = NSSharingServicePicker(items: [text])
            if let window = NSApp.mainWindow {
                picker.show(relativeTo: .zero, of: window.contentView!, preferredEdge: .minY)
                result("success")
            } else {
                result(FlutterError(code: "NO_WINDOW", message: "No main window found", details: nil))
            }
        case "shareFile":
            guard let args = call.arguments as? [String: String],
                  let filePath = args["filePath"] else {
                result(FlutterError(code: "INVALID_PATH", message: "File path cannot be null", details: nil))
                return
            }
            let fileURL = URL(fileURLWithPath: filePath)
            if !FileManager.default.fileExists(atPath: filePath) {
                result(FlutterError(code: "FILE_NOT_FOUND", message: "File does not exist: \(filePath)", details: nil))
                return
            }
            let _ = fileURL.startAccessingSecurityScopedResource()
            let picker = NSSharingServicePicker(items: [fileURL])
            if let window = NSApp.mainWindow {
                picker.show(relativeTo: .zero, of: window.contentView!, preferredEdge: .minY)
                fileURL.stopAccessingSecurityScopedResource()
                result("success")
            } else {
                result(FlutterError(code: "NO_WINDOW", message: "No main window found", details: nil))
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}