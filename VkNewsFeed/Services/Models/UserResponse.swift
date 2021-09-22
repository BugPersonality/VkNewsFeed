//
//  UserResponse.swift
//  VkNewsFeed
//
//  Created by Данил Дубов on 21.09.2021.
//

import Foundation

struct UserResponseWrapped: Decodable {
    let response: [UserResponse]
}

struct UserResponse: Decodable {
    let photo100: String?
}
