import Foundation
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

protocol AuthServiceProtocol {
    var currentUserID: String? { get }
    var isAuthorized: Bool { get }
    
    func signIn(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
    func register(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
    func signOut()
}

final class FirebaseAuthService: AuthServiceProtocol {
    
    static let shared = FirebaseAuthService()
    private init() {}

    func signIn(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            }
            else {
                completion(.success(()))
            }
        }
    }
    
    func signInWithGoogle(from viewController: UIViewController, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            completion(.failure(NSError(domain: "SignIn", code: -1, userInfo: [NSLocalizedDescriptionKey: "No Firebase client ID"])))
            return
        }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        print("We are here1")
        guard let presentingVC = UIApplication.shared
            .connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?
            .windows
            .first(where: { $0.isKeyWindow })?
            .rootViewController else {
            completion(.failure(NSError(domain: "App", code: -1, userInfo: [NSLocalizedDescriptionKey: "No root view controller"])))
            return
        }
        print("We are here2")

        GIDSignIn.sharedInstance.signIn(withPresenting: presentingVC) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            print("We are here3")

            guard
                let user = result?.user,
                let idToken = user.idToken?.tokenString
            else {
                completion(.failure(NSError(domain: "SignIn", code: -1, userInfo: [
                    NSLocalizedDescriptionKey: "Missing ID token"
                ])))
                return
            }
            print("We are here4")

            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: user.accessToken.tokenString
            )
            print("We are here5")

            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(())) // ← мы возвращаем `Void` по твоему протоколу
                }
            }
        }
    }
    
    func register(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            }
            else {
                completion(.success(()))
            }
        }
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

final class MockAuthService: AuthServiceProtocol {
    var currentUserID: String? = nil
    var isAuthorized: Bool { currentUserID != nil }
    
    func signIn(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        currentUserID = "mock-data"
        completion(.success(()))
    }
    
    func register(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        currentUserID = "mock-data"
        completion(.success(()))
    }
    
    func signOut() {
        currentUserID = nil
    }
}
