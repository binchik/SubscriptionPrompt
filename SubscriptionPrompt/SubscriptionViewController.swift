//
//  SubscribeViewController.swift
//  SubscriptionPrompt
//
//  Created by Binur Konarbayev on 5/3/16.
//  Copyright © 2016 binchik. All rights reserved.
//

import UIKit

@objc public protocol SubscriptionViewControllerDelegate {
    func subscriptionViewControllerRowTapped(atIndex index: Int)
    func restoreButtonTapped()
}

public class SubscriptionViewController: UIViewController, SubscribeViewDelegate {
    public var delegate: SubscriptionViewControllerDelegate?
    public var notNowButtonHidden = false {
        didSet { subscribeView.notNowButtonHidden = notNowButtonHidden }
    }
    public var checked: [Bool] {
        didSet { subscribeView.checked = checked }
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
                subscribeOptionsTexts: [String], cancelOptionText: String, restoreButtonTitle: String, checked: [Bool]) {
        self.checked = checked
        subscribeView = SubscribeView(title: title, images: images,
                                      commentTexts: commentTexts,
                                      commentSubtitleTexts: commentSubtitleTexts,
                                      subscribeOptionsTexts: subscribeOptionsTexts,
                                      cancelOptionText: cancelOptionText, checked: checked)
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
        setUpConstraints()
    }
    
    // MARK: - Public
    
    public func animateDraggingToTheRight(duration: NSTimeInterval = 2) {
        subscribeView.animateDraggingToTheRight(duration)
    }
    
    // MARK: - Private
    
    private func setUpConstraints() {
        [
            NSLayoutConstraint(item: subscribeView, attribute: .Top,
                           relatedBy: .Equal, toItem: view,
                           attribute: .Top, multiplier: 1,
                           constant: 40),
            NSLayoutConstraint(item: subscribeView, attribute: .Leading,
                               relatedBy: .Equal, toItem: view,
                               attribute: .Leading, multiplier: 1,
                               constant: 20),
            NSLayoutConstraint(item: subscribeView, attribute: .Trailing,
                               relatedBy: .Equal, toItem: view,
                               attribute: .Trailing, multiplier: 1,
                               constant: -20),
            
            NSLayoutConstraint(item: restorePurchasesButton, attribute: .Top,
                               relatedBy: .Equal, toItem: subscribeView,
                               attribute: .Bottom, multiplier: 1,
                               constant: 20),
            NSLayoutConstraint(item: restorePurchasesButton, attribute: .Leading,
                               relatedBy: .Equal, toItem: view,
                               attribute: .Leading, multiplier: 1,
                               constant: 8),
            NSLayoutConstraint(item: restorePurchasesButton, attribute: .Trailing,
                               relatedBy: .Equal, toItem: view,
                               attribute: .Trailing, multiplier: 1,
                               constant: -8),
            NSLayoutConstraint(item: restorePurchasesButton, attribute: .Bottom,
                               relatedBy: .Equal, toItem: view,
                               attribute: .Bottom, multiplier: 1,
            constant: -10)
        ].forEach { $0.active = true }
    }
    
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
