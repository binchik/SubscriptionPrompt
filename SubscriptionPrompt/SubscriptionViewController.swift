//
//  SubscribeViewController.swift
//  SubscriptionPrompt
//
//  Created by Binur Konarbayev on 5/3/16.
//  Copyright © 2016 binchik. All rights reserved.
//

import UIKit

public protocol SubscriptionViewControllerDelegate {
    func subscriptionViewControllerRowTapped(atIndex index: Int)
    func restoreButtonTapped()
}

@objc public protocol SubscriptionViewControllerStylingDelegate {
    @objc optional func subscriptionViewControllerSlideStyle(atIndex index: Int) -> SlideStyle
    @objc optional func subscriptionViewControllerOptionStyle(atIndex index: Int) -> OptionStyle
    @objc optional func subscriptionViewControllerNotNowButtonStyle() -> OptionStyle
}

public final class SubscriptionViewController: UIViewController, SubscribeViewDelegate {
    // MARK: - Styling
    
    public var dimColor: UIColor = UIColor(white: 0, alpha: 0.5) {
        didSet {
            DispatchQueue.main.async {
                self.view.backgroundColor = self.dimColor
            }
        }
    }
    
    public var dimView: UIView? {
        didSet {
            guard let dimView = dimView else { return }
            dimView.translatesAutoresizingMaskIntoConstraints = false
            DispatchQueue.main.async {
                oldValue?.removeFromSuperview()
                self.view.insertSubview(dimView, belowSubview: self.subscribeView)
                [
                    NSLayoutConstraint(item: dimView, attribute: .leading,
                        relatedBy: .equal, toItem: self.view, attribute: .leading,
                        multiplier: 1, constant: 0),
                    NSLayoutConstraint(item: dimView, attribute: .trailing,
                        relatedBy: .equal, toItem: self.view, attribute: .trailing,
                        multiplier: 1, constant: 0),
                    NSLayoutConstraint(item: dimView, attribute: .top,
                        relatedBy: .equal, toItem: self.view, attribute: .top,
                        multiplier: 1, constant: 0),
                    NSLayoutConstraint(item: dimView, attribute: .bottom,
                        relatedBy: .equal, toItem: self.view, attribute: .bottom,
                        multiplier: 1, constant: 0)
                    ].forEach { $0.isActive = true }
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
            DispatchQueue.main.async {
                self.restorePurchasesButton.setTitle(self.restoreButtonTitle, for: .normal)
            }
        }
    }
    public var options: [Option] {
        didSet { subscribeView.options = options }
    }
    
    private var subscribeView: SubscribeView
    private lazy var restorePurchasesButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.addTarget(self, action: #selector(restoreButtonTapped), for: .touchUpInside)
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
        modalPresentationStyle = .overCurrentContext
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View LifeCycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        let restorePurchasesButtonOptional: UIButton? = restoreButtonTitle != nil ? restorePurchasesButton : nil
        
        ([subscribeView, restorePurchasesButtonOptional] as [UIView?])
            .flatMap { $0 }
            .forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                self.view.addSubview($0)
        }
        setUpConstraints()
    }
    
    // MARK: - Public
    
    public func animateDraggingToTheRight(duration: TimeInterval = 2) {
        subscribeView.animateDraggingToTheRight(duration: duration)
    }
    
    // MARK: - Private
    
    private func setUpConstraints() {
        [
            NSLayoutConstraint(item: subscribeView, attribute: .top,
                relatedBy: .equal, toItem: view, attribute: .top,
                multiplier: 1, constant: 40),
            NSLayoutConstraint(item: subscribeView, attribute: .leading,
                relatedBy: .equal, toItem: view, attribute: .leading,
                multiplier: 1, constant: 20),
            NSLayoutConstraint(item: subscribeView, attribute: .trailing,
                relatedBy: .equal, toItem: view, attribute: .trailing,
                multiplier: 1, constant: -20),
            NSLayoutConstraint(item: restorePurchasesButton, attribute: .top,
                relatedBy: .equal, toItem: subscribeView, attribute: .bottom,
                multiplier: 1, constant: 20),
            NSLayoutConstraint(item: restorePurchasesButton, attribute: .leading,
                relatedBy: .equal, toItem: view, attribute: .leading,
                multiplier: 1, constant: 8),
            NSLayoutConstraint(item: restorePurchasesButton, attribute: .trailing,
                relatedBy: .equal, toItem: view, attribute: .trailing,
                multiplier: 1, constant: -8),
            NSLayoutConstraint(item: restorePurchasesButton, attribute: .bottom,
                relatedBy: .equal, toItem: view, attribute: .bottom,
                multiplier: 1, constant: -10)
            ].forEach { $0.isActive = true }
    }
    
    @objc public func restoreButtonTapped() {
        delegate?.restoreButtonTapped()
    }
    
    // MARK: - SubscriptionViewDelegate
    
    public func rowTapped(atIndex index: Int) {
        delegate?.subscriptionViewControllerRowTapped(atIndex: index)
    }
}
