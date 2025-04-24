import UIKit

protocol BoardDetailViewProtocol: AnyObject {
    func displayBoardInfo(title: String, description: String)
    func showCards(_ cards: [Card])
    func showError(_ error: Error)
}

final class BoardDetailViewController: UIViewController {
    
    var presenter: BoardDetailPresenterProtocol!
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let tableView = UITableView()
    private let addCardButton = UIButton.standart(title: "Add card")
    private let deleteCardButton = UIButton.standart(title: "Delete all cards")
    
    private var cards: [Card] = []
    
    init(presenter: BoardDetailPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Loaded")
        view.backgroundColor = UIColor(named: "BackgroundColor")
        setupHierarchy()
        setupLayot()
        setupAction()
    }
    
    private func setupAction() {
        addCardButton.addTarget(self, action: #selector(addCard), for: .touchUpInside)
        deleteCardButton.addTarget(self, action: #selector(deleteCards), for: .touchUpInside)
    }
    
    private func setupHierarchy() {
        view.addSubview(tableView)
        view.addSubview(deleteCardButton)
        view.addSubview(addCardButton)
    }
    
    private func setupLayot() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            addCardButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addCardButton.heightAnchor.constraint(equalToConstant: 44),
            addCardButton.bottomAnchor.constraint(equalTo: deleteCardButton.topAnchor, constant: -20),
                // Адаптивная ширина
            addCardButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),

                // Минимум и максимум (если надо)
            addCardButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 200),
            addCardButton.widthAnchor.constraint(lessThanOrEqualToConstant: 320),
            
            deleteCardButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            deleteCardButton.heightAnchor.constraint(equalToConstant: 44),
            deleteCardButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),

                // Адаптивная ширина
            deleteCardButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),

                // Минимум и максимум (если надо)
            deleteCardButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 200),
            deleteCardButton.widthAnchor.constraint(lessThanOrEqualToConstant: 320),

        ])
    }
    
    @objc private func addCard() {
        presenter.didTapCreateButton()
    }
    
    @objc private func deleteCards() {
        presenter.didTapDeleteButton()
    }
}

// MARK: - BoardDetailView Protocol

extension BoardDetailViewController: BoardDetailViewProtocol {
    func displayBoardInfo(title: String, description: String) {
        titleLabel.text = title
        descriptionLabel.text = description
    }
    
    func showCards(_ cards: [Card]) {
        self.cards = cards
        tableView.reloadData()
    }
    
    func showError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
    
    
}

// MARK: - BoardDetailView: TableViewDataSource

extension BoardDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardCell", for: indexPath)
        cell.textLabel?.text = cards[indexPath.row].term
        return cell
    }
}
