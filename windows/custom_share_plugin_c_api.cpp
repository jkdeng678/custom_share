#include "include/custom_share/custom_share_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "custom_share_plugin.h"

void CustomSharePluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  custom_share::CustomSharePlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
