#ifndef FLUTTER_PLUGIN_FLUTTER_P2P_PLUS_PLUGIN_H_
#define FLUTTER_PLUGIN_FLUTTER_P2P_PLUS_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace flutter_p2p_plus {

class FlutterP2pPlusPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  FlutterP2pPlusPlugin();

  virtual ~FlutterP2pPlusPlugin();

  // Disallow copy and assign.
  FlutterP2pPlusPlugin(const FlutterP2pPlusPlugin&) = delete;
  FlutterP2pPlusPlugin& operator=(const FlutterP2pPlusPlugin&) = delete;

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace flutter_p2p_plus

#endif  // FLUTTER_PLUGIN_FLUTTER_P2P_PLUS_PLUGIN_H_
