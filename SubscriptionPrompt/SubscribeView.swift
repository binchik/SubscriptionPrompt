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
    private var notNowButtonHidden: Bool {
        return cancelMessage == nil
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
    }
    
    private func setUpViews() {
        backgroundColor = .whiteColor()
        layer.masksToBounds = true
        layer.cornerRadius = 10
        
        [titleLabel, collectionView, tableView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        collectionView.reloadData()
        
        titleLabel.text = title
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
            NSLayoutConstraint(item: titleLabel, attribute: .Trailing,
                relatedBy: .Equal, toItem: self,
                attribute: .Trailing, multiplier: 1,
                constant: 0),
            
            NSLayoutConstraint(item: collectionView, attribute: .Top,
                relatedBy: .Equal, toItem: titleLabel,
                attribute: .Bottom, multiplier: 1,
                constant: 0),
            NSLayoutConstraint(item: collectionView, attribute: .Leading,
                relatedBy: .Equal, toItem: self,
                attribute: .Leading, multiplier: 1,
                constant: 0),
            NSLayoutConstraint(item: collectionView, attribute: .Trailing,
                relatedBy: .Equal, toItem: self,
                attribute: .Trailing, multiplier: 1,
                constant: 0),
            
            NSLayoutConstraint(item: tableView, attribute: .Top,
                relatedBy: .Equal, toItem: collectionView,
                attribute: .Bottom, multiplier: 1,
                constant: 0),
            NSLayoutConstraint(item: tableView, attribute: .Leading,
                relatedBy: .Equal, toItem: self,
                attribute: .Leading, multiplier: 1,
                constant: 0),
            NSLayoutConstraint(item: tableView, attribute: .Trailing,
                relatedBy: .Equal, toItem: self,
                attribute: .Trailing, multiplier: 1,
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
            self.tableView.setNeedsUpdateConstraints()
            self.layoutIfNeeded()
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
        return (options?.count ?? 0) + (notNowButtonHidden ? 0 : 1)
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
        } else if !notNowButtonHidden && indexPath.row == (options?.count ?? 0) {
            cell.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
            cell.textLabel?.textColor = UIColor(red: 125/255, green: 125/255, blue: 125/255, alpha: 1)
            cell.textLabel?.text = cancelMessage
        } else {
            cell.backgroundColor = UIColor.orangeColor().colorWithAlphaComponent(0.7)
        }
        
        if indexPath.row >= (options?.count ?? 0) { return cell }
        
        if let option = options?[indexPath.row] {
            if option.checked { cell.accessoryType = .Checkmark }
            cell.textLabel?.text = option.title
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let delegate = delegate else { return }
        tableView .deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.row < options?.count {
            delegate.rowTapped(atIndex: indexPath.row)
        } else {
            if !notNowButtonHidden { delegate.dismissButtonTouched() }
        }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension SubscribeView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            collectionViewCellIdentifier, forIndexPath: indexPath) as! SubscribeCollectionViewCell
        
        if let slide = slides?[indexPath.row] {
            cell.imageView.image = slide.image
            cell.commentLabel.text = slide.title
            cell.commentSubtitleLabel.text = slide.subtitle
        }
        
        return cell
    }
}
