import UIKit
import RxSwift
import Foundation

protocol BoardServiceProtocol {
    func fetchBoards(for uid: String) -> Single<[Board]>
    func createBoard(for uid: String) -> Single<Board>
}

final class BoardService: BoardServiceProtocol {
    func fetchBoards(for uid: String) -> Single<[Board]> {
        Single.create { single in
            FirestorePaths.boardsCollection()
                .whereField("ownerUID", isEqualTo: uid)
                .getDocuments { snapshot, error in
                    if let error = error {
                        single(.failure(error))
                    } else if let documents = snapshot?.documents {
                        do {
                            let boards = try documents.map { try $0.data(as: Board.self) }
                            single(.success(boards))
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
    
    func createBoard(for uid: String) -> Single<Board> {
        Single.create { single in
            let boardID = UUID().uuidString
            let board = Board(
                boardID: boardID,
                ownerUID: uid,
                profilePictures: [],
                title: "New board",
                description: "Desription",
                createdAt: Date()
            )
            
            do {
                try FirestorePaths.boardRef(boardID: boardID).setData(from: board) { error in
                    if let error = error {
                        single(.failure(error))
                    } else {
                        single(.success(board))
                    }
                }
            } catch {
                single(.failure(error))
            }
            
            return Disposables.create()
        }
    }
}
