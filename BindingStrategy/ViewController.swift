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
    
    lazy var viewModel: ViewModel = {
        let model = ViewModel()
        model.delegate = self
        return model
        }()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getAllPosts()
        tableView.register(MyTableViewCell.self, forCellReuseIdentifier: MyTableViewCell.reuseIdentifier)
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

extension ViewController: ViewModelType {
    func isIndicator(enabled: Bool) {
        //Show activity Indicator
    }
    
    func postData(fromServer: [Post]) {
        self.posts = fromServer
        self.tableView.reloadData()
    }
}
