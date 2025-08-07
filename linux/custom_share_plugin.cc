#include "custom_share_plugin.h"
#include <flutter/method_channel.h>
#include <flutter/plugin_registrar.h>
#include <flutter/standard_method_codec.h>
#include <memory>
#include <string>

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
    system(command.c_str());
    result->Success(flutter::EncodableValue("success"));
  } else if (call.method_name() == "shareFiles") {
    result->Error("NOT_SUPPORTED", "File sharing not implemented on Linux");
  } else {
    result->NotImplemented();
  }
}

//#include "include/custom_share/custom_share_plugin.h"
//
//#include <flutter_linux/flutter_linux.h>
//#include <gtk/gtk.h>
//#include <sys/utsname.h>
//
//#include <cstring>
//
//#include "custom_share_plugin_private.h"
//
//#define CUSTOM_SHARE_PLUGIN(obj) \
//  (G_TYPE_CHECK_INSTANCE_CAST((obj), custom_share_plugin_get_type(), \
//                              CustomSharePlugin))
//
//struct _CustomSharePlugin {
//  GObject parent_instance;
//};
//
//G_DEFINE_TYPE(CustomSharePlugin, custom_share_plugin, g_object_get_type())
//
//// Called when a method call is received from Flutter.
//static void custom_share_plugin_handle_method_call(
//    CustomSharePlugin* self,
//    FlMethodCall* method_call) {
//  g_autoptr(FlMethodResponse) response = nullptr;
//
//  const gchar* method = fl_method_call_get_name(method_call);
//
//  if (strcmp(method, "getPlatformVersion") == 0) {
//    response = get_platform_version();
//  } else {
//    response = FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());
//  }
//
//  fl_method_call_respond(method_call, response, nullptr);
//}
//
//FlMethodResponse* get_platform_version() {
//  struct utsname uname_data = {};
//  uname(&uname_data);
//  g_autofree gchar *version = g_strdup_printf("Linux %s", uname_data.version);
//  g_autoptr(FlValue) result = fl_value_new_string(version);
//  return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
//}
//
//static void custom_share_plugin_dispose(GObject* object) {
//  G_OBJECT_CLASS(custom_share_plugin_parent_class)->dispose(object);
//}
//
//static void custom_share_plugin_class_init(CustomSharePluginClass* klass) {
//  G_OBJECT_CLASS(klass)->dispose = custom_share_plugin_dispose;
//}
//
//static void custom_share_plugin_init(CustomSharePlugin* self) {}
//
//static void method_call_cb(FlMethodChannel* channel, FlMethodCall* method_call,
//                           gpointer user_data) {
//  CustomSharePlugin* plugin = CUSTOM_SHARE_PLUGIN(user_data);
//  custom_share_plugin_handle_method_call(plugin, method_call);
//}
//
//void custom_share_plugin_register_with_registrar(FlPluginRegistrar* registrar) {
//  CustomSharePlugin* plugin = CUSTOM_SHARE_PLUGIN(
//      g_object_new(custom_share_plugin_get_type(), nullptr));
//
//  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
//  g_autoptr(FlMethodChannel) channel =
//      fl_method_channel_new(fl_plugin_registrar_get_messenger(registrar),
//                            "custom_share",
//                            FL_METHOD_CODEC(codec));
//  fl_method_channel_set_method_call_handler(channel, method_call_cb,
//                                            g_object_ref(plugin),
//                                            g_object_unref);
//
//  g_object_unref(plugin);
//}
