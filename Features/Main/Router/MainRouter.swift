import UIKit

enum MainRouter {
    static func createTabBar(for userID: String) -> UIViewController {
        let boardNav = UINavigationController(rootViewController: BoardListRouter.createModule(for: userID))
        let friendListNav = UINavigationController(rootViewController: FriendListRouter.createModule(for: userID))
        let profileNav = UINavigationController(rootViewController: ProfileRouter.createModule(for: userID))
        
        let tabBar = UITabBarController()
        tabBar.setViewControllers([boardNav, friendListNav, profileNav], animated: false)
        
        return tabBar
    }
}


