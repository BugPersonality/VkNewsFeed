//
//  GalleryCollectionViewCell.swift
//  VkNewsFeed
//
//  Created by Данил Дубов on 21.09.2021.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {

    static let reuseId = "GalleryCollectionViewCell"

    let myImageView: WebImageView = {
        let imageView = WebImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(myImageView)
        backgroundColor = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)

        // myImageView.constraints
        myImageView.fillSuperview()
    }

    override func prepareForReuse() {
        myImageView.image = nil
    }

    func set(imageUrl: String?) {
        myImageView.set(imageUrl: imageUrl)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
