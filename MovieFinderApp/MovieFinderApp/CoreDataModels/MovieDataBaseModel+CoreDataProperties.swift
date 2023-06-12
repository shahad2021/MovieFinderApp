import Foundation
import CoreData


extension MovieDataBaseModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieDataBaseModel> {
        return NSFetchRequest<MovieDataBaseModel>(entityName: "MovieDataBaseModel")
    }

    @NSManaged public var url: URL?
    @NSManaged public var title: String?
    @NSManaged public var explanation: String?
    
}

extension MovieDataBaseModel : Identifiable {

}
