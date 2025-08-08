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
  } else if (call.method_name() == "shareFile") {
    auto args = std::get_if<flutter::EncodableMap>(call.arguments());
    if (!args) {
      result->Error("INVALID_ARGS", "Invalid arguments");
      return;
    }
    auto file_path_it = args->find(flutter::EncodableValue("filePath"));
    if (file_path_it == args->end() || !std::holds_alternative<std::string>(file_path_it->second)) {
      result->Error("INVALID_PATH", "File path cannot be null");
      return;
    }
    auto file_path = std::get<std::string>(file_path_it->second);
    if (file_path.empty()) {
      result->Error("INVALID_PATH", "File path cannot be null");
      return;
    }
    try {
      auto file = StorageFile::GetFileFromPathAsync(winrt::to_hstring(file_path)).get();
      if (!file) {
        result->Error("FILE_NOT_FOUND", "File does not exist: " + file_path);
        return;
      }
      auto dataPackage = DataPackage();
      IVector<IStorageItem> storageItems = single_threaded_vector<IStorageItem>();
      storageItems.Append(file);
      dataPackage.SetStorageItems(storageItems);
      DataTransferManager::ShowShareUI();
      result->Success(flutter::EncodableValue("success"));
    } catch (const hresult_error& ex) {
      result->Error("SHARE_FAILED", "Failed to open share sheet", winrt::to_string(ex.message()));
    }
  } else {
    result->NotImplemented();
  }
}