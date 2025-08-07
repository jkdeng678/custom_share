//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <custom_share/custom_share_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) custom_share_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "CustomSharePlugin");
  custom_share_plugin_register_with_registrar(custom_share_registrar);
}
