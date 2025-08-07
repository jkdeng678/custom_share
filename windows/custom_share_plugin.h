#ifndef FLUTTER_PLUGIN_CUSTOM_SHARE_PLUGIN_H_
#define FLUTTER_PLUGIN_CUSTOM_SHARE_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

namespace custom_share {

    class CustomSharePlugin : public flutter::Plugin {
    public:
        static void RegisterWithRegistrar(flutter::PluginRegistrarWindows* registrar);

        CustomSharePlugin();

        virtual ~CustomSharePlugin();

        void HandleMethodCall(const flutter::MethodCall<flutter::EncodableValue>& call,
                              std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    };

}  // namespace custom_share

#endif  // FLUTTER_PLUGIN_CUSTOM_SHARE_PLUGIN_H_

//#ifndef FLUTTER_PLUGIN_CUSTOM_SHARE_PLUGIN_H_
//#define FLUTTER_PLUGIN_CUSTOM_SHARE_PLUGIN_H_
//
//#include <flutter/method_channel.h>
//#include <flutter/plugin_registrar_windows.h>
//
//#include <memory>
//
//namespace custom_share {
//
//class CustomSharePlugin : public flutter::Plugin {
// public:
//  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);
//
//  CustomSharePlugin();
//
//  virtual ~CustomSharePlugin();
//
//  // Disallow copy and assign.
//  CustomSharePlugin(const CustomSharePlugin&) = delete;
//  CustomSharePlugin& operator=(const CustomSharePlugin&) = delete;
//
//  // Called when a method is called on this plugin's channel from Dart.
//  void HandleMethodCall(
//      const flutter::MethodCall<flutter::EncodableValue> &method_call,
//      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
//};
//
//}  // namespace custom_share
//
//#endif  // FLUTTER_PLUGIN_CUSTOM_SHARE_PLUGIN_H_
