//
//  FeedViewController.swift
//  VkNewsFeed
//
//  Created by Данил Дубов on 17.09.2021.
//

import UIKit

class FeedViewController: UIViewController {

    private var feetcher: DataFetcher = NetworkDataFetcher(networking: NetworkService())

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.blue

        feetcher.getFeed { feedResponse in
            guard let feedResponse = feedResponse else { return }
            
            feedResponse.items.map { feedItem in
                print(feedItem.date)
            }
        }
        
    }
}
