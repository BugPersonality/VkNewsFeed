//
//  API.swift
//  VkNewsFeed
//
//  Created by Данил Дубов on 17.09.2021.
//

import Foundation

struct API {
    static let scheme = "https"
    static let host = "api.vk.com"
    static let version = "5.131"

    static let newsFeed = "/method/newsfeed.get"
    static let user = "/method/users.get"
}
