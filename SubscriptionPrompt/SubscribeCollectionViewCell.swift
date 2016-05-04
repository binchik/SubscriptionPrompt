//
//  SubscribeCollectionViewCell.swift
//  kanjininja
//
//  Created by Zhanserik on 4/29/16.
//  Copyright © 2016 Tom. All rights reserved.
//

import UIKit
import SnapKit

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
    
    private var constraintsSetUp = false
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setNeedsUpdateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
        setNeedsUpdateConstraints()
    }
    
    // MARK: - Private
    
    private func setupViews() {
        backgroundColor = .whiteColor()
        contentView.backgroundColor = .whiteColor()
        [imageView, commentLabel, commentSubtitleLabel]
            .forEach { self.contentView.addSubview($0) }
    }
    
    // MARK: - UIView
    
    override func updateConstraints() {
        super.updateConstraints()
        
        if constraintsSetUp { return }
        constraintsSetUp = true
        
        imageView.snp_makeConstraints {
            $0.top.equalTo(contentView.snp_top)
            $0.left.equalTo(contentView.snp_left)
            $0.right.equalTo(contentView.snp_right)
        }
        commentLabel.snp_makeConstraints {
            $0.top.equalTo(imageView.snp_bottom)
            $0.left.equalTo(contentView.snp_left).offset(4)
            $0.right.equalTo(contentView.snp_right).offset(-4)
        }
        commentSubtitleLabel.snp_makeConstraints {
            $0.top.equalTo(commentLabel.snp_bottom).offset(4)
            $0.left.equalTo(contentView.snp_left).offset(4)
            $0.right.equalTo(contentView.snp_right).offset(-4)
            $0.bottom.equalTo(contentView.snp_bottom)
        }
    }
}
