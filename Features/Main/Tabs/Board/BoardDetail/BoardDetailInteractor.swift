import UIKit
import RxSwift

protocol BoardDetailInteractorInputProtocol {
    func fetchCards()
    func createCard()
    func deleteCards()
}

protocol BoardDetailInteractorOutputProtocol: AnyObject {
    func didFetchCards(_ cards: [Card])
    func didFailFetchingCards(_ error: Error)
}

final class BoardDetailInteractor: BoardDetailInteractorInputProtocol {
    
    weak var presenter: BoardDetailInteractorOutputProtocol?
    private let service: BoardDetailServiceProtocol
    private let boardID: String
    private let disposeBag = DisposeBag()
    
    init(service: BoardDetailServiceProtocol, boardID: String) {
        self.service = service
        self.boardID = boardID
    }
    
    func fetchCards() {
        service.fetchCards(for: boardID)
            .subscribe(onSuccess: { [weak self] cards in
                self?.presenter?.didFetchCards(cards)
            }, onFailure: { [weak self] error in
                self?.presenter?.didFailFetchingCards(error)
            })
            .disposed(by: disposeBag)
    }
    
    func createCard() {
        service.createCard(for: boardID)
            .subscribe(onSuccess: { [weak self] in
                self?.fetchCards()
            }, onFailure: { [weak self] error in
                self?.presenter?.didFailFetchingCards(error)
            })
            .disposed(by: disposeBag)
    }
    
    func deleteCards() {
        service.deleteCards(for: boardID)
                .subscribe(
                    onCompleted: { [weak self] in
                    self?.fetchCards()
                    },
                    onError: { [weak self] error in
                    self?.presenter?.didFailFetchingCards(error)
                })
                .disposed(by: disposeBag)
    }
}
