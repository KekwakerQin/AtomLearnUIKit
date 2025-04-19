import Foundation
import UIKit

final class AppLauncher {
    static let shared = AppLauncher()

    private init() {}

    var authService: AuthServiceProtocol = FirebaseAuthService() // ← без "any"

    func launch(in window: UIWindow) {
        let state = determineAppState()

        switch state {
        case .unauthorized:
            window.rootViewController = AuthRouter.createModule()
        case .authorized(let userID):
            window.rootViewController = MainRouter.createTabBar(for: userID)
        }

        window.makeKeyAndVisible()
    }

    func determineAppState() -> AppState {
        guard authService.isAuthorized,
              let userID = authService.currentUserID else {
            return .unauthorized
        }

        return .authorized(userID: userID)
    }
}
