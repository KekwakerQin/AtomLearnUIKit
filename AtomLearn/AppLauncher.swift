import Foundation
import UIKit

final class AppLauncher {
    static let shared = AppLauncher()

    private init() {}
    
    var authService: AuthServiceProtocol = FirebaseAuthService.shared
    
    func launch(in window: UIWindow){
        let state = determineAppState()
        
        switch state {
        case.unauthorized:
            window.rootViewController = AuthRouter.createModule()
            
        case.authorized(let userID):
            window.rootViewController = MainRouter.createTabBar(for: userID)
        }
        
        window.makeKeyAndVisible()
    }
    
    func determineAppState() -> AppState {
        if authService.isAuthorized {
            return .authorized(userID: authService.currentUserID!)
        }
        else {
            return .unauthorized
        }
    }
}
