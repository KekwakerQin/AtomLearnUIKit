import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        
        if Auth.auth().currentUser != nil {
            let mainVC = MainViewController()
            window.rootViewController = UINavigationController(rootViewController: mainVC)
        }
        else {
            let loginVC = LoginViewController()
            window.rootViewController = UINavigationController(rootViewController: loginVC)
        }
        
        self.window = window
        window.makeKeyAndVisible()

    }
}

//        let rootViewController = WindowTestViewController()
//        rootViewController.view.backgroundColor = .white
//        window.rootViewController = rootViewController
//        self.window = window
//        window.makeKeyAndVisible()
