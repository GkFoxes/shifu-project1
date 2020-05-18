//
//  NetworkManager.swift
//  Pravda
//
//  Created by Дмитрий Матвеенко on 20/02/2019.
//  Copyright © 2019 GkFoxes. All rights reserved.
//

import UIKit

enum Result<Value> {
    case success(Value)
    case failure(Error)
}

class NetworkManager {
    
    static func getData(forCategory category: String, withPage page: Int, completion: ((Result<News>) -> Void)?) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "newsapi.org"
        urlComponents.path = "/v2/top-headlines"
        
        let countryItem = URLQueryItem(name: "country", value: "us")
        let apiKeyItem = URLQueryItem(name: "apiKey", value: "aa953c7c330a4f13b3fc1a69c1361892")
        let pageItem = URLQueryItem(name: "page", value: "\(page)")
        let categoryItem = URLQueryItem(name: "category", value: category)
        
        urlComponents.percentEncodedQuery = urlComponents.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        urlComponents.queryItems = [countryItem, apiKeyItem, categoryItem, pageItem]
        
        guard let url = urlComponents.url else { fatalError("Could not create URL from components") }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            if let error = responseError {
                completion?(.failure(error))
            } else if let jsonData = responseData {
                let decoder = JSONDecoder()
                do {
                    let posts = try decoder.decode(News.self, from: jsonData)
                    completion?(.success(posts))
                } catch {
                    completion?(.failure(error))
                }
            } else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Data was not retrieved from request"]) as Error
                completion?(.failure(error))
            }
        }
        task.resume()
    }
    
    static func obtainImage(toUrl url: String, with text: String, forCache cache:NSCache<AnyObject, UIImage>, completion: @escaping (UIImage) -> ()) {
        if let image = cache.object(forKey: text as AnyObject) {
            completion(image)
        } else {
            guard let urlPhoto = URL(string: url) else { return }
            let request = URLRequest(url: urlPhoto)
            
            URLSession.shared.dataTask(with: request) { (data, responce, error) in
                guard error == nil else {
                    print("Error: \(String(describing:error?.localizedDescription))")
                    return
                }
                
                guard let data = data, let image = UIImage(data: data) else { return }
                cache.setObject(image, forKey: text as AnyObject)
                completion(image)
            }.resume()
        }
    }
}
