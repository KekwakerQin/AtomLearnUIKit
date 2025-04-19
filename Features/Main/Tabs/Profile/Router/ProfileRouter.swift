import UIKit

enum ProfileRouter {
    static func createModule(for userID: String) -> UIViewController {
        return ProfileViewController()
    }
}
