final class AppleAuthHandler: NSObject {
    
    private var singleCallback: ((SingleEvent<User>) -> Void)?
    private var currentNonce: String?

    func signIn(from viewController: UIViewController) -> Single<User> {
        return Single.create { [weak self] single in
            guard let self else { return Disposables.create() }
            let nonce = Self.randomNonceString()
            self.currentNonce = nonce

            let request = ASAuthorizationAppleIDProvider().createRequest()
            request.requestedScopes = [.email, .fullName]
            request.nonce = Self.sha256(nonce)

            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self

            self.singleCallback = single
            controller.performRequests()
            
            return Disposables.create()
        }
    }

    // MARK: - Delegate methods ...

    // MARK: - Nonce utilities ...
}
