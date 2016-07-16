//
//  SubscribeView.swift
//  SubscriptionPrompt
//
//  Created by Binur Konarbayev on 4/28/16.
//  Copyright © 2016 binchik. All rights reserved.
//

import UIKit

private let collectionViewCellIdentifier = "SlideCollectionViewCell"
private let tableViewCellIdentifier = "OptionTableViewCell"

private let notNowButtonDefaultStyle = OptionStyle(
    backgroundColor: UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1),
    textFont: nil, textColor: nil, accessoryType: nil)

protocol SubscribeViewDelegate {
    func dismissButtonTouched()
    func rowTapped(atIndex index: Int)
}

extension SubscribeViewDelegate where Self: UIViewController {
    func dismissButtonTouched() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

final class SubscribeView: UIView {
    var delegate: SubscribeViewDelegate?
    var stylingDelegate: SubscriptionViewControllerStylingDelegate?
    var title: String? {
        didSet {
            dispatch_async(dispatch_get_main_queue()) {
                self.titleLabel.text = self.title
            }
        }
    }
    var slides: [Slide]? {
        didSet {
            dispatch_async(dispatch_get_main_queue()) {
                self.collectionView.reloadData()
            }
        }
    }
    var options: [Option]? {
        didSet { reloadTableView() }
    }
    var cancelMessage: String? {
        didSet { reloadTableView() }
    }
    
    var titleFont: UIFont? {
        didSet {
            guard let titleFont = titleFont else { return }
            dispatch_async(dispatch_get_main_queue()) {
                self.titleLabel.font = titleFont
            }
        }
    }
    var titleColor: UIColor? {
        didSet {
            guard let titleColor = titleColor else { return }
            dispatch_async(dispatch_get_main_queue()) {
                self.titleLabel.textColor = titleColor
            }
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFontOfSize(24)
        label.textAlignment = .Center
        return label
    }()
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .Horizontal
        return layout
    }()
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.pagingEnabled = true
        collectionView.backgroundColor = .whiteColor()
        collectionView.registerClass(SlideCollectionViewCell.self, forCellWithReuseIdentifier: collectionViewCellIdentifier)
        return collectionView
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 55
        tableView.scrollEnabled = false
        tableView.separatorStyle = .None
        tableView.separatorColor = .whiteColor()
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.layoutMargins = UIEdgeInsetsZero
        tableView.registerClass(OptionTableViewCell.self, forCellReuseIdentifier: tableViewCellIdentifier)
        tableView.tableFooterView = UIView(frame: .zero)
        return tableView
    }()
    
    private var tableViewHeightConstraint: NSLayoutConstraint?
    private var notNowButtonHidden: Bool {
        return cancelMessage == nil
    }
    private var notNowButtonStyle: OptionStyle {
        return stylingDelegate?.subscriptionViewControllerNotNowButtonStyle?() ?? notNowButtonDefaultStyle
    }
    
    // MARK: - Init
    
    convenience init(title: String?, slides: [Slide], options: [Option], cancelMessage: String?) {
        self.init(frame: .zero)
        self.title = title
        self.slides = slides
        self.options = options
        self.cancelMessage = cancelMessage
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    // MARK: - Public
    
    func animateDraggingToTheRight(duration: NSTimeInterval = 2) {
        UIView.animateWithDuration(duration / 2, delay: 0, options: .AllowUserInteraction, animations: {
            self.collectionView.contentOffset = CGPoint(x: 120, y: 0)
            self.layoutIfNeeded()
        }) {
            if !$0 { return }
            UIView.animateWithDuration(duration / 2, delay: 0, options: .AllowUserInteraction, animations: {
                self.collectionView.contentOffset = CGPoint(x: 0, y: 0)
                self.layoutIfNeeded()
                }, completion: nil)
        }
    }
    
    // MARK: - Private
    
    private func setUp() {
        setUpViews()
        setUpConstraints()
        
        reloadTableView()
        collectionView.reloadData()
        titleLabel.text = title
    }
    
    private func setUpViews() {
        backgroundColor = .whiteColor()
        layer.masksToBounds = true
        layer.cornerRadius = 10
        
        [titleLabel, collectionView, tableView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
    }
    
    private func setUpConstraints() {
        tableViewHeightConstraint = NSLayoutConstraint(item: tableView, attribute: .Height,
                                                       relatedBy: .Equal, toItem: nil,
                                                       attribute: .NotAnAttribute, multiplier: 1,
                                                       constant: tableView.contentSize.height)
        
        [
            NSLayoutConstraint(item: titleLabel, attribute: .Top,
                relatedBy: .Equal, toItem: self, attribute: .Top,
                multiplier: 1, constant: 16),
            NSLayoutConstraint(item: titleLabel, attribute: .Leading,
                relatedBy: .Equal, toItem: self, attribute: .Leading,
                multiplier: 1, constant: 0),
            NSLayoutConstraint(item: titleLabel, attribute: .Trailing,
                relatedBy: .Equal, toItem: self, attribute: .Trailing,
                multiplier: 1, constant: 0),
            
            NSLayoutConstraint(item: collectionView, attribute: .Top,
                relatedBy: .Equal, toItem: titleLabel, attribute: .Bottom,
                multiplier: 1, constant: 0),
            NSLayoutConstraint(item: collectionView, attribute: .Leading,
                relatedBy: .Equal, toItem: self, attribute: .Leading,
                multiplier: 1, constant: 0),
            NSLayoutConstraint(item: collectionView, attribute: .Trailing,
                relatedBy: .Equal, toItem: self, attribute: .Trailing,
                multiplier: 1, constant: 0),
            
            NSLayoutConstraint(item: tableView, attribute: .Top,
                relatedBy: .Equal, toItem: collectionView, attribute: .Bottom,
                multiplier: 1, constant: 0),
            NSLayoutConstraint(item: tableView, attribute: .Leading,
                relatedBy: .Equal, toItem: self, attribute: .Leading,
                multiplier: 1, constant: 0),
            NSLayoutConstraint(item: tableView, attribute: .Trailing,
                relatedBy: .Equal, toItem: self, attribute: .Trailing,
                multiplier: 1, constant: 0),
            NSLayoutConstraint(item: tableView, attribute: .Bottom,
                relatedBy: .Equal, toItem: self, attribute: .Bottom,
                multiplier: 1, constant: 0),
            
            tableViewHeightConstraint
            ].flatMap{ $0 }.forEach { $0.active = true }
    }
    
    private func reloadTableView() {
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
            self.tableViewHeightConstraint?.constant = self.tableView.contentSize.height
        }
    }
    
    // MARK: - UIView
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout.itemSize = CGSize(width: collectionView.bounds.width,
                                 height: collectionView.bounds.height)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension SubscribeView: UITableViewDataSource, UITableViewDelegate {
    private func optionStyle(atIndex index: Int) -> OptionStyle {
        return stylingDelegate?.subscriptionViewControllerOptionStyle?(atIndex: index)
            ?? OptionStyle(backgroundColor: UIColor.orangeColor().colorWithAlphaComponent(CGFloat(1 / (Double(index) + 0.75))),
                           textFont: .systemFontOfSize(17), textColor: .whiteColor(), accessoryType: .Checkmark)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (options?.count ?? 0) + (notNowButtonHidden ? 0 : 1)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell,
                   forRowAtIndexPath indexPath: NSIndexPath) {
        cell.separatorInset = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsetsZero
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(tableViewCellIdentifier) as! OptionTableViewCell
        let row = indexPath.row
        let isNotNowButtonRow = !notNowButtonHidden && row == (options?.count ?? 0)
        
        if isNotNowButtonRow {
            cell.setUp(withOptionStyle: notNowButtonStyle)
            cell.textLabel?.text = cancelMessage
            return cell
        }
        
        cell.setUp(withOptionStyle: optionStyle(atIndex: row))
        
        if let option = options?[row] {
            cell.setUp(withOption: option)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView .deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.row < options?.count {
            delegate?.rowTapped(atIndex: indexPath.row)
        } else {
            if !notNowButtonHidden { delegate?.dismissButtonTouched() }
        }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension SubscribeView: UICollectionViewDataSource, UICollectionViewDelegate {
    private func slideStyle(atIndex index: Int) -> SlideStyle {
        return stylingDelegate?.subscriptionViewControllerSlideStyle?(atIndex: index) ??
            SlideStyle(backgroundColor: nil, titleFont: .systemFontOfSize(16),
                       subtitleFont: .systemFontOfSize(16), titleColor: nil,
                       subtitleColor: .lightGrayColor())
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            collectionViewCellIdentifier, forIndexPath: indexPath) as! SlideCollectionViewCell
        
        cell.setUp(withSlideStyle: slideStyle(atIndex: indexPath.row))
        if let slide = slides?[indexPath.row] {
            cell.setUp(withSlide: slide)
        }
        
        return cell
    }
}
