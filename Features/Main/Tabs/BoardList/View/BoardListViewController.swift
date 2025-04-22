import UIKit

class BoardListViewController: UIViewController {
    
    var buttonOfBoardList = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = UIColor(named: "BackgroundColor")
//        navigationController?.navigationBar.prefersLargeTitles = false
//        navigationItem.titleView = IconFactory.makeSymbol(
//            name: "gamecontroller.fill",
//            tintColor: UIColor(named: "TextColor")!
//        )
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            
        ])
    }
}
