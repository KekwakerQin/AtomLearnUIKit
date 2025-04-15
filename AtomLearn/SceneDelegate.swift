import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        print("We are on SceneDelegate")

        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        AppLauncher.shared.launch(in: window)
        
        self.window = window
        window.makeKeyAndVisible()

    }
}

//        let rootViewController = WindowTestViewController()
//        rootViewController.view.backgroundColor = .white
//        window.rootViewController = rootViewController
//        self.window = window
//        window.makeKeyAndVisible()
