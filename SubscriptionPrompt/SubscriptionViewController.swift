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

@objc public protocol SubscriptionViewControllerStylingDelegate {
    optional func subscriptionViewControllerSlideStyle(atIndex index: Int) -> SlideStyle
    optional func subscriptionViewControllerOptionStyle(atIndex index: Int) -> OptionStyle
    optional func subscriptionViewControllerNotNowButtonStyle() -> OptionStyle
}

public final class SubscriptionViewController: UIViewController, SubscribeViewDelegate {
    // MARK: - Styling
    
    public var dimColor: UIColor = UIColor(white: 0, alpha: 0.5) {
        didSet {
            dispatch_async(dispatch_get_main_queue()) {
                self.view.backgroundColor = self.dimColor
            }
        }
    }
    
    public var dimView: UIView? {
        didSet {
            guard let dimView = dimView else { return }
            dimView.translatesAutoresizingMaskIntoConstraints = false
            dispatch_async(dispatch_get_main_queue()) {
                oldValue?.removeFromSuperview()
                self.view.insertSubview(dimView, belowSubview: self.subscribeView)
                [
                    NSLayoutConstraint(item: dimView, attribute: .Leading,
                        relatedBy: .Equal, toItem: self.view, attribute: .Leading,
                        multiplier: 1, constant: 0),
                    NSLayoutConstraint(item: dimView, attribute: .Trailing,
                        relatedBy: .Equal, toItem: self.view, attribute: .Trailing,
                        multiplier: 1, constant: 0),
                    NSLayoutConstraint(item: dimView, attribute: .Top,
                        relatedBy: .Equal, toItem: self.view, attribute: .Top,
                        multiplier: 1, constant: 0),
                    NSLayoutConstraint(item: dimView, attribute: .Bottom,
                        relatedBy: .Equal, toItem: self.view, attribute: .Bottom,
                        multiplier: 1, constant: 0)
                    ].forEach { $0.active = true }
            }
        }
    }
    
    public var titleFont: UIFont? {
        didSet { self.subscribeView.titleFont = titleFont }
    }
    public var titleColor: UIColor? {
        didSet { self.subscribeView.titleColor = titleColor }
    }
    
    // MARK: - Styling END
    
    public var delegate: SubscriptionViewControllerDelegate?
    public var stylingDelegate: SubscriptionViewControllerStylingDelegate? {
        didSet { self.subscribeView.stylingDelegate = stylingDelegate }
    }
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
        delegate?.restoreButtonTapped()
    }
    
    // MARK: - SubscriptionViewDelegate
    
    func rowTapped(atIndex index: Int) {
        delegate?.subscriptionViewControllerRowTapped(atIndex: index)
    }
}
