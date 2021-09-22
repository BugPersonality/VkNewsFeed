//
//  RowLayout.swift
//  VkNewsFeed
//
//  Created by Данил Дубов on 21.09.2021.
//

import UIKit

protocol RowLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, photoAtIndexPath indexPath: IndexPath) -> CGSize
}

class RowLayout: UICollectionViewLayout {
    weak var delegate: RowLayoutDelegate!

    static var numberOfRows = 1
    fileprivate var cellPadding: CGFloat = 8

    fileprivate var cach: [UICollectionViewLayoutAttributes] = []

    fileprivate var contentWidth: CGFloat = 0

    // Constant
    fileprivate var contentHeight: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        let insets = collectionView.contentInset
        return collectionView.bounds.height - (insets.left + insets.right)
    }

    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }

    override func prepare() {
        contentWidth = 0
        cach.removeAll()
        guard cach.isEmpty == true, let collectionView = collectionView else { return }

        var photos: [CGSize] = []
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            let photoSize = delegate.collectionView(collectionView, photoAtIndexPath: indexPath)
            photos.append(photoSize)
        }

        let superViewWidth = collectionView.frame.width
        guard var rowHeight = RowLayout.rowHeightCounter(superViewWidth: superViewWidth, photosArray: photos) else { return }
        rowHeight /= CGFloat(RowLayout.numberOfRows)

        let photosRatios = photos.map { $0.height / $0.width }

        var yOffset: [CGFloat] = []
        for row in 0..<RowLayout.numberOfRows {
            yOffset.append(CGFloat(row) * rowHeight)
        }

        var xOffset: [CGFloat] = Array(repeating: 0, count: RowLayout.numberOfRows)

        var row = 0
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)

            let ratio = photosRatios[indexPath.row]
            let width = rowHeight / ratio
            let frame = CGRect(x: xOffset[row], y: yOffset[row], width: width, height: rowHeight)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)

            let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attribute.frame = insetFrame
            cach.append(attribute)

            contentWidth = max(contentWidth, frame.maxX)
            xOffset[row] += width
            row = row < (RowLayout.numberOfRows - 1) ? (row + 1) : 0
        }
    }

    static func rowHeightCounter(superViewWidth: CGFloat, photosArray: [CGSize]) -> CGFloat? {
        var rowHeight: CGFloat

        let photoWithMinRation = photosArray.min { (first, second) -> Bool in
            (first.height / first.width) < (second.height / second.width)
        }

        guard let myPhotoWithMinRation = photoWithMinRation else { return nil}

        let difference = superViewWidth / myPhotoWithMinRation.width
        rowHeight = myPhotoWithMinRation.height * difference

        rowHeight *= CGFloat(RowLayout.numberOfRows)
        return rowHeight
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []

        for attribute in cach {
            if attribute.frame.intersects(rect) {
                visibleLayoutAttributes.append(attribute)
            }
        }

        return visibleLayoutAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cach[indexPath.row]
    }

}
