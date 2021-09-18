//
//  WebImageView.swift
//  VkNewsFeed
//
//  Created by Данил Дубов on 17.09.2021.
//

import UIKit

class WebImageView: UIImageView {
    func set(imageUrl: String) {
        guard let url = URL(string: imageUrl) else { return }

        // Check Image in Cache

        if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            self.image = UIImage(data: cachedResponse.data)
            return
        }

        // Load Image form Internet

        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, response, _) in
            DispatchQueue.main.async {
                if let data = data, let response = response {
                    self?.image = UIImage(data: data)
                    self?.handleLoadedImage(data: data, response: response) // Load Image in Cache
                }
            }
        }

        dataTask.resume()
    }

    // Load Image to Cache

    private func handleLoadedImage(data: Data, response: URLResponse) {
        guard let responseURL = response.url else { return }
        let cachedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedResponse, for: URLRequest(url: responseURL))
    }
}
