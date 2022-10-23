import Foundation
import CoreLocation

struct UnsplashManager {
    var delegate: UnsplashManagerDelegate?
    let unsplashURL = "https://api.unsplash.com/search/photos?client_id=\(K.unsplashkey)"
    
    func fetchImage(key: String){
        let urlString = "\(unsplashURL)&query=\(key)&page=1&per_page=1&orientation=portrait"
        print(urlString)
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
    
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
         
            let task = session.dataTask(with: url, completionHandler: {(data, urlResponse, error) in
                
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                }
                
                if let safeData = data {
                    if let unsplashModel = self.parseJSON(unsplashData: safeData) {
                        self.delegate?.didUpdateImage(self, unsplashModel: unsplashModel)
                    }
                }
                
            })
            task.resume()
        }
        
    }
    
    func parseJSON(unsplashData: Data) -> UnsplashModel? {
        let decoder = JSONDecoder()
        do {
            let unsplashModel = try decoder.decode(UnsplashModel.self, from: unsplashData)
            return unsplashModel
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
