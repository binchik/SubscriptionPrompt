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
    public var restoreButtonTitle: String? {
        didSet {
            dispatch_async(dispatch_get_main_queue()) {
                self.restorePurchasesButton.setTitle(self.restoreButtonTitle, forState: .Normal)
            }
        }
    }
    public var options: [Option] {
        didSet { subscribeView.options = options }
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
    
    public init(title: String? = nil, slides: [Slide], options: [Option],
                cancelMessage: String? = nil, restoreButtonTitle: String? = nil) {
        self.options = options
        self.restoreButtonTitle = restoreButtonTitle
        subscribeView = SubscribeView(title: title, slides: slides,
                                      options: options, cancelMessage: cancelMessage)
        super.init(nibName: nil, bundle: nil)
        
        subscribeView.delegate = self
        
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
        
        var restorePurchasesButtonOptional: UIButton? = restoreButtonTitle != nil ? restorePurchasesButton : nil
        
        ([subscribeView, restorePurchasesButtonOptional] as [UIView?])
            .flatMap { $0 }
            .forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                self.view.addSubview($0)
        }
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
                relatedBy: .Equal, toItem: view, attribute: .Top,
                multiplier: 1, constant: 40),
            NSLayoutConstraint(item: subscribeView, attribute: .Leading,
                relatedBy: .Equal, toItem: view, attribute: .Leading,
                multiplier: 1, constant: 20),
            NSLayoutConstraint(item: subscribeView, attribute: .Trailing,
                relatedBy: .Equal, toItem: view, attribute: .Trailing,
                multiplier: 1, constant: -20),
            
            NSLayoutConstraint(item: restorePurchasesButton, attribute: .Top,
                relatedBy: .Equal, toItem: subscribeView, attribute: .Bottom,
                multiplier: 1, constant: 20),
            NSLayoutConstraint(item: restorePurchasesButton, attribute: .Leading,
                relatedBy: .Equal, toItem: view, attribute: .Leading,
                multiplier: 1, constant: 8),
            NSLayoutConstraint(item: restorePurchasesButton, attribute: .Trailing,
                relatedBy: .Equal, toItem: view, attribute: .Trailing,
                multiplier: 1, constant: -8),
            NSLayoutConstraint(item: restorePurchasesButton, attribute: .Bottom,
                relatedBy: .Equal, toItem: view, attribute: .Bottom,
                multiplier: 1, constant: -10)
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
