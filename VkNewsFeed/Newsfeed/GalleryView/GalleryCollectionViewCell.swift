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
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(myImageView)

        // myImageView.constraints
        myImageView.fillSuperview()
    }

    override func prepareForReuse() {
        myImageView.image = nil
    }

    func set(imageUrl: String?) {
        myImageView.set(imageUrl: imageUrl)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        myImageView.layer.masksToBounds = true
        myImageView.layer.cornerRadius = 10
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
