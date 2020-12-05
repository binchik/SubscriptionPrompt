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
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
    
        label.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: .vertical)
        return label
    }()
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: .vertical)
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
        let views: [UIView] = [imageView, titleLabel, subtitleLabel]
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
    }
    
    private func setUpConstraints() {
        [
            NSLayoutConstraint(item: imageView, attribute: .top,
                relatedBy: .equal, toItem: contentView,
                attribute: .top, multiplier: 1,
                constant: 0),
            NSLayoutConstraint(item: imageView, attribute: .leading,
                relatedBy: .equal, toItem: contentView,
                attribute: .leading, multiplier: 1,
                constant: 0),
            NSLayoutConstraint(item: imageView, attribute: .trailing,
                relatedBy: .equal, toItem: contentView,
                attribute: .trailing, multiplier: 1,
                constant: 0),
            
            NSLayoutConstraint(item: titleLabel, attribute: .top,
                relatedBy: .equal, toItem: imageView,
                attribute: .bottom, multiplier: 1,
                constant: 4),
            NSLayoutConstraint(item: titleLabel, attribute: .leading,
                relatedBy: .equal, toItem: contentView,
                attribute: .leading, multiplier: 1,
                constant: 4),
            NSLayoutConstraint(item: titleLabel, attribute: .trailing,
                relatedBy: .equal, toItem: contentView,
                attribute: .trailing, multiplier: 1,
                constant: -4),
            
            NSLayoutConstraint(item: subtitleLabel, attribute: .top,
                relatedBy: .equal, toItem: titleLabel,
                attribute: .bottom, multiplier: 1,
                constant: 4),
            NSLayoutConstraint(item: subtitleLabel, attribute: .leading,
                relatedBy: .equal, toItem: contentView,
                attribute: .leading, multiplier: 1,
                constant: 4),
            NSLayoutConstraint(item: subtitleLabel, attribute: .trailing,
                relatedBy: .equal, toItem: contentView,
                attribute: .trailing, multiplier: 1,
                constant: -4),
            NSLayoutConstraint(item: subtitleLabel, attribute: .bottom,
                relatedBy: .equal, toItem: contentView,
                attribute: .bottom, multiplier: 1,
                constant: -4)
            ].forEach { $0.isActive = true }
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
