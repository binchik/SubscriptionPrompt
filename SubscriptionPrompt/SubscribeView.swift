//
//  SubscribeView.swift
//  SubscriptionPrompt
//
//  Created by Binur Konarbayev on 4/28/16.
//  Copyright © 2016 binchik. All rights reserved.
//

import UIKit

private let collectionViewCellIdentifier = "collectionViewCellIdentifier"
private let tableViewCellIdentifier = "identifier"

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
    var notNowButtonHidden = false {
        didSet { self.reloadTableView() }
    }
    
    var title = "Get [App Name] Plus" {
        didSet {
            dispatch_async(dispatch_get_main_queue()) {
                self.titleLabel.text = self.title
            }
        }
    }
    var subscribeOptionsTexts = ["12 MONTHS FOR $4.58/mo", "6 MONTHS FOR $5.83/mo", "1 MONTH FOR $9.99/mo"] {
        didSet { reloadTableView() }
    }
    var cancelOptionText = "CANCEL" {
        didSet { reloadTableView() }
    }
    var images = [UIImage]() {
        didSet {
            dispatch_async(dispatch_get_main_queue()) {
                self.collectionView.reloadData()
            }
        }
    }
    var commentTexts = [String]() {
        didSet {
            dispatch_async(dispatch_get_main_queue()) {
                self.collectionView.reloadData()
            }
        }
    }
    var commentSubtitleTexts = [String]() {
        didSet {
            dispatch_async(dispatch_get_main_queue()) {
                self.collectionView.reloadData()
            }
        }
    }
    var checked = [Bool]() {
        didSet {
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
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
        collectionView.bounces = true
        collectionView.pagingEnabled = true
        collectionView.backgroundColor = .whiteColor()
        collectionView.registerClass(SubscribeCollectionViewCell.self, forCellWithReuseIdentifier: collectionViewCellIdentifier)
        return collectionView
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 55
        tableView.scrollEnabled = false
        tableView.separatorColor = .whiteColor()
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.layoutMargins = UIEdgeInsetsZero
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: tableViewCellIdentifier)
        tableView.tableFooterView = UIView(frame: .zero)
        return tableView
    }()
    
    private var tableViewHeightConstraint: NSLayoutConstraint?
    
    // MARK: - Init
    
    convenience init(title: String, images: [UIImage], commentTexts: [String], commentSubtitleTexts: [String],
                     subscribeOptionsTexts: [String], cancelOptionText: String, checked: [Bool]) {
        self.init(frame: .zero)
        self.title = title
        self.titleLabel.text = title
        self.images = images
        self.commentTexts = commentTexts
        self.commentSubtitleTexts = commentSubtitleTexts
        self.subscribeOptionsTexts = subscribeOptionsTexts
        self.cancelOptionText = cancelOptionText
        self.checked = checked
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        setUpConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpViews()
        setUpConstraints()
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
    
    private func setUpViews() {
        backgroundColor = .whiteColor()
        layer.masksToBounds = true
        layer.cornerRadius = 10
        
        [titleLabel, collectionView, tableView].forEach { self.addSubview($0) }
        collectionView.reloadData()
        tableView.reloadData()
        setNeedsUpdateConstraints()
    }
    
    private func setUpConstraints() {
        tableViewHeightConstraint = NSLayoutConstraint(item: tableView, attribute: .Height,
                                                       relatedBy: .Equal, toItem: nil,
                                                       attribute: .NotAnAttribute, multiplier: 1,
                                                       constant: tableView.contentSize.height)
        
        [
            NSLayoutConstraint(item: titleLabel, attribute: .Top,
                relatedBy: .Equal, toItem: self,
                attribute: .Top, multiplier: 1,
                constant: 16),
            NSLayoutConstraint(item: titleLabel, attribute: .Leading,
                relatedBy: .Equal, toItem: self,
                attribute: .Leading, multiplier: 1,
                constant: 0),
            NSLayoutConstraint(item: titleLabel, attribute: .Top,
                relatedBy: .Equal, toItem: self,
                attribute: .Leading, multiplier: 1,
                constant: 0),
            
            NSLayoutConstraint(item: collectionView, attribute: .Top,
                relatedBy: .Equal, toItem: titleLabel,
                attribute: .Bottom, multiplier: 1,
                constant: 0),
            NSLayoutConstraint(item: collectionView, attribute: .Leading,
                relatedBy: .Equal, toItem: self,
                attribute: .Leading, multiplier: 1,
                constant: 0),
            NSLayoutConstraint(item: collectionView, attribute: .Top,
                relatedBy: .Equal, toItem: self,
                attribute: .Leading, multiplier: 1,
                constant: 0),
            
            NSLayoutConstraint(item: tableView, attribute: .Top,
                relatedBy: .Equal, toItem: collectionView,
                attribute: .Bottom, multiplier: 1,
                constant: 0),
            NSLayoutConstraint(item: tableView, attribute: .Leading,
                relatedBy: .Equal, toItem: self,
                attribute: .Leading, multiplier: 1,
                constant: 0),
            NSLayoutConstraint(item: tableView, attribute: .Top,
                relatedBy: .Equal, toItem: self,
                attribute: .Leading, multiplier: 1,
                constant: 0),
            NSLayoutConstraint(item: tableView, attribute: .Bottom,
                relatedBy: .Equal, toItem: self,
                attribute: .Bottom, multiplier: 1,
                constant: 0),
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
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subscribeOptionsTexts.count + (notNowButtonHidden ? 0 : 1)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell,
                   forRowAtIndexPath indexPath: NSIndexPath) {
        cell.separatorInset = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsetsZero
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(tableViewCellIdentifier)!
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .orangeColor()
        cell.selectedBackgroundView = backgroundView
        
        cell.textLabel?.font = .systemFontOfSize(17)
        cell.textLabel?.textColor = .whiteColor()
        cell.textLabel?.textAlignment = .Center
        
        if indexPath.row == 0 {
            cell.backgroundColor = .orangeColor()
        } else if !notNowButtonHidden && indexPath.row == subscribeOptionsTexts.count {
            cell.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
            cell.textLabel?.textColor = UIColor(red: 125/255, green: 125/255, blue: 125/255, alpha: 1)
        } else {
            cell.backgroundColor = UIColor.orangeColor().colorWithAlphaComponent(0.7)
        }
        
        if indexPath.row < checked.count && checked[indexPath.row] {
            cell.accessoryType = .Checkmark
        }
        
        cell.textLabel?.text = indexPath.row < subscribeOptionsTexts.count ?
            subscribeOptionsTexts[indexPath.row] : cancelOptionText
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let delegate = delegate else { return }
        tableView .deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.row < subscribeOptionsTexts.count {
            delegate.rowTapped(atIndex: indexPath.row)
        } else {
            if !notNowButtonHidden { delegate.dismissButtonTouched() }
        }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension SubscribeView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            collectionViewCellIdentifier, forIndexPath: indexPath) as! SubscribeCollectionViewCell
        cell.imageView.image = images[indexPath.row]
        cell.commentLabel.text = commentTexts[indexPath.row]
        cell.commentSubtitleLabel.text = commentSubtitleTexts[indexPath.row]
        return cell
    }
}
