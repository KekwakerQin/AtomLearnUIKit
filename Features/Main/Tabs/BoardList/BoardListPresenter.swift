import UIKit

protocol BoardListPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapCreateButton()
    func didSelectBoard(_ board: Board)
}

final class BoardListPresenter: BoardListPresenterProtocol, BoardListInteractorOutputProtocol {
    
    weak var view: BoardListViewProtocol?
    let interactor: BoardListInteractorInputProtocol
    let router: BoardListRouterProtocol
    let userID: String
    
    init(interactor: BoardListInteractorInputProtocol, router: BoardListRouterProtocol, userID: String) {
        self.interactor = interactor
        self.router = router
        self.userID = userID
    }
    
    func viewDidLoad() {
        interactor.fetchBoards()
    }
    
    func didTapCreateButton() {
        print("Tapped Board List Presenter")
        interactor.createBoard()
    }
    
    func didTapDeleteButton() {
        print("Tapped Board List Presenter")
        interactor.createBoard()
    }
    
    func didSelectBoard(_ board: Board) {
        router.openBoardDetail(from: view, board: board)
    }
    
    func didFetchBoard(_ boards: [Board])      { view?.showBoards(boards) }
    func didFailFetchingBoard(_ error: Error)  { view?.showError(error)   }
    func didCreateBoard(_ board: Board)        { interactor.fetchBoards() }
    func didFailCreatingBoard(_ error: Error)  { view?.showError(error)   }
    
}
