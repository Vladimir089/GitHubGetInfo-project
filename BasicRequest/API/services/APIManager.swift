//
//  APIManager.swift
//  BasicRequest
//
//  Created by Владимир on 12.09.2023.
//

import Foundation


struct GitHubUser: Codable {
    let name: String?
    let avatarUrl: String
    let bio: String?
    let followers: Int
    let publicRepos: Int?
}
