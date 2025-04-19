import FirebaseAuth
import RxSwift

protocol UserServiceProtocol {
    func createUserIfNeeded(from firebaseUser: User) -> Single<AppUser>
}
