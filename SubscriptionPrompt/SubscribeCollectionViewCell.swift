//
//  SubscribeCollectionViewCell.swift
//  SubscriptionPrompt
//
//  Created by Binur Konarbayev on 4/29/16.
//  Copyright © 2016 binchik. All rights reserved.
//

import UIKit

final class SubscribeCollectionViewCell: UICollectionViewCell {
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Comment"
        label.textAlignment = .Center
        label.font = .systemFontOfSize(16)
        label.setContentCompressionResistancePriority(1000, forAxis: .Vertical)
        return label
    }()
    lazy var commentSubtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Comment subtitle"
        label.textAlignment = .Center
        label.textColor = .lightGrayColor()
        label.font = .systemFontOfSize(16)
        label.setContentCompressionResistancePriority(1000, forAxis: .Vertical)
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        setUpConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpViews()
        setUpConstraints()
    }
    
    // MARK: - Private
    
    private func setUpViews() {
        backgroundColor = .whiteColor()
        contentView.backgroundColor = .whiteColor()
        [imageView, commentLabel, commentSubtitleLabel]
            .forEach { self.contentView.addSubview($0) }
    }
    
    private func setUpConstraints() {
        [
            NSLayoutConstraint(item: imageView, attribute: .Top,
                relatedBy: .Equal, toItem: contentView,
                attribute: .Top, multiplier: 1,
                constant: 0),
            NSLayoutConstraint(item: imageView, attribute: .Leading,
                relatedBy: .Equal, toItem: contentView,
                attribute: .Leading, multiplier: 1,
                constant: 0),
            NSLayoutConstraint(item: imageView, attribute: .Trailing,
                relatedBy: .Equal, toItem: contentView,
                attribute: .Trailing, multiplier: 1,
                constant: 0),
            
            NSLayoutConstraint(item: commentLabel, attribute: .Top,
                relatedBy: .Equal, toItem: imageView,
                attribute: .Bottom, multiplier: 1,
                constant: 4),
            NSLayoutConstraint(item: commentLabel, attribute: .Leading,
                relatedBy: .Equal, toItem: contentView,
                attribute: .Leading, multiplier: 1,
                constant: 4),
            NSLayoutConstraint(item: commentLabel, attribute: .Trailing,
                relatedBy: .Equal, toItem: contentView,
                attribute: .Trailing, multiplier: 1,
                constant: -4),
            
            NSLayoutConstraint(item: commentSubtitleLabel, attribute: .Top,
                relatedBy: .Equal, toItem: commentLabel,
                attribute: .Bottom, multiplier: 1,
                constant: 4),
            NSLayoutConstraint(item: commentSubtitleLabel, attribute: .Leading,
                relatedBy: .Equal, toItem: contentView,
                attribute: .Leading, multiplier: 1,
                constant: 4),
            NSLayoutConstraint(item: commentSubtitleLabel, attribute: .Trailing,
                relatedBy: .Equal, toItem: contentView,
                attribute: .Trailing, multiplier: 1,
                constant: -4),
            NSLayoutConstraint(item: commentSubtitleLabel, attribute: .Bottom,
                relatedBy: .Equal, toItem: contentView,
                attribute: .Bottom, multiplier: 1,
                constant: -4)
        ].forEach { $0.active = true }
    }
}
