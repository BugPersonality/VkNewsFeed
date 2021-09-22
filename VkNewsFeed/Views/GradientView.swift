//
//  GradientView.swift
//  VkNewsFeed
//
//  Created by Данил Дубов on 22.09.2021.
//

import UIKit

class GradientView: UIView {
    private let gradientlayer = CAGradientLayer()

    private var startColor: UIColor = .red
    private var endColor: UIColor = .yellow

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpGradient()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientlayer.frame = bounds
        gradientlayer.colors = [startColor.cgColor, endColor.cgColor]
    }

    private func setUpGradient() {
        self.layer.addSublayer(gradientlayer)
        gradientlayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientlayer.endPoint = CGPoint(x: 1.0, y: 0.5)
    }
}
