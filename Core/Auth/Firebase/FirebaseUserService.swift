import FirebaseFirestore
import RxSwift
import FirebaseAuth

final class FirestoreUserService: UserServiceProtocol {
    
    private let db = Firestore.firestore()

    func createUserIfNeeded(from firebaseUser: User) -> Single<AppUser> {
        let docRef = FirestorePaths.userRef(uid: firebaseUser.uid)
        return Single.create { single in
            docRef.getDocument { snapshot, error in
                if let snapshot = snapshot, snapshot.exists {
                    do {
                        let user = try snapshot.data(as: AppUser.self)
                        single(.success(user))
                    } catch {
                        single(.failure(error))
                    }
                } else {
                    let appUser = AppUser(
                        id: firebaseUser.uid,
                        photoURL: "",
                        registeredAt: Date(),
                        uid: firebaseUser.uid
                    )

                    do {
                        try docRef.setData(from: appUser) { error in
                            if let error = error {
                                single(.failure(error))
                            } else {
                                single(.success(appUser))
                            }
                        }
                    } catch {
                        single(.failure(error))
                    }
                }
            }

            return Disposables.create()
        }
    }
    
    func fetchUser(uid: String) -> Single<AppUser> {
        let ref = FirestorePaths.userRef(uid: uid)
        
        return Single.create { single in
            ref.getDocument() { snapshot, error in
                if let error = error {
                    single(.failure(error))
                } else if let snapshot = snapshot {
                    do {
                        let user = try snapshot.data(as: AppUser.self)
                        single(.success(user))
                    } catch {
                        single(.failure(error))
                    }
                }
            }
            return Disposables.create()
        }
    }
    
    func updateUser(_ user: AppUser) -> Completable {
        guard let uid = user.id else {
            return .error(NSError(domain: "FirestoreUserService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing user id"]))
        }
        
        let ref = FirestorePaths.userRef(uid: uid)
        
        return Completable.create { completable in
            do {
                try ref.setData(from: user, merge: true) { error in
                    if let error = error {
                        completable(.error(error))
                    } else {
                        completable(.completed)
                    }
                }
            } catch {
                completable(.error(error))
            }
            
            return Disposables.create()
        }
    }
}
