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
    
    func reloadRootViewController() {
        guard let window = window else { return }
        AppLauncher.shared.launch(in: window)
    }
}


