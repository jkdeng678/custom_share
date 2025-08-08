#include "custom_share_plugin.h"
#include <flutter/method_channel.h>
#include <flutter/plugin_registrar.h>
#include <flutter/standard_method_codec.h>
#include <memory>
#include <string>
#include <fstream>

void CustomSharePluginRegisterWithRegistrar(FlutterPluginRegistrar* registrar) {
  auto channel = std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          flutter::MethodChannel<flutter::EncodableValue>(
                  registrar->messenger(), "custom_share",
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

void CustomSharePlugin::HandleMethodCall(
        const flutter::MethodCall<flutter::EncodableValue>& call,
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
    std::string command = "xdg-open mailto:?body=\"" + text + "\"";
    int ret = system(command.c_str());
    if (ret == 0) {
      result->Success(flutter::EncodableValue("success"));
    } else {
      result->Error("SHARE_FAILED", "Failed to open share dialog");
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
    std::ifstream file(file_path);
    if (!file.good()) {
      result->Error("FILE_NOT_FOUND", "File does not exist: " + file_path);
      return;
    }
    file.close();
    std::string command = "xdg-open \"" + file_path + "\"";
    int ret = system(command.c_str());
    if (ret == 0) {
      result->Success(flutter::EncodableValue("success"));
    } else {
      result->Error("SHARE_FAILED", "Failed to open file");
    }
  } else {
    result->NotImplemented();
  }
}