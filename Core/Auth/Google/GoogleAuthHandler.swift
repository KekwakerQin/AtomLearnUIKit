import Foundation
import GoogleSignIn
import FirebaseAuth
import FirebaseCore
import RxSwift
import UIKit

final class GoogleAuthHandler {

    func signIn(from viewController: UIViewController) -> Single<User> {
        return Single.create { single in
            guard let clientID = FirebaseApp.app()?.options.clientID else {
                single(.failure(
                    NSError(domain: "GoogleAuth", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing clientID"]))
                )
                return Disposables.create()
            }

            // Конфигурация Google SDK
            let config = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = config

            // Получение текущего активного VC, если надо
            guard let presentingVC = UIApplication.shared
                .connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first?
                .windows
                .first(where: { $0.isKeyWindow })?
                .rootViewController else {
                single(.failure(
                    NSError(domain: "GoogleAuth", code: -1, userInfo: [NSLocalizedDescriptionKey: "No root VC found"]))
                )
                return Disposables.create()
            }

            // Старт Google входа
            GIDSignIn.sharedInstance.signIn(withPresenting: presentingVC) { result, error in
                if let error = error {
                    single(.failure(error))
                    return
                }

                guard
                    let user = result?.user,
                    let idToken = user.idToken?.tokenString
                else {
                    single(.failure(NSError(domain: "GoogleAuth", code: -1, userInfo: [
                        NSLocalizedDescriptionKey: "Missing ID token"
                    ])))
                    return
                }

                // Авторизация в Firebase через Google credential
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
                        single(.failure(NSError(domain: "GoogleAuth", code: -1, userInfo: [
                            NSLocalizedDescriptionKey: "Unknown error"
                        ])))
                    }
                }
            }

            return Disposables.create()
        }
    }
}
