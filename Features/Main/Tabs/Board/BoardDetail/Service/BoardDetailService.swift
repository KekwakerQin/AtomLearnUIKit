import UIKit
import RxSwift
import Firebase

protocol BoardDetailServiceProtocol {
    func fetchCards(for boardID: String) -> Single<[Card]>
    func createCard(for boardID: String) -> Single<Void>
    func deleteCards(for boardID: String) -> Completable
}

final class BoardDetailService: BoardDetailServiceProtocol {
    
    func fetchCards(for boardID: String) -> Single<[Card]> {
        Single.create { single in
            FirestorePaths.cardsCollection(forBoard: boardID)
                .getDocuments { snapshot, error in
                    if let error = error {
                        single(.failure(error))
                    } else if let documents = snapshot?.documents {
                        do {
                            let cards = try documents.map { try $0.data(as: Card.self) }
                            single(.success(cards))
                        } catch {
                            single(.failure(error))
                        }
                    } else {
                        single(.success([]))
                    }
                }
            return Disposables.create()
        }
    }
    
    func createCard(for boardID: String) -> Single<Void> {
        let cardID = UUID().uuidString
        let card = Card(
            id: cardID,
            term: "Atom",
            definition: "Learn",
            boardID: boardID,
            createdBy: SessionManager.shared.currentUser?.uid ?? "unknown"
        )
        
        let cardRef = FirestorePaths.cardsCollection(forBoard: boardID).document(cardID)
        
        return Single.create { single in
            do {
                try cardRef.setData(from: card) { error in
                    if let error = error {
                        single(.failure(error))
                    } else {
                        single(.success(()))
                    }
                }
            } catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
    
    func deleteCards(for boardID: String) -> Completable {
        let cardsRef = FirestorePaths.cardsCollection(forBoard: boardID)
        
        return Completable.create { completable in
            cardsRef.getDocuments { snapshot, error in
                if let error = error {
                    completable(.error(error))
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    completable(.completed)
                    return
                }
                
                let batch = Firestore.firestore().batch()
                for doc in documents {
                    batch.deleteDocument(doc.reference)
                }
                
                batch.commit { error in
                    if let error = error {
                        completable(.error(error))
                    } else {
                        completable(.completed)
                    }
                }
            }
            
            return Disposables.create()
        }
    }
}
