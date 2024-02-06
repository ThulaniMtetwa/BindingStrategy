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
    private lazy var viewModel: ViewModel = {
        let model = ViewModel()
        return model
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        viewModel.handlePostServerData()
        tableView.register(MyTableViewCell.self, forCellReuseIdentifier: MyTableViewCell.reuseIdentifier)
    }
    
    private func bind() {
        viewModel.$fetchPostsSucceed.receive(on: DispatchQueue.main)
            .dropFirst()
            .sink {[weak self] posts in
                self?.posts = posts
            }.store(in: &cancellables)
        
        let stateValueHandler: (ViewModelState) -> Void = { [weak self] state in
            switch state {
            case .loading:
                //Start loading indicator
                break
            case .finishedLoading:
                //Stop loading indicator
                self?.tableView.reloadData()
            case .error(let error):
                //Stop loading indicator
                self?.showError(error)
            }
        }
        
        viewModel.$state
            .receive(on: RunLoop.main)
            .sink(receiveValue: stateValueHandler)
            .store(in: &cancellables)
    }
    
    private func showError(_ error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default) { [unowned self] _ in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
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
