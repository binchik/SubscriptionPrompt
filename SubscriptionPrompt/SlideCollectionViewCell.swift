//
//  SlideCollectionViewCell.swift
//  SubscriptionPrompt
//
//  Created by Binur Konarbayev on 4/29/16.
//  Copyright © 2016 binchik. All rights reserved.
//

import UIKit

final class SlideCollectionViewCell: UICollectionViewCell {
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .Center
        label.setContentCompressionResistancePriority(1000, forAxis: .Vertical)
        return label
    }()
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .Center
        label.setContentCompressionResistancePriority(1000, forAxis: .Vertical)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    private func setUp() {
        setUpViews()
        setUpConstraints()
    }
    
    private func setUpViews() {
        [imageView, titleLabel, subtitleLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
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
            
            NSLayoutConstraint(item: titleLabel, attribute: .Top,
                relatedBy: .Equal, toItem: imageView,
                attribute: .Bottom, multiplier: 1,
                constant: 4),
            NSLayoutConstraint(item: titleLabel, attribute: .Leading,
                relatedBy: .Equal, toItem: contentView,
                attribute: .Leading, multiplier: 1,
                constant: 4),
            NSLayoutConstraint(item: titleLabel, attribute: .Trailing,
                relatedBy: .Equal, toItem: contentView,
                attribute: .Trailing, multiplier: 1,
                constant: -4),
            
            NSLayoutConstraint(item: subtitleLabel, attribute: .Top,
                relatedBy: .Equal, toItem: titleLabel,
                attribute: .Bottom, multiplier: 1,
                constant: 4),
            NSLayoutConstraint(item: subtitleLabel, attribute: .Leading,
                relatedBy: .Equal, toItem: contentView,
                attribute: .Leading, multiplier: 1,
                constant: 4),
            NSLayoutConstraint(item: subtitleLabel, attribute: .Trailing,
                relatedBy: .Equal, toItem: contentView,
                attribute: .Trailing, multiplier: 1,
                constant: -4),
            NSLayoutConstraint(item: subtitleLabel, attribute: .Bottom,
                relatedBy: .Equal, toItem: contentView,
                attribute: .Bottom, multiplier: 1,
                constant: -4)
            ].forEach { $0.active = true }
    }
}

extension SlideCollectionViewCell {
    func setUp(withSlide slide: Slide) {
        imageView.image = slide.image
        titleLabel.text = slide.title
        subtitleLabel.text = slide.subtitle
    }
    
    func setUp(withSlideStyle style: SlideStyle) {
        backgroundColor = style.backgroundColor
        titleLabel.font = style.titleFont
        subtitleLabel.font = style.subtitleFont
        titleLabel.textColor = style.titleColor
        subtitleLabel.textColor = style.titleColor
    }
}
