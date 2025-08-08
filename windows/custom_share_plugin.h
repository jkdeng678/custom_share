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