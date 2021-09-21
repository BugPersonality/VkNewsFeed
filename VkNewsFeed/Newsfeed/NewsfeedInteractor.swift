//
//  NewsfeedInteractor.swift
//  VkNewsFeed
//
//  Created by Данил Дубов on 17.09.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol NewsfeedBusinessLogic {
  func makeRequest(request: Newsfeed.Model.Request.RequestType)
}

class NewsfeedInteractor: NewsfeedBusinessLogic {

    var presenter: NewsfeedPresentationLogic?
    var service: NewsfeedService?

    private var fetcher: DataFetcher = NetworkDataFetcher(networking: NetworkService())
    private var feedResponse: FeedResponse?
    private var revealedPostIds: [Int] = []

    func makeRequest(request: Newsfeed.Model.Request.RequestType) {
        if service == nil {
            service = NewsfeedService()
        }

        switch request {
        case .getNewsfeed:
            fetcher.getFeed { [weak self] feedResponse in
                self?.feedResponse = feedResponse
                self?.presentFeed()
            }
        case .revealPostIds(postId: let postId):
            revealedPostIds.append(postId)
            presentFeed()
        }
    }
    private func presentFeed() {
        guard let feedResponse = feedResponse else { return }
        presenter?.presentData(response: .presentNewsfeed(feed: feedResponse,
                                                          revealdedPostIds: revealedPostIds))
    }
}
