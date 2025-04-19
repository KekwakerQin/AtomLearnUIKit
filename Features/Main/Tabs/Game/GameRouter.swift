import UIKit

enum GameRouter {
    static func createModule(for userID: String) -> UIViewController {
        let vc = UIViewController()
        vc.view.backgroundColor = .black
        vc.title = "gamecontroller.fill"
        
        return vc
    }
}
