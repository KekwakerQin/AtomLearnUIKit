import UIKit

enum BoardListRouter {
    static func createModule(for userID: String) -> UIViewController {
        let viewController = BoardListViewController()
        
        viewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "heart.text.clipboard.fill"),
            selectedImage: UIImage(systemName: "heart.text.clipboard.fill")
        )
        
        return viewController
    }
}


