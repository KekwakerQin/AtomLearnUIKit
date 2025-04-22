import UIKit

protocol BoardListRouterProtocol: AnyObject {
    func openBoardDetail(from view: BoardListViewProtocol?, board: Board)
}

final class BoardListRouter: BoardListRouterProtocol {
    func openBoardDetail(from view: (any BoardListViewProtocol)?, board: Board) {
        guard
            let vc = view as? UIViewController
        else { return }
        
        // временный заглушка‑экран
        let detailVC = UIViewController()
        detailVC.view.backgroundColor = .systemBackground
        detailVC.title = board.title
        
        vc.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    static func createModule(for userID: String) -> UIViewController {
        let view = BoardListViewController()
        let service = BoardService()
        let interactor = BoardListInteractor(service: service, userID: userID)
        let router = BoardListRouter()
        let presenter = BoardListPresenter(interactor: interactor, router: router, userID: userID)
        
        view.presenter = presenter
        presenter.view = view
        interactor.presenter = presenter
        
        view.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "heart.text.clipboard.fill"),
            selectedImage: UIImage(systemName: "heart.text.clipboard.fill")
        )
   
        
        return view
    }
}


