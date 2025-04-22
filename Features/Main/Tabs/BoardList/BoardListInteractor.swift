import UIKit
import RxSwift

protocol BoardListInteractorInputProtocol {
    func fetchBoards()
    func createBoard()
}

protocol BoardListInteractorOutputProtocol: AnyObject {
    func didFetchBoard(_ boards: [Board])
    func didFailFetchingBoard(_ error: Error)
    func didCreateBoard(_ board: Board)
    func didFailCreatingBoard(_ error: Error)
}

final class BoardListInteractor: BoardListInteractorInputProtocol {
    weak var presenter: BoardListInteractorOutputProtocol?
    private let service: BoardServiceProtocol
    private let userID: String
    private let disposeBag = DisposeBag()
    
    init(service: BoardServiceProtocol, userID: String) {
        self.service = service
        self.userID = userID
    }
    
    func fetchBoards() {
        service.fetchBoards(for: userID)
            .subscribe(onSuccess: { [weak self] boards in
                self?.presenter?.didFetchBoard(boards)
            }, onFailure: { [weak self] error in
                self?.presenter?.didFailFetchingBoard(error)
            })
            .disposed(by: disposeBag)
    }
    
    func createBoard() {
        print("We are in create board")
        service.createBoard(for: userID)
            .subscribe(onSuccess: { [weak self] board in
                self?.presenter?.didCreateBoard(board)
            }, onFailure: { [weak self] error in
                self?.presenter?.didFailCreatingBoard(error)
            })
            .disposed(by: disposeBag)
    }
    
    
}
