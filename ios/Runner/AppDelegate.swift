import UIKit
import Flutter
import AudioToolbox

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(
            name: "com.example.chat_with_me/native",
            binaryMessenger: controller.binaryMessenger
        )
        
        channel.setMethodCallHandler { call, result in
            switch call.method {
            case "isPowerSaveMode":
                let isLowPower = ProcessInfo.processInfo.isLowPowerModeEnabled
                result(isLowPower)
                
            case "vibrate":
                // Системная вибрация для уведомлений
                AudioServicesPlaySystemSound(SystemSoundID(1352))
                result(nil)
                
            case "getPlatformVersion":
                let systemVersion = UIDevice.current.systemVersion
                result("iOS \(systemVersion)")  // ✅ Исправленная интерполяция
                
            default:
                result(FlutterMethodNotImplemented)
            }
        }
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}