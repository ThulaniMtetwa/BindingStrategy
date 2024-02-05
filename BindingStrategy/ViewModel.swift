//
//  ViewModel.swift
//  BindingStrategy
//
//  Created by Thulani Mtetwa on 2024/02/03.
//

import Foundation
import Combine

protocol ViewModelType: AnyObject {
    func isIndicator(enabled: Bool)
    func postData(fromServer: [Post])
}
class ViewModel: NSObject {
    private let networkService = NetworkManager.shared
    public weak var delegate: ViewModelType?
    
    func getAllPosts() {
        DispatchQueue.global().async { [weak self] in
            self?.networkService.getPosts(handler: {[weak self] result in
                switch result {
                case .success(let success):
                    DispatchQueue.main.async {
                        self?.delegate?.postData(fromServer: success)
                    }
                case .failure(let failure):
                    DispatchQueue.main.async {
                        self?.setError(failure.localizedDescription)
                    }
                }
            })
        }
    }
    
    func setError(_ message: String) {
        print("Error: \(message)")
    }
}

extension ViewModel: ObservableObject {}
