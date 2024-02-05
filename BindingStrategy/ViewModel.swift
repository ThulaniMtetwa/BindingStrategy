//
//  ViewModel.swift
//  BindingStrategy
//
//  Created by Thulani Mtetwa on 2024/02/03.
//

import Foundation
import Combine

class ViewModel: NSObject {
    enum Input {
        case viewDidAppear
        case pullToRefresh
    }
    
    enum Output {
        case fetchPostsSucceed(posts: [Post])
        case fetchPostsFailed(error: Error)
        case handleActivityIndicate(isEnabled: Bool)
    }
    
    private let networkAPIService: NetworkManagerType
    private let output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    init(networkAPIService: NetworkManagerType = NetworkManager.shared) {
        self.networkAPIService = networkAPIService
    }
    
    public func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink{ [weak self] events in
            switch events {
            case .pullToRefresh, .viewDidAppear:
                self?.handlePostServerData()
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    private func handlePostServerData() {
        output.send(.handleActivityIndicate(isEnabled: false))
        
        networkAPIService.getPosts().sink(receiveCompletion: { [weak self] completion in
            self?.output.send(.handleActivityIndicate(isEnabled: true))
            
            if case .failure(let failure) = completion {
                self?.output.send(.fetchPostsFailed(error: failure))
            }
        }, receiveValue: { [weak self] posts in
            self?.output.send(.fetchPostsSucceed(posts: posts))
        }).store(in: &cancellables)
    }
}
