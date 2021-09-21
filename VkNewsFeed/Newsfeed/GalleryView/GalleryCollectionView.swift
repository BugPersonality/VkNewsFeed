//
//  GalleryCollectionView.swift
//  VkNewsFeed
//
//  Created by Данил Дубов on 21.09.2021.
//

import UIKit

class GalleryCollectionView: UICollectionView {

    var photos: [FeedCellPhotoAttachmentViewModel] = []

    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: layout)

        delegate = self
        dataSource = self

        backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        register(GalleryCollectionViewCell.self,
                 forCellWithReuseIdentifier: GalleryCollectionViewCell.reuseId)
    }

    func set(photos: [FeedCellPhotoAttachmentViewModel]) {
        self.photos = photos
        reloadData()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension GalleryCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCell.reuseId,
                                       for: indexPath) as? GalleryCollectionViewCell
        cell!.set(imageUrl: photos[indexPath.row].photoUrlString)
        return cell!
    }

}
