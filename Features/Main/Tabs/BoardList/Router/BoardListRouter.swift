import UIKit

enum BoardListRouter {
    static func createModule(for userID: String) -> UIViewController {
        let vc = UIViewController()
        vc.view.backgroundColor = .systemGray
        vc.title = "list.bullet.circle.fill"
        
        return vc
    }
}


