import UIKit

protocol BoardListViewProtocol: AnyObject {
    func showBoards(_ boards: [Board])
    func showError(_ error: Error)
}

final class BoardListViewController: UIViewController {
    
    private let tableView = UITableView()
    private let addBoardButton: UIButton = UIButton.standart(title: "Add some Board")
    
    weak var presenter: BoardListPresenterProtocol?
    
    private var boards: [Board] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupHierarchy()
        setupLayout()
        setupAction()
    }
    
    // MARK: - Setup

    private func setupView() {
        view = UIView.setupView(view: view)
    }
    
    private func setupHierarchy() {
        view.addSubview(tableView)
        view.addSubview(addBoardButton)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            addBoardButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addBoardButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            addBoardButton.heightAnchor.constraint(equalToConstant: 44),

                // Адаптивная ширина
            addBoardButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),

                // Минимум и максимум (если надо)
            addBoardButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 200),
            addBoardButton.widthAnchor.constraint(lessThanOrEqualToConstant: 320)

        ])
    }
    
    private func setupAction() {
        addBoardButton.addTarget(self, action: #selector(addBoardInDatabase), for: .touchUpInside)
    }
    
    // MARK: - Actions

    @objc private func addBoardInDatabase() {
        print("Tapped")
        presenter?.didTapCreateButton()
    }
}

extension BoardListViewController: BoardListViewProtocol {
    func showBoards(_ boards: [Board]) {
        self.boards = boards
        tableView.reloadData()
    }

    func showError(_ error: Error) {
        let alert = UIAlertController(title: "Error",
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension BoardListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tv: UITableView, numberOfRowsInSection section: Int) -> Int {
        boards.count
    }

    func tableView(_ tv: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tv.dequeueReusableCell(withIdentifier: "BoardCell")
                 ?? UITableViewCell(style: .subtitle, reuseIdentifier: "BoardCell")
        let board = boards[indexPath.row]
        cell.textLabel?.text = board.title
        cell.detailTextLabel?.text = board.description
        return cell
    }

    func tableView(_ tv: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectBoard(boards[indexPath.row])
    }
}
