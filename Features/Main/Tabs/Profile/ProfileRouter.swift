import UIKit

enum ProfileRouter {
    static func createModule(for userID: String) -> UIViewController {
        let vc = UIViewController()
        vc.view.backgroundColor = .systemMint
        vc.title = "Profile"
        
        return vc
    }
}
