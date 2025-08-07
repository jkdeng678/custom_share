#ifndef FLUTTER_PLUGIN_CUSTOM_SHARE_PLUGIN_H_
#define FLUTTER_PLUGIN_CUSTOM_SHARE_PLUGIN_H_

#include <flutter/plugin_registrar.h>

namespace custom_share {

    class CustomSharePlugin {
    public:
        static void RegisterWithRegistrar(flutter::PluginRegistrar* registrar);

        CustomSharePlugin();

        virtual ~CustomSharePlugin();

        void HandleMethodCall(
                const flutter::MethodCall<flutter::EncodableValue>& call,
                std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
    };

}  // namespace custom_share

#endif  // FLUTTER_PLUGIN_CUSTOM_SHARE_PLUGIN_H_



//#include <flutter_linux/flutter_linux.h>
//
//#include "include/custom_share/custom_share_plugin.h"
//
//// This file exposes some plugin internals for unit testing. See
//// https://github.com/flutter/flutter/issues/88724 for current limitations
//// in the unit-testable API.
//
//// Handles the getPlatformVersion method call.
//FlMethodResponse *get_platform_version();
