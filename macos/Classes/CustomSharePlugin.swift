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
        case "shareFiles":
            guard let args = call.arguments as? [String: Any],
                  let filePaths = args["filePaths"] as? [String],
                  !filePaths.isEmpty else {
                result(FlutterError(code: "INVALID_PATH", message: "File paths cannot be null or empty", details: nil))
                return
            }
            let text = args["text"] as? String
            var items: [Any] = filePaths.compactMap { path in
                let url = URL(fileURLWithPath: path)
                if FileManager.default.fileExists(atPath: path) {
                    let _ = url.startAccessingSecurityScopedResource()
                    return url
                }
                result(FlutterError(code: "FILE_NOT_FOUND", message: "File does not exist: \(path)", details: nil))
                return nil
            }
            if let text = text, !text.isEmpty {
                items.append(text)
            }
            let picker = NSSharingServicePicker(items: items)
            if let window = NSApp.mainWindow {
                picker.show(relativeTo: .zero, of: window.contentView!, preferredEdge: .minY)
                items.compactMap { $0 as? URL }.forEach { $0.stopAccessingSecurityScopedResource() }
                result("success")
            } else {
                result(FlutterError(code: "NO_WINDOW", message: "No main window found", details: nil))
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}