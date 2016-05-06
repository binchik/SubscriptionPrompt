//
//  SubscribeView.swift
//  KanjiNinja
//
//  Created by Zhanserik on 4/28/16.
//  Copyright © 2016 Tom. All rights reserved.
//

import UIKit
import SnapKit

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
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: tableViewCellIdentifier)
        return tableView
    }()
    
    private var constraintsSetUp = false
    
    // MARK: - Init
    
    convenience init(title: String, images: [UIImage], commentTexts: [String], commentSubtitleTexts: [String],
                     subscribeOptionsTexts: [String], cancelOptionText: String) {
        self.init(frame: .zero)
        self.title = title
        self.titleLabel.text = title
        self.images = images
        self.commentTexts = commentTexts
        self.commentSubtitleTexts = commentSubtitleTexts
        self.subscribeOptionsTexts = subscribeOptionsTexts
        self.cancelOptionText = cancelOptionText
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    // MARK: - Public
    
    func animateDraggingToTheRight(duration: NSTimeInterval = 2) {
        UIView.animateWithDuration(duration / 2, animations: {
            self.collectionView.contentOffset = CGPoint(x: 120, y: 0)
            self.layoutIfNeeded()
        }) {
            if !$0 { return }
            UIView.animateWithDuration(duration / 2) {
                self.collectionView.contentOffset = CGPoint(x: 0, y: 0)
                self.layoutIfNeeded()
            }
        }
    }
    
    // MARK: - Private
    
    private func setupViews() {
        backgroundColor = .whiteColor()
        layer.masksToBounds = true
        layer.cornerRadius = 10
        
        [titleLabel, collectionView, tableView].forEach { self.addSubview($0) }
        collectionView.reloadData()
        tableView.reloadData()
        setNeedsUpdateConstraints()
    }
    
    private func reloadTableView() {
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
            self.tableView.snp_updateConstraints {
                $0.height.equalTo(self.tableView.contentSize.height)
            }
        }
    }
    
    // MARK: - UIView
    
    override func updateConstraints() {
        super.updateConstraints()
        
        if constraintsSetUp { return }
        constraintsSetUp = true
        
        titleLabel.snp_makeConstraints {
            $0.left.equalTo(snp_left)
            $0.right.equalTo(snp_right)
            $0.top.equalTo(snp_top).offset(16)
        }
        collectionView.snp_makeConstraints {
            $0.left.equalTo(snp_left)
            $0.right.equalTo(snp_right)
            $0.top.equalTo(titleLabel.snp_bottom)
        }
        tableView.snp_makeConstraints {
            $0.left.equalTo(snp_left)
            $0.right.equalTo(snp_right)
            $0.top.equalTo(collectionView.snp_bottom)
            $0.bottom.equalTo(snp_bottom)
            $0.height.equalTo(tableView.contentSize.height)
        }
    }
    
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(tableViewCellIdentifier)!
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .orangeColor()
        cell.selectedBackgroundView = backgroundView
        
        cell.textLabel?.font = .systemFontOfSize(17)
        cell.textLabel?.textColor = .whiteColor()
        cell.textLabel?.textAlignment = .Center
        
        if indexPath.row == 0 {
            cell.contentView.backgroundColor = .orangeColor()
        } else if !notNowButtonHidden && indexPath.row == subscribeOptionsTexts.count {
            UIColor.lightTextColor()
            cell.contentView.backgroundColor = UIColor(red: 230, green: 230, blue: 230, alpha: 1)
            cell.textLabel?.textColor = .darkTextColor()
        } else {
            cell.contentView.backgroundColor = UIColor.orangeColor().colorWithAlphaComponent(0.7)
        }
        
        cell.textLabel?.text = indexPath.row < subscribeOptionsTexts.count ?
            subscribeOptionsTexts[indexPath.row] : cancelOptionText
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let delegate = delegate else { return }
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
