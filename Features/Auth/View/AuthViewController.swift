import UIKit
import RxSwift

final class AuthViewController: UIViewController {
    
    private let authService: AuthServiceProtocol = FirebaseAuthService()
    private let userService: UserServiceProtocol = FirestoreUserService()
    private let disposeBag = DisposeBag()
    
    private let googleAuthButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign in with Google", for: .normal)
        
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let appleAuthButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign in with Apple", for: .normal)
        
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
        setupActions()
    }
    
    private func setupView() {
        view.backgroundColor = .systemGray
        title = "Authorization"
        view.addSubview(googleAuthButton)
        view.addSubview(appleAuthButton)
    }
    
    private func setupActions() {
        googleAuthButton.addTarget(self, action: #selector(handleGoogleSignIn), for: .touchUpInside)
        appleAuthButton.addTarget(self, action: #selector(handleAppleSignIn), for: .touchUpInside)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            googleAuthButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            googleAuthButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            googleAuthButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Адаптивная ширина
            googleAuthButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            
            // Минимум и максимум (если надо)
            googleAuthButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 200),
            googleAuthButton.widthAnchor.constraint(lessThanOrEqualToConstant: 320),
            
            appleAuthButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appleAuthButton.topAnchor.constraint(equalTo: googleAuthButton.bottomAnchor, constant: UIScreen.main.bounds.height * 0.05),
            appleAuthButton.heightAnchor.constraint(equalToConstant: 44),
            
            appleAuthButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            
            appleAuthButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 200),
            appleAuthButton.widthAnchor.constraint(lessThanOrEqualToConstant: 320),
        ])
    }
    
    @objc private func handleGoogleSignIn() {
        authService.signInWithGoogle(from: self)
            .flatMap { user in
                self.userService.createUserIfNeeded(from: user)
            }
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { appUser in
                    print("Вход успешен, AppUser: \(appUser)")

                    // Переключаемся на основной интерфейс
                    if let window = UIApplication.shared.connectedScenes
                        .compactMap({ $0 as? UIWindowScene })
                        .first?.windows
                        .first(where: { $0.isKeyWindow }) {
                        AppLauncher.shared.launch(in: window)
                    }
                },
                onFailure: { error in
                    print("Ошибка входа: \(error.localizedDescription)")
                    // Показать alert или обработать ошибку
                }
            )
            .disposed(by: disposeBag)
    }
    
    @objc private func handleAppleSignIn() {
        authService.signInWithApple(from: self)
            .do(onSubscribe: { print("🚀 Начали вход по Apple") })
            .flatMap { user in
                print("✅ Получен user: \(user.uid)")
                return self.userService.createUserIfNeeded(from: user)
            }
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { appUser in
                print("🎉 Успешный вход, appUser: \(appUser.uid)")
                AppLauncher.shared.launch(in: UIApplication.shared.windows.first!)
            }, onFailure: { error in
                print("❌ Ошибка входа по Apple: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
}
