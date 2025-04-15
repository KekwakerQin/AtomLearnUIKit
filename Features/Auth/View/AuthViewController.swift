import UIKit

final class AuthViewController: UIViewController {
    
    private let googleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign in with Google", for: .normal)
        
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
        view.addSubview(googleButton)
    }
    
    private func setupActions() {
        googleButton.addTarget(self, action: #selector(handleGoogleSignIn), for: .touchUpInside)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
                googleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                googleButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                googleButton.heightAnchor.constraint(equalToConstant: 44),

                // Адаптивная ширина
                googleButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),

                // Минимум и максимум (если надо)
                googleButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 200),
                googleButton.widthAnchor.constraint(lessThanOrEqualToConstant: 320)
            ])
    }
    
    @objc private func handleGoogleSignIn() {
        
        FirebaseAuthService.shared.signInWithGoogle(from: self) { result in
            switch result {
            case .success:
                print("Google Sign-In successful")


                if let window = UIApplication.shared.connectedScenes
                    .compactMap({ $0 as? UIWindowScene })
                    .first?.windows
                    .first(where: { $0.isKeyWindow }) {
                    AppLauncher.shared.launch(in: window)
                }

            case .failure(let error):
                print("Google Sign-In failed: \(error.localizedDescription)")
                // Здесь можно показать alert
            }
        }
    }
}
