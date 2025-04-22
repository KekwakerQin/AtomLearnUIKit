import UIKit
import FirebaseAuth

final class ProfileViewController: UIViewController {
    
    private let exitButton: UIButton = UIButton.standart(title: "Logout")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
        setupActions()
    }
    
    private func setupView() {
        view = UIView.setupView(view: view)
        view.addSubview(exitButton)
    }
    
    private func setupActions() {
        exitButton.addTarget(self, action: #selector(handleSingOut), for: .touchUpInside)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            exitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            exitButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            exitButton.heightAnchor.constraint(equalToConstant: 44),

                // Адаптивная ширина
            exitButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),

                // Минимум и максимум (если надо)
            exitButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 200),
            exitButton.widthAnchor.constraint(lessThanOrEqualToConstant: 320)
            ])
    }
    
    @objc private func handleSingOut() {
        do {
                try Auth.auth().signOut()

                if let window = UIApplication.shared.connectedScenes
                    .compactMap({ $0 as? UIWindowScene })
                    .first?.windows
                    .first(where: { $0.isKeyWindow }) {
                    AppLauncher.shared.launch(in: window)
                }
            } catch {
                print("Ошибка выхода: \(error)")
            }
    }
}
