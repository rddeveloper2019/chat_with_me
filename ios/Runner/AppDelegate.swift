import UIKit
import Flutter
import AudioToolbox

@main
@objc class AppDelegate: FlutterAppDelegate {
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // 1. Сначала регистрируем плагины — это обязательно!
        GeneratedPluginRegistrant.register(with: self)
        
        // 2. Безопасно получаем контроллер
        guard let controller = window?.rootViewController as? FlutterViewController else {
            // Если контроллер ещё не готов — выходим, метод зарегистрируется позже
            return super.application(application, didFinishLaunchingWithOptions: launchOptions)
        }
        
        // 3. Регистрируем MethodChannel
        let channel = FlutterMethodChannel(
            name: "com.example.chat_with_me/native",
            binaryMessenger: controller.binaryMessenger
        )
        
        channel.setMethodCallHandler { [weak self] call, result in
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
                result("iOS \(systemVersion)")
                
            default:
                result(FlutterMethodNotImplemented)
            }
        }
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}