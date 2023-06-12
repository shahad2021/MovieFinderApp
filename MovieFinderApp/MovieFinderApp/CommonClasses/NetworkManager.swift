import Foundation
import Firebase

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}

    private lazy var session : URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = TimeInterval(20)
        configuration.timeoutIntervalForResource = TimeInterval(40)
        let session = URLSession.init(configuration: configuration)
        return session
    }()
    
    func fetchMovie(with movieName: String, completion: @escaping ([Movie]?, Error?) -> Void) {
            guard let encodedMovieName = movieName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                print("Invalid book name")
                return
            }

        let apiKey = "623190b3e629cdad4c5b7e15e08c2b6c" // Replace with your TMDb API key
        let urlString = "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&query=\(encodedMovieName)"

            guard let url = URL(string: urlString) else {
                print("Invalid URL")
                return
            }

            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Error: \(error)")
                    completion(nil, error)
                    return
                }

                guard let data = data else {
                    print("No data received")
                    completion([], nil)
                    return
                }

                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                       print(json)
                        let movieResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
                        completion(movieResponse.results ?? [], nil)
                    } else {
                        completion([], nil)
                        print(response)
                    }
                }
                catch {
                    print("Error parsing JSON: \(error)")
                    completion([], nil)
                }
            }
            task.resume()
        }

    func registerUser(email: String, password: String, completionHandler: @escaping (AuthDataResult?, Error?)->())  {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                print("Error registering user: \(error.localizedDescription)")
                completionHandler(nil, error)
            } else {
                print("User registered successfully.")
                completionHandler(authResult, nil)
                // Handle successful user registration, such as navigating to the main app screen
            }
        }
    }

    func loginUser(email: String, password: String, completionHandler: @escaping (AuthDataResult?, Error?)->())  {
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                print("Error logging in: \(error.localizedDescription)")
                completionHandler(nil, error)
            } else {
                print("User logged in successfully.")
                completionHandler(authResult, nil)
            }
        }
    }
}


//if let json = value as? [String: Any], let results = json["results"] as? [[String: Any]] {
//    for result in results {
//        // Extract movie details from the result
//        let title = result["title"] as? String ?? ""
//        let overview = result["overview"] as? String ?? ""
//        // ...
//    }
//}



struct MovieResponse: Codable {
    let results: [Movie]?
}

struct Movie: Codable {
    let title: String
    let overview: String
    let posterPath: String?

    enum CodingKeys: String, CodingKey {
        case title
        case overview
        case posterPath = "poster_path"
    }

    var url: URL? {
        let basePosterURL = "https://image.tmdb.org/t/p/"
        let posterSize = "w500"
        if let strurl = posterPath, let url = URL(string: basePosterURL + posterSize + strurl) {
            return url
        }
        return nil
    }
}
