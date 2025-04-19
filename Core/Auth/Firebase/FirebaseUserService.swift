import FirebaseFirestore
import RxSwift
import FirebaseAuth

final class FirestoreUserService: UserServiceProtocol {
    
    private let db = Firestore.firestore()

    func createUserIfNeeded(from firebaseUser: User) -> Single<AppUser> {
        let docRef = db.collection("users").document(firebaseUser.uid)
        
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
}
