import UIKit
import Flutter
import AudioToolbox

@main
@objc class AppDelegate: FlutterAppDelegate {
    
    
    
    private var nativeChannel: FlutterMethodChannel?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        GeneratedPluginRegistrant.register(with: self)
        
        
        guard let controller = window?.rootViewController as? FlutterViewController else {
            debugPrint("⚠️ FlutterViewController not ready yet")
            return super.application(application, didFinishLaunchingWithOptions: launchOptions)
        }
        
        
        nativeChannel = FlutterMethodChannel(
            name: "com.example.chat_with_me/native",
            binaryMessenger: controller.binaryMessenger
        )
        
        
        nativeChannel?.setMethodCallHandler { [weak self] call, result in
            debugPrint("🔧 [iOS] Method called: \(call.method), args: \(String(describing: call.arguments))")
            
            switch call.method {
            case "isPowerSaveMode":
                let isLowPower = ProcessInfo.processInfo.isLowPowerModeEnabled
                debugPrint("🔋 [iOS] Power save mode: \(isLowPower)")
                result(isLowPower)
                
            case "vibrate":
                let args = call.arguments as? [String: Any]
                let duration = args?["duration"] as? Int ?? 200
                debugPrint("📳 [iOS] Vibrating for \(duration)ms")
                
                
                AudioServicesPlaySystemSound(SystemSoundID(1352))
                result(nil)
                
            case "getPlatformVersion":
                let version = UIDevice.current.systemVersion
                debugPrint("📱 [iOS] Version: \(version)")
                result("iOS \(version)")
                
            default:
                debugPrint("❌ [iOS] Method not implemented: \(call.method)")
                result(FlutterMethodNotImplemented)
            }
        }
        
        debugPrint("✅ [iOS] MethodChannel 'com.example.chat_with_me/native' registered successfully")
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
