import UIKit

enum FriendListRouter {
    static func createModule(for userID: String) -> UIViewController {
        let vc = UIViewController()
        vc.view.backgroundColor = .systemYellow
        vc.title = "FriendList"
        
        return vc
    }
}
