import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController

    let deviceChannel = FlutterMethodChannel(name: "flutter.methodchannel/iOS/recupera.cpf",
                                                 binaryMessenger: controller.binaryMessenger)

    prepareMethodHandler(deviceChannel: deviceChannel)


    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(_ application: UIApplication, open url: URL, options:
                              [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
      
        // recupera o que foi enviado pela Aplicação 1, o tipo que chega e como uma URL
        let urlComponents = URLComponents(url:url, resolvingAgainstBaseURL: true)
        
        // pegando somente os valores enviados
        let cpfEnviado = urlComponents?.host ?? ""
        
        // gravando o cpf do usuários nas preferências do IOS
        UserDefaults.standard.set(cpfEnviado, forKey: "cpfEnviado")
        
        return true

    }

  private func prepareMethodHandler(deviceChannel: FlutterMethodChannel) {
        
        deviceChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            
            if call.method == "getDeviceModel" {
                
              // Lendo as preferências do IOS e recuperando a chave que foi gravado o CPF do usuário
              guard let uCpf = UserDefaults.standard.string(forKey: "cpfEnviado") else { return }

              result(uCpf)
              
            }
            else {
                result(FlutterMethodNotImplemented)
                return
            }
            
        })
    }
}
