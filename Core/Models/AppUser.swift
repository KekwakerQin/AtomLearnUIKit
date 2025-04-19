import Foundation
import FirebaseFirestore

struct AppUser: Codable {
    @DocumentID var id: String? // uid
    let photoURL: String?
    let registeredAt: Date
    let uid: String
}
