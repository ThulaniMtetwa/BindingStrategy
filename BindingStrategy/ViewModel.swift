//
//  ViewModel.swift
//  BindingStrategy
//
//  Created by Thulani Mtetwa on 2024/02/03.
//

import Foundation
import Combine

enum ViewModelError: Error, Equatable, LocalizedError {
    case getPosts
    var errorDescription: String? {
        switch self {
        case .getPosts:
            return NSLocalizedString(
                "Failed to get Posts from Server",
                comment: ""
            )
        }
    }
}

enum ViewModelState: Equatable {
    case loading
    case finishedLoading
    case error(ViewModelError)
}

class ViewModel: NSObject, ObservableObject {
    private var networkAPIService: NetworkManagerType
    private var cancellables = Set<AnyCancellable>()
    @Published private(set) var fetchPostsSucceed = [Post]()
    @Published private(set) var state: ViewModelState = .loading
    
    init(networkAPIService: NetworkManagerType = NetworkManager.shared) {
        self.networkAPIService = networkAPIService
    }
    
    public func handlePostServerData() {
        state = .loading
        
        networkAPIService.getPosts().sink(receiveCompletion: { [weak self] completion in
            if case .failure(let failure) = completion {
                self?.state = .error(.getPosts)
            }
        }, receiveValue: { [weak self] posts in
            self?.fetchPostsSucceed = posts
            self?.state = .finishedLoading
        }).store(in: &cancellables)
    }
}
