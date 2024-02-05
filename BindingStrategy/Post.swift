//
//  Post.swift
//  BindingStrategy
//
//  Created by Thulani Mtetwa on 2024/02/05.
//

import Foundation

struct Post: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
