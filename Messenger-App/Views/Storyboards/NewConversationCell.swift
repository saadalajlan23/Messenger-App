//
//  NewConversationCell.swift
//  Messenger-App
//
//  Created by administrator on 07/11/2021.
//

import UIKit

class NewConversationCell: UITableViewCell {
    static let identifier = "NewConversationCell"

    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 35
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21, weight: .semibold)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(userImageView)
        contentView.addSubview(userNameLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        userNameLabel.frame = CGRect(x: 10,
                                     y: 10,
                                     width: 70,
                                     height: 70)

        
    }

    public func configure(with model: SearchResult) {
        userNameLabel.text = model.name

        let path = "images/\(model.email)_profile_picture.png"
        StorageManager.shared.downloadURL(for: path, completion: { [weak self] result in
           
        })
    }

}
