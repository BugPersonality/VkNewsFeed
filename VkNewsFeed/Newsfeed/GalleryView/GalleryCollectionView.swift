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
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
        let rowLayout = RowLayout()
        super.init(frame: .zero, collectionViewLayout: rowLayout)

        delegate = self
        dataSource = self

        backgroundColor = UIColor.white
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false

        register(GalleryCollectionViewCell.self,
                 forCellWithReuseIdentifier: GalleryCollectionViewCell.reuseId)
        rowLayout.delegate = self
    }

    func set(photos: [FeedCellPhotoAttachmentViewModel]) {
        self.photos = photos
        contentOffset = CGPoint.zero
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

extension GalleryCollectionView: RowLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, photoAtIndexPath indexPath: IndexPath) -> CGSize {
        let width = photos[indexPath.row].width
        let height = photos[indexPath.row].height
        return CGSize(width: width, height: height)
    }
}

// extension GalleryCollectionView: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: frame.width, height: frame.height)
//    }
// }
