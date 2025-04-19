import Firebase
import FirebaseAuth
import GoogleSignIn
import RxSwift
import AuthenticationServices
import CryptoKit // для nonce

final class FirebaseAuthService: AuthServiceProtocol {
    
    func signInWithGoogle(from viewController: UIViewController) -> Single<User> {
        return Single.create { single in
            guard let clientID = FirebaseApp.app()?.options.clientID else {
                single(.failure(NSError(domain: "FirebaseAuthService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing clientID"])))
                return Disposables.create()
            }
            
            let config = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = config
            
            guard let presentingVC = UIApplication.shared
                .connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first?
                .windows
                .first(where: { $0.isKeyWindow })?
                .rootViewController else {
                single(.failure(NSError(domain: "FirebaseAuthService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No root view controller found"])))
                return Disposables.create()
            }
            
            GIDSignIn.sharedInstance.signIn(withPresenting: presentingVC) { result, error in
                if let error = error {
                    single(.failure(error))
                    return
                }
                
                guard
                    let user = result?.user,
                    let idToken = user.idToken?.tokenString
                else {
                    single(.failure(NSError(domain: "FirebaseAuthService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing ID token"])))
                    return
                }
                
                let credential = GoogleAuthProvider.credential(
                    withIDToken: idToken,
                    accessToken: user.accessToken.tokenString
                )
                
                Auth.auth().signIn(with: credential) { authResult, error in
                    if let error = error {
                        single(.failure(error))
                    } else if let user = authResult?.user {
                        single(.success(user))
                    } else {
                        single(.failure(NSError(domain: "FirebaseAuthService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])))
                    }
                }
            }
            
            return Disposables.create()
        }
    }
    
    
    func signInWithApple(from viewController: UIViewController) -> Single<User> {
        appleAuthHandler.signIn(from: viewController)
    }
    
    var currentUserID: String? {
        Auth.auth().currentUser?.uid
    }
    
    var isAuthorized: Bool {
        currentUserID != nil
    }
    
    func signOut() {
        try? Auth.auth().signOut()
    }
}
