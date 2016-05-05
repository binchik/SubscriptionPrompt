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
    func restoreButtonTapped()
}

public class SubscriptionViewController: UIViewController, SubscribeViewDelegate {
    public var delegate: SubscriptionViewControllerDelegate?
    public var notNowButtonHidden = false {
        didSet { subscribeView.notNowButtonHidden = notNowButtonHidden }
    }
    
    private var subscribeView: SubscribeView
    private lazy var restorePurchasesButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFontOfSize(18)
        button.addTarget(self, action: #selector(restoreButtonTapped),
                         forControlEvents: .TouchUpInside)
        return button
    }()
    private var constraintsSetUp = false
    
    // MARK: - Init
    
    public init(title: String, images: [UIImage], commentTexts: [String], commentSubtitleTexts: [String],
                subscribeOptionsTexts: [String], cancelOptionText: String, restoreButtonTitle: String) {
        subscribeView = SubscribeView(title: title, images: images,
                                      commentTexts: commentTexts,
                                      commentSubtitleTexts: commentSubtitleTexts,
                                      subscribeOptionsTexts: subscribeOptionsTexts,
                                      cancelOptionText: cancelOptionText)
        super.init(nibName: nil, bundle: nil)
        
        subscribeView.delegate = self
        restorePurchasesButton.setTitle(restoreButtonTitle, forState: .Normal)
        
        definesPresentationContext = true
        providesPresentationContextTransitionStyle = true
        modalPresentationStyle = .OverCurrentContext
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View LifeCycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        [subscribeView, restorePurchasesButton].forEach { self.view.addSubview($0) }
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
        }
        restorePurchasesButton.snp_makeConstraints {
            $0.left.equalTo(view.snp_left).offset(8)
            $0.right.equalTo(view.snp_right).offset(-8)
            $0.top.equalTo(subscribeView.snp_bottom).offset(20)
            $0.bottom.equalTo(view.snp_bottom).offset(-10)
        }
    }
    
    // MARK: - Public
    
    public func animateDraggingToTheRight(duration: NSTimeInterval = 2) {
        subscribeView.animateDraggingToTheRight(duration)
    }
    
    // MARK: - Private
    
    func restoreButtonTapped() {
        guard let delegate = delegate else { return }
        delegate.restoreButtonTapped()
    }
    
    // MARK: - SubscriptionViewDelegate
    
    func rowTapped(atIndex index: Int) {
        guard let delegate = delegate else { return }
        delegate.subscriptionViewControllerRowTapped(atIndex: index)
    }
}
