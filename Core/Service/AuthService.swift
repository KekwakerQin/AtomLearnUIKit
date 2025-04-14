import Foundation
import FirebaseAuth
import FirebaseFirestore

final class AuthService {
    static let shared = AuthService()
    private init {}
    
    // MARK: - API
    
    
    
    var currentUserID: String? {
        return Auth.auth().currentUser?.uid
    }
}
