import Flutter
import UIKit

public class SwiftColendiWebViewSdkFlutterPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "colendi_web_view_sdk_flutter", binaryMessenger: registrar.messenger())
    let instance = SwiftColendiWebViewSdkFlutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
