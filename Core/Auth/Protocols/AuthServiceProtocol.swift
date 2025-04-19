import FirebaseAuth
import UIKit
import RxSwift

protocol AuthServiceProtocol {
    func signInWithGoogle(from viewController: UIViewController) -> Single<User>
    func signInWithApple(from viewController: UIViewController) -> Single<User>
    
    var currentUserID: String? { get }
    var isAuthorized: Bool { get }
    func signOut()
}
