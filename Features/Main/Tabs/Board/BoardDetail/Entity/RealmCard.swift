import RealmSwift

final class RealmCard: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var term: String
    @Persisted var definition: String
    @Persisted var boardID: String
    @Persisted var createdBy: String
}
