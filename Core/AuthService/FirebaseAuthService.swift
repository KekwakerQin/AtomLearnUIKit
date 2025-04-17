import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase
import Combine


protocol UserServiceProtocol {
    func createUserIfNeeded(from authUser: FirebaseAuth.User, completion: @escaping (Result<AppUser, Error>) -> Void)
    func fetchUser(uid: String, completion: @escaping (Result<AppUser,Error>) -> Void)
}

class UserService: UserServiceProtocol {
    private let db = Firebase.firestore()
    private let cancellables = Set<AnyCancellable>()
    
    func fetchUser(uid: String) -> AnyPublisher<AppUser, Error> {
        db.collection("users")
            .document(uid)
            .getDocument()
            .tryMap { snapshot in
                try snapshot.data(as: AppUser.self)
            }
            .eraseToAnyPublisher()
    }
    
    func createUserIfNeeded(from authUser: FirebaseAuth.User) -> AnyPublisher<AppUser, Error> {
            let docRef = db.collection("users").document(authUser.uid)

            return docRef.getDocument()
                .flatMap { snapshot -> AnyPublisher<AppUser, Error> in
                    if let snapshot = snapshot, snapshot.exists {
                        // пользователь уже есть
                        return Just(snapshot)
                            .tryMap { try $0.data(as: AppUser.self) }
                            .eraseToAnyPublisher()
                    } else {
                        // создаём нового пользователя
                        let user = AppUser(
                            uid: authUser.uid,
                            email: authUser.email ?? "",
                            displayName: authUser.displayName ?? "No Name",
                            photoURL: authUser.photoURL?.absoluteString,
                            boardCount: 1,
                            createdAt: Date()
                        )
                        return Future<Void, Error> { promise in
                            try? docRef.setData(from: user) { error in
                                if let error = error {
                                    promise(.failure(error))
                                } else {
                                    promise(.success(()))
                                }
                            }
                        }
                        .map { user }
                        .eraseToAnyPublisher()
                    }
                }
                .eraseToAnyPublisher()
        }
}
