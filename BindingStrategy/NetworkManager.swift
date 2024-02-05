//
//  NetworkManager.swift
//  BindingStrategy
//
//  Created by Thulani Mtetwa on 2024/02/05.
//

import Foundation

enum APIError: Error {
    case api(description: String)
}

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    func getPosts(handler: @escaping (Result<[Post], APIError>) -> Void) {
        let apiUrl = URL(string: "https://jsonplaceholder.typicode.com/posts")!

        let session = URLSession.shared

        let task = session.dataTask(with: apiUrl) { (data, response, error) in
            if let error = error {
                handler(.failure(.api(description: "Error: \(error.localizedDescription)")))
                return
            }

            guard let data = data else {
                handler(.failure(.api(description: "No data received")))
                return
            }

            do {
                let posts = try JSONDecoder().decode([Post].self, from: data)
                handler(.success(posts))
            } catch {
                handler(.failure(.api(description: "Error decoding JSON: \(error.localizedDescription)")))
            }
        }
        task.resume()
    }
}
