//
//  NewsfeedPresenter.swift
//  VkNewsFeed
//
//  Created by Данил Дубов on 17.09.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol NewsfeedPresentationLogic {
  func presentData(response: Newsfeed.Model.Response.ResponseType)
}

class NewsfeedPresenter: NewsfeedPresentationLogic {
    weak var viewController: NewsfeedDisplayLogic?

    var cellLayoutCalculator: FeedCellLayoutCalculatorProtocol = FeedCellLayoutCalculator()

    let dateFormater: DateFormatter = {
       let dt = DateFormatter()
        dt.locale = Locale(identifier: "ru_RU")
        dt.dateFormat = "d MMM 'в' HH:mm"
        return dt
    }()

    func presentData(response: Newsfeed.Model.Response.ResponseType) {
        switch response {
        case .presentNewsfeed(let feed, let revealdedPostIds):
            let cells = feed.items.map { feedItem in
                cellViewModel(from: feedItem,
                              profiles: feed.profiles,
                              groups: feed.groups,
                              revealdedPostIds: revealdedPostIds)
            }
            let feedViewModel = FeedViewModel.init(cells: cells)
            viewController?.displayData(viewModel: .displayNewsfeed(feedViewModel: feedViewModel))
        case .presentUserInfo(user: let user):
            let userViewModel = UserViewModel.init(photoUrlString: user?.photo100)
            viewController?.displayData(viewModel: .displayUser(userViewModel: userViewModel))
        }
    }

    private func cellViewModel(from feedItem: FeedItem, profiles: [Profile], groups: [Group], revealdedPostIds: [Int]) -> FeedViewModel.Cell {

        let profile = self.profile(for: feedItem.sourceId,
                                   profiles: profiles,
                                   groups: groups)

        let photoAttachments = self.photoAttachments(feedItem: feedItem)

        let date = Date(timeIntervalSince1970: feedItem.date)
        let dateTitle: String = dateFormater.string(from: date)

        let isFullSized = revealdedPostIds.contains(feedItem.postId)

        let sizes = cellLayoutCalculator.sizes(postText: feedItem.text,
                                               photoAttachments: photoAttachments,
                                               isFullSizedPost: isFullSized)

        let postText = feedItem.text?.replacingOccurrences(of: "<br>", with: "\n")

        return FeedViewModel.Cell.init(postId: feedItem.postId,
                                       iconUrlString: profile.photo,
                                       name: profile.name,
                                       date: dateTitle,
                                       text: postText,
                                       likes: formattedCounter(feedItem.likes?.count),
                                       comments: formattedCounter(feedItem.comments?.count),
                                       shares: formattedCounter(feedItem.reposts?.count),
                                       views: formattedCounter(feedItem.views?.count),
                                       photoAttachments: photoAttachments,
                                       sizes: sizes)
    }

    private func formattedCounter(_ counter: Int?) -> String? {
        guard let counter = counter, counter > 0 else { return nil }
        var counterString = String(counter)
        if 4...6 ~= counterString.count {
            counterString = String(counterString.dropFirst(3)) + "K"
        } else if counterString.count > 6 {
            counterString = String(counterString.dropFirst(6)) + "M"
        }
        return counterString
    }

    private func profile(for sourceId: Int, profiles: [Profile], groups: [Group]) -> ProfileRepresentable {
        let profilesOrGroups: [ProfileRepresentable] = sourceId >= 0 ? profiles : groups
        let normalSourceId = sourceId >= 0 ? sourceId : -sourceId
        let profileRepresentable = profilesOrGroups.first { (myprofileRepresentable) -> Bool in
            myprofileRepresentable.id == normalSourceId
        }
        return profileRepresentable!
    }

    private func photoAttachment(feedItem: FeedItem) -> FeedViewModel.FeedCellPhotoAttachment? {
        guard let photos = feedItem.attachments?.compactMap({ attachment in
            attachment.photo
        }), let firstPhoto = photos.first else {
            return nil
        }
        return FeedViewModel.FeedCellPhotoAttachment.init(photoUrlString: firstPhoto.srcBIG,
                                                          width: firstPhoto.width,
                                                          height: firstPhoto.height)
    }

    private func photoAttachments(feedItem: FeedItem) -> [FeedViewModel.FeedCellPhotoAttachment] {
        guard let photos = feedItem.attachments else { return [] }
        return photos.compactMap { attachments -> FeedViewModel.FeedCellPhotoAttachment? in
            guard let photo = attachments.photo else { return nil }
            return FeedViewModel.FeedCellPhotoAttachment.init(photoUrlString: photo.srcBIG,
                                                              width: photo.width,
                                                              height: photo.height)
        }
    }

}
