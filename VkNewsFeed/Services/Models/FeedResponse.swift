//
//  FeedResponse.swift
//  VkNewsFeed
//
//  Created by Данил Дубов on 17.09.2021.
//

import Foundation

struct FeedResponseWrapped: Decodable {
    let response: FeedResponse
}

struct FeedResponse: Decodable {
    var items: [FeedItem]
    var profiles: [Profile]
    var groups: [Group]
}

// MARK: - Items

struct FeedItem: Decodable {
    let sourceId: Int
    let postId: Int
    let text: String?
    let date: Double
    let comments: CountableItem?
    let likes: CountableItem?
    let reposts: CountableItem?
    let views: CountableItem?
    let attachments: [Attachments]?
}

struct CountableItem: Decodable {
    let count: Int
}

struct Attachments: Decodable {
    let photo: Photo?
}

struct Photo: Decodable {
    let sizes: [PhotoSize]

    var height: Int {
        getPropperSize().height
    }

    var width: Int {
        getPropperSize().width
    }

    var srcBIG: String {
        getPropperSize().url
    }

    private func getPropperSize() -> PhotoSize {
        if let sizeX = sizes.first(where: { $0.type == "x" }) {
            return sizeX
        } else if let fallBackSize = sizes.last {
            return fallBackSize
        } else {
            return PhotoSize(type: "wrong image", url: "wrong image", width: 0, height: 0)
        }
    }
}

struct PhotoSize: Decodable {
    let type: String
    let url: String
    let width: Int
    let height: Int
}

// MARK: - ProfileRepresentable - Profile and Group

protocol ProfileRepresentable {
    var id: Int { get }
    var name: String { get }
    var photo: String { get }
}

// MARK: - Profile

struct Profile: Decodable, ProfileRepresentable {
    let id: Int
    let firstName: String
    let lastName: String
    let photo100: String

    var name: String { return "\(firstName) \(lastName)"}
    var photo: String { return photo100 }
}

// MARK: - Group

struct Group: Decodable, ProfileRepresentable {
    let id: Int
    let name: String
    let photo100: String

    var photo: String { return photo100 }
}
