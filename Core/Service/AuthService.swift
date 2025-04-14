import Foundation
import FirebaseAuth

protocol AuthServiceProtocol {
    var currentUserID: String? { get }
    var isAuthorized: Bool { get }
    
    func signIn(email: String, password: String, completion: @escaping (Result<Void, Error) -> Void)
    func register(email: String, password: String, completion: @escaping (Result<Void, Error) -> Void)
    func signOut()
}

final class FirebaseAuthService: AuthServiceProtocol {
    static let shared = FirebaseAuthService()
    private init() {}
    
    var currentUserID: String? {
        Auth.auth().currentUser?.uid
    }
    
    var isAuthorized: Bool {
        currentUserID != nil
    }
    
    func signIn(email: String, password: String, completion: @escaping (Result<Void,Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            }
            else {
                completion(.success(()))
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
    
    func register(email: String, password: String, completion: @escaping (Result<Void, Error) -> Void) {
        currentUserID = "mock-data"
        completion(.success(()))
    }
    
    func signOut() {
        currentUserID = nil
    }
}
