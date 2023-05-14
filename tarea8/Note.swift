import CoreData

@objc(Note)
class Note: NSManagedObject
{
    @NSManaged var id: NSNumber!
    @NSManaged var curso: String!
    @NSManaged var promprac: String!
    @NSManaged var promlab: String!
    @NSManaged var examfinal: String!
    @NSManaged var deletedDate: Date?
}
