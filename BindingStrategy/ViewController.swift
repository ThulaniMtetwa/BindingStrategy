//
//  ViewController.swift
//  BindingStrategy
//
//  Created by Thulani Mtetwa on 2024/02/03.
//

import UIKit
import Combine

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    private var posts = [Post]()
    private var cancellables = Set<AnyCancellable>()
    private let input: PassthroughSubject<ViewModel.Input, Never> = .init()
    private lazy var viewModel: ViewModel = {
        let model = ViewModel()
        return model
        }()

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        tableView.register(MyTableViewCell.self, forCellReuseIdentifier: MyTableViewCell.reuseIdentifier)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        input.send(.viewDidAppear)
    }
    
    private func bind() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output.receive(on: DispatchQueue.main)
            .sink {[weak self] event in
                switch event {
                case .fetchPostsFailed(let error):
                    print(error.localizedDescription)
                case .fetchPostsSucceed(let posts):
                    self?.posts = posts
                    self?.tableView.reloadData()
                case .handleActivityIndicate(let isEnabled):
                    //handle data activity indicator
                    print("Will show actitivityIndicator: \(isEnabled)")
                }
            }.store(in: &cancellables)
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyTableViewCell.reuseIdentifier, for: indexPath) as! MyTableViewCell
        
        let post = posts[indexPath.row]
         cell.titleLabel.text = post.title
         cell.bodyLabel.text = post.body
        
        return cell
    }
}
