#include "include/flutter_p2p_plus/flutter_p2p_plus_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "flutter_p2p_plus_plugin.h"

void FlutterP2pPlusPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  flutter_p2p_plus::FlutterP2pPlusPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
