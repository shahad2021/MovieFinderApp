import Foundation

class HomeViewModel {
    var updateUI:(()->())?
    
    var movies: [Movie] = [] {
        didSet {
            updateUI?()
        }
    }
    
    func searchMovies(by name: String, completion: @escaping (Error?)-> Void) {
        NetworkManager.shared.fetchMovie(with: name) {[weak self] movieData, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }

            DispatchQueue.main.async {
                completion(nil)
                self?.movies = movieData ?? []
            }

        }
    }
}
