#include "custom_share_plugin.h"
#include <windows.h>
#include <winrt/Windows.ApplicationModel.DataTransfer.h>
#include <winrt/Windows.Storage.h>
#include <winrt/Windows.Foundation.Collections.h>

using namespace winrt;
using namespace Windows::ApplicationModel::DataTransfer;
using namespace Windows::Storage;
using namespace Windows::Foundation::Collections;

void CustomSharePluginRegisterWithRegistrar(FlutterPluginRegistrar* registrar) {
  auto channel = std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          flutter::MethodChannel<flutter::EncodableValue>(registrar->messenger(), "custom_share",
                                                          &flutter::StandardMethodCodec::GetInstance()));
  auto plugin = std::make_unique<CustomSharePlugin>();
  channel->SetMethodCallHandler(
          [plugin_pointer = plugin.get()](const auto& call, auto result) {
              plugin_pointer->HandleMethodCall(call, std::move(result));
          });
  registrar->AddPlugin(std::move(plugin));
}

CustomSharePlugin::CustomSharePlugin() {}

CustomSharePlugin::~CustomSharePlugin() {}

void CustomSharePlugin::HandleMethodCall(const flutter::MethodCall<flutter::EncodableValue>& call,
                                         std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (call.method_name() == "shareText") {
    auto args = std::get_if<flutter::EncodableMap>(call.arguments());
    if (!args) {
      result->Error("INVALID_ARGS", "Invalid arguments");
      return;
    }
    auto text_it = args->find(flutter::EncodableValue("text"));
    if (text_it == args->end() || !std::holds_alternative<std::string>(text_it->second)) {
      result->Error("INVALID_TEXT", "Text cannot be null or empty");
      return;
    }
    auto text = std::get<std::string>(text_it->second);
    if (text.empty()) {
      result->Error("INVALID_TEXT", "Text cannot be null or empty");
      return;
    }
    try {
      auto dataPackage = DataPackage();
      dataPackage.SetText(winrt::to_hstring(text));
      DataTransferManager::ShowShareUI();
      result->Success(flutter::EncodableValue("success"));
    } catch (const hresult_error& ex) {
      result->Error("SHARE_FAILED", "Failed to open share sheet", winrt::to_string(ex.message()));
    }
  } else if (call.method_name() == "shareFiles") {
    auto args = std::get_if<flutter::EncodableMap>(call.arguments());
    if (!args) {
      result->Error("INVALID_ARGS", "Invalid arguments");
      return;
    }
    auto paths_it = args->find(flutter::EncodableValue("filePaths"));
    if (paths_it == args->end() || !std::holds_alternative<flutter::EncodableList>(paths_it->second)) {
      result->Error("INVALID_PATH", "File paths cannot be null or empty");
      return;
    }
    auto paths = std::get<flutter::EncodableList>(paths_it->second);
    if (paths.empty()) {
      result->Error("INVALID_PATH", "File paths cannot be null or empty");
      return;
    }
    auto text_it = args->find(flutter::EncodableValue("text"));
    auto text = text_it != args->end() && std::holds_alternative<std::string>(text_it->second)
                ? std::get<std::string>(text_it->second) : "";
    try {
      auto dataPackage = DataPackage();
      IVector<IStorageItem> storageItems = single_threaded_vector<IStorageItem>();
      for (const auto& path_val : paths) {
        if (std::holds_alternative<std::string>(path_val)) {
          auto path = std::get<std::string>(path_val);
          auto file = StorageFile::GetFileFromPathAsync(winrt::to_hstring(path)).get();
          if (file) {
            storageItems.Append(file);
          } else {
            result->Error("FILE_NOT_FOUND", "File does not exist: " + path);
            return;
          }
        }
      }
      dataPackage.SetStorageItems(storageItems);
      if (!text.empty()) {
        dataPackage.SetText(winrt::to_hstring(text));
      }
      DataTransferManager::ShowShareUI();
      result->Success(flutter::EncodableValue("success"));
    } catch (const hresult_error& ex) {
      result->Error("SHARE_FAILED", "Failed to open share sheet", winrt::to_string(ex.message()));
    }
  } else {
    result->NotImplemented();
  }
}

//#include "custom_share_plugin.h"
//
//// This must be included before many other Windows headers.
//#include <windows.h>
//
//// For getPlatformVersion; remove unless needed for your plugin implementation.
//#include <VersionHelpers.h>
//
//#include <flutter/method_channel.h>
//#include <flutter/plugin_registrar_windows.h>
//#include <flutter/standard_method_codec.h>
//
//#include <memory>
//#include <sstream>
//
//namespace custom_share {
//
//// static
//void CustomSharePlugin::RegisterWithRegistrar(
//    flutter::PluginRegistrarWindows *registrar) {
//  auto channel =
//      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
//          registrar->messenger(), "custom_share",
//          &flutter::StandardMethodCodec::GetInstance());
//
//  auto plugin = std::make_unique<CustomSharePlugin>();
//
//  channel->SetMethodCallHandler(
//      [plugin_pointer = plugin.get()](const auto &call, auto result) {
//        plugin_pointer->HandleMethodCall(call, std::move(result));
//      });
//
//  registrar->AddPlugin(std::move(plugin));
//}
//
//CustomSharePlugin::CustomSharePlugin() {}
//
//CustomSharePlugin::~CustomSharePlugin() {}
//
//void CustomSharePlugin::HandleMethodCall(
//    const flutter::MethodCall<flutter::EncodableValue> &method_call,
//    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
//  if (method_call.method_name().compare("getPlatformVersion") == 0) {
//    std::ostringstream version_stream;
//    version_stream << "Windows ";
//    if (IsWindows10OrGreater()) {
//      version_stream << "10+";
//    } else if (IsWindows8OrGreater()) {
//      version_stream << "8";
//    } else if (IsWindows7OrGreater()) {
//      version_stream << "7";
//    }
//    result->Success(flutter::EncodableValue(version_stream.str()));
//  } else {
//    result->NotImplemented();
//  }
//}
//
//}  // namespace custom_share
