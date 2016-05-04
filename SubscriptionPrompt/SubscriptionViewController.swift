//
//  SubscribeViewController.swift
//  KanjiNinja
//
//  Created by Zhanserik on 4/28/16.
//  Copyright © 2016 Tom. All rights reserved.
//

import UIKit
import SnapKit

@objc public protocol SubscriptionViewControllerDelegate {
    func subscriptionViewControllerRowTapped(atIndex index: Int)
}

public class SubscriptionViewController: UIViewController, SubscribeViewDelegate {
    var delegate: SubscriptionViewControllerDelegate?
    
    private var subscribeView: SubscribeView
    private var constraintsSetUp = false
    
    // MARK: - Init
    
    public init(title: String, images: [UIImage], commentTexts: [String], commentSubtitleTexts: [String],
                     subscribeOptionsTexts: [String], cancelOptionText: String) {
        subscribeView = SubscribeView(title: title, images: images,
                                      commentTexts: commentTexts,
                                      commentSubtitleTexts: commentSubtitleTexts,
                                      subscribeOptionsTexts: subscribeOptionsTexts,
                                      cancelOptionText: cancelOptionText)
        super.init(nibName: nil, bundle: nil)
        subscribeView.delegate = self
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View LifeCycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        view.setNeedsUpdateConstraints()
    }
    
    // MARK: - UIView
    
    override public func updateViewConstraints() {
        super.updateViewConstraints()
        
        if constraintsSetUp { return }
        constraintsSetUp = true
        
        subscribeView.snp_makeConstraints {
            $0.left.equalTo(view.snp_left).offset(20)
            $0.right.equalTo(view.snp_right).offset(-20)
            $0.top.equalTo(view.snp_top).offset(40)
            $0.bottom.equalTo(view.snp_bottom).offset(-40)
        }
    }
    
    // MARK: - Public
    
    public func animateDraggingToTheRight(duration: NSTimeInterval = 2) {
        subscribeView.animateDraggingToTheRight(duration)
    }
    
    // MARK: - Private
    
    private func setupViews() {
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        view.addSubview(subscribeView)
    }
    
    func rowTapped(atIndex index: Int) {
        guard let delegate = delegate else { return }
        delegate.subscriptionViewControllerRowTapped(atIndex: index)
    }
}
