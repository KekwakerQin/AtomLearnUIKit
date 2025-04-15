import UIKit

enum AuthRouter {
    static func createModule() -> UIViewController {
        let vc = UIViewController()
        vc.view.backgroundColor = .systemGray
        vc.title = "Authorization"
        
        return vc
    }
}


