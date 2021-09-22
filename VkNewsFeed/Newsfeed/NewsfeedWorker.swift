//
//  NewsfeedWorker.swift
//  VkNewsFeed
//
//  Created by Данил Дубов on 17.09.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

class NewsfeedService {
    var authService: AuthService
    var networking: Networking
    var fetcher: DataFetcher

    private var feedResponse: FeedResponse?
    private var revealedPostIds: [Int] = []
    private var newFromInProcess: String?

    init() {
        self.authService = SceneDelegate.shared().authService
        self.networking = NetworkService(authService: authService)
        self.fetcher = NetworkDataFetcher(networking: networking)
    }

    func getUser(complition: @escaping (UserResponse?) -> Void) {
        fetcher.getUser { userResponse in
            complition(userResponse)
        }
    }

    func getFeed(complition: @escaping ([Int], FeedResponse) -> Void) {
        fetcher.getFeed(nextBatchFrom: nil) { [weak self] feed in
            self?.feedResponse = feed
            guard let feedResponse = self?.feedResponse else { return }
            complition(self!.revealedPostIds, feedResponse)
        }
    }

    func revealPostIds(forPostId postId: Int, complition: @escaping ([Int], FeedResponse) -> Void) {
        revealedPostIds.append(postId)
        guard let feedResponse = self.feedResponse else { return }
        complition(revealedPostIds, feedResponse)
    }

    func getNextBatch(complition: @escaping ([Int], FeedResponse) -> Void) {
        newFromInProcess = feedResponse?.nextFrom
        fetcher.getFeed(nextBatchFrom: newFromInProcess) { [weak self] feed in
            guard let feed = feed else { return }
            guard self?.feedResponse?.nextFrom != feed.nextFrom else { return }

            if self?.feedResponse == nil {
                self?.feedResponse = feed
            } else {
                self?.feedResponse?.items.append(contentsOf: feed.items)

                var groups = feed.groups
                if let oldGroups = self?.feedResponse?.groups {
                    let oldGroupsFiltered = oldGroups.filter { oldGroup -> Bool in
                        !feed.profiles.contains { $0.id == oldGroup.id }
                    }
                    groups.append(contentsOf: oldGroupsFiltered)
                }
                self?.feedResponse?.groups = groups

                var profiles = feed.profiles
                if let oldProfiles = self?.feedResponse?.profiles {
                    let oldProfilesFiltered = oldProfiles.filter { oldProfile -> Bool in
                        !feed.profiles.contains { $0.id == oldProfile.id }
                    }
                    profiles.append(contentsOf: oldProfilesFiltered)
                }
                self?.feedResponse?.profiles = profiles

                self?.feedResponse?.nextFrom = feed.nextFrom
            }

            guard let feedResponse = self?.feedResponse else { return }

            complition(self!.revealedPostIds, feedResponse)
        }
    }
}
