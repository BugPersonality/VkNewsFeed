//
//  FooterView.swift
//  VkNewsFeed
//
//  Created by Данил Дубов on 22.09.2021.
//

import UIKit

class FooterView: UIView {
    private var myLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = #colorLiteral(red: 0.4954584837, green: 0.5507804751, blue: 0.6053527594, alpha: 1)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.hidesWhenStopped = true
        return loader
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(myLabel)
        addSubview(loader)

        myLabel.anchor(top: topAnchor,
                       leading: leadingAnchor,
                       bottom: nil,
                       trailing: trailingAnchor,
                       padding: UIEdgeInsets(top: 8, left: 20, bottom: 0, right: 20))

        loader.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        loader.topAnchor.constraint(equalTo: myLabel.bottomAnchor, constant: 8).isActive = true
    }

    func showLoader() {
        loader.startAnimating()
    }

    func setTitle(_ title: String?) {
        loader.stopAnimating()
        myLabel.text = title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
