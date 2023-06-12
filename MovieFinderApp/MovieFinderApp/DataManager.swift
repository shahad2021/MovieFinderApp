import Foundation
import CoreData
import UIKit
import StoreKit

class DataManager {
    
    static let shared = DataManager()

    let moc = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
  
    
    func saveMovie(movie: Movie){
        let pic: [MovieDataBaseModel] = getMovies()

        let urls = pic.compactMap { $0.url }
        guard let url = movie.url, !urls.contains(url) else{
            return
        }
        let entity = NSEntityDescription.insertNewObject(forEntityName: "MovieDataBaseModel", into: moc!) as? MovieDataBaseModel
        entity?.title = movie.title
        entity?.url = url
        entity?.explanation = movie.overview
        saveMOC()
    }
    
    func getMovies() -> [MovieDataBaseModel]{
        var pics = [MovieDataBaseModel]()
        let fetchRequest = NSFetchRequest<MovieDataBaseModel>(entityName: "MovieDataBaseModel")
        do{
            pics = try (moc?.fetch(fetchRequest) as? [MovieDataBaseModel])!
        }catch{
            print("can not get data")
        }
        return pics
    }
    
    func deleteImages(index: URL) {
        let pic = getMovies()
        let urls = pic.compactMap{ $0.url }
        guard urls.contains(index) else{
            return
        }
        pic.forEach { img in
            if img.url == index {
                moc?.delete(img)
                saveMOC()
            }
        }
    }
    
    func deleteAllImage(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieDataBaseModel")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try moc?.execute(batchDeleteRequest)
        } catch let error as NSError {
            print("Failed to clear Core Data: \(error), \(error.userInfo)")
        }

    }
    
    func saveMOC(){
        do {
            try moc?.save()
            print("Image saved successfully.")
        } catch {
            print("Failed to save image: \(error)")
        }
    }
}
