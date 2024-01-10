// Copyright © 2021 Intuit, Inc. All rights reserved.

import Foundation
import UIKit

struct Pagination{
    var page: Int = 0
    var limit: Int = 10
    
    init(_ page:Int, limit:Int){
        self.page = page
        self.limit = limit
    }
}

/// Network interface
class Network {
    
    /// Errors from network responses
    ///
    /// - badUrl: URL could not be created
    /// - responseError: The request was unsuccessful due to an error
    /// - responseNoData: The request returned no usable data
    enum NetworkError: Int {
        case badUrl
        case responseError
        case responseNoData
        case decodeError
    }
    
    enum RestMethod: String {
        case get = "GET"
        case post = "POST"
        case delete = "DELETE"
        case put = "PUT"
    }
    
    enum APIUrl: String {
        case catBreed = "https://api.thecatapi.com/v1/breeds"
    }
    
   
    
    class func fetchData<T: Decodable>(url: String, _ pageInfo: Pagination,method: RestMethod, onCompletion handler: @escaping (Result<T, Error>) -> Void ) {
        let urlComponent = URLComponents(string: url)
        if var urlComponent = urlComponent {
            urlComponent.queryItems = [
                URLQueryItem(name: "limit", value: "\(String(describing: pageInfo.limit))"),
                URLQueryItem(name: "page", value: "\(String(describing: pageInfo.page))")
            ]
        }
        guard let requestUrl = urlComponent?.url else {
            let error = NSError(domain: "Network.UrlIssue", code: NetworkError.badUrl.rawValue, userInfo: nil)
            return handler(.failure(error))
        }
        
        var urlRequest = URLRequest(url: requestUrl)
        urlRequest.httpMethod = method.rawValue
        
        URLSession.shared.dataTask(with: urlRequest) { receivedData, receivedResponse, receivedError in
            /// Check HTTP Status
            guard let response = receivedResponse as? HTTPURLResponse, response.statusCode < 300 else {
                let error = NSError(domain: "Network.ResponseError", code: NetworkError.responseError.rawValue, userInfo: nil)
                return handler(.failure(error))
            }
            
            /// Check against errors
            guard receivedError == nil else {
                let error = NSError(domain: "Network.fetchCats", code: NetworkError.responseError.rawValue, userInfo: nil)
                return handler(Result.failure(error))
            }
            
            /// Check for non-nil response data
            guard let data = receivedData else {
                let error = NSError(domain: "Network.fetchCats", code: NetworkError.responseNoData.rawValue, userInfo: nil)
                return handler(Result.failure(error))
            }
            
            do {
                /// Decode the JSON response into a CatBreed object array
                let parsedResponse = try JSONDecoder().decode(T.self, from: data)
                
                /// Return the data
                handler(.success(parsedResponse))

            } catch {

                /// Unable to decode the response
                let error = NSError(domain: "Network.decode", code: NetworkError.decodeError.rawValue, userInfo: nil)
                return handler(Result.failure(error))
            }
        }.resume()
    }
    
    /// FetchCatBreeds - retrieve a list of cat breeds from The Cat API
    ///
    /// - Parameter completion: Closure that returns CatBreed on success, an Error on failure
    class func fetchCatBreeds(completion: @escaping (Swift.Result<[CatBreed], Error>) -> Void) {
        
        /// Create the URL for the request
        guard let url = URL(string: "https://api.thecatapi.com/v1/breeds") else {
            let error = NSError(domain: "Network.fetchCats", code: NetworkError.badUrl.rawValue, userInfo: nil)
            return completion(Result.failure(error))
        }
        
        /// Start a data task for the URL
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            /// Check against errors
            guard error == nil else {
                let error = NSError(domain: "Network.fetchCats", code: NetworkError.responseError.rawValue, userInfo: nil)
                return completion(Result.failure(error))
            }
            
            /// Check for non-nil response data
            guard let data = data else {
                let error = NSError(domain: "Network.fetchCats", code: NetworkError.responseNoData.rawValue, userInfo: nil)
                return completion(Result.failure(error))
            }
            
            do {
                let breeds: [CatBreed]
                
                /// Decode the JSON response into a CatBreed object array
                breeds = try JSONDecoder().decode([CatBreed].self, from: data)
                
                /// Return the data
                completion(.success(breeds))

            } catch {

                /// Unable to decode the response
                let error = NSError(domain: "Network.decode", code: NetworkError.decodeError.rawValue, userInfo: nil)
                return completion(Result.failure(error))
            }
            
        }.resume()
    }
    
    class func fetchCatDetails(breedId: String, completion: @escaping (Swift.Result<UIImage, Error>) -> Void) {

        guard let url = URL(string: "https://api.thecatapi.com/v1/images/search?breed_ids=\(breedId)&include_breeds=true") else {
            let error = NSError(domain: "Network.fetchCatDetails", code: NetworkError.badUrl.rawValue, userInfo: nil)
            return completion(Result.failure(error))
        }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            
            guard error == nil else {
                let error = NSError(domain: "Network.fetchCatDetails", code: NetworkError.responseError.rawValue, userInfo: nil)
                return completion(Result.failure(error))
            }
            
            guard let data = data else {
                let error = NSError(domain: "Network.fetchCatDetails", code: NetworkError.responseNoData.rawValue, userInfo: nil)
                return completion(Result.failure(error))
            }
            
            do {
                let catDetails: [IntuitCatDetails]
                
                catDetails = try JSONDecoder().decode([IntuitCatDetails].self, from: data)
                
                guard let catDetailImageUrl = catDetails.first?.url else {
                    let error = NSError(domain: "Network.fetchCatDetails", code: NetworkError.responseNoData.rawValue, userInfo: nil)
                    return completion(Result.failure(error))
                }
                
                guard let catImageUrl = URL(string: catDetailImageUrl) else {
                    let error = NSError(domain: "Network.fetchCatDetails", code: NetworkError.responseNoData.rawValue, userInfo: nil)
                    return completion(Result.failure(error))
                }
                
                let imageData = try Data(contentsOf: catImageUrl)
                
                guard let image = UIImage(data: imageData) else {
                    let error = NSError(domain: "Network.fetchCatDetails", code: NetworkError.responseNoData.rawValue, userInfo: nil)
                    return completion(Result.failure(error))
                }
                
                completion(.success(image))

            } catch {

                let error = NSError(domain: "Network.decode", code: NetworkError.decodeError.rawValue, userInfo: nil)
                return completion(Result.failure(error))
            }

        }.resume()
    }
}

