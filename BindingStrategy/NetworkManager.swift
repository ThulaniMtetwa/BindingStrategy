//
//  NetworkManager.swift
//  BindingStrategy
//
//  Created by Thulani Mtetwa on 2024/02/05.
//

import Foundation
import Combine

enum APIError: Error {
    case api(description: String)
}

protocol NetworkManagerType: AnyObject {
    func getPosts() -> AnyPublisher<[Post], Error>
}

class NetworkManager: NetworkManagerType {
    static let shared = NetworkManager()
    private init() {}
    
    func getPosts() -> AnyPublisher<[Post], Error> {
        let apiUrl = URL(string: "https://jsonplaceholder.typicode.com/posts")!
        
        let session = URLSession.shared
        
        return session.dataTaskPublisher(for: apiUrl)
            .catch({ error in
                return Fail(error: error).eraseToAnyPublisher()
            }).map({ $0.data
            }).decode(type: [Post].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
