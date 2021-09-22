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

    func makeRequest(request: Newsfeed.Model.Request.RequestType) {
        if service == nil {
            service = NewsfeedService()
        }

        switch request {
        case .getNewsfeed:
            service?.getFeed { [weak self] (revealdPostIds, feed) in
                self?.presenter?.presentData(response: .presentNewsfeed(feed: feed, revealdedPostIds: revealdPostIds))
            }
        case .revealPostIds(postId: let postId):
            service?.revealPostIds(forPostId: postId) { [weak self] (revealdPostIds, feed) in
                self?.presenter?.presentData(response: .presentNewsfeed(feed: feed, revealdedPostIds: revealdPostIds))
            }
        case .getUser:
            service?.getUser { user in
                self.presenter?.presentData(response: .presentUserInfo(user: user))
            }
        case .getNextBatch:
            self.presenter?.presentData(response: .presentFooterLoader)

            service?.getNextBatch { [weak self] (revealdPostIds, feed) in
                self?.presenter?.presentData(response: .presentNewsfeed(feed: feed, revealdedPostIds: revealdPostIds))
            }
        }
    }
}
