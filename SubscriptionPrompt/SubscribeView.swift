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
        dismiss(animated: true)
    }
}

final class SubscribeView: UIView {
    var delegate: SubscribeViewDelegate?
    var stylingDelegate: SubscriptionViewControllerStylingDelegate?
    var title: String? {
        didSet {
            DispatchQueue.main.async {
                self.titleLabel.text = self.title
            }
        }
    }
    var slides: [Slide]? {
        didSet {
            DispatchQueue.main.async {
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
            DispatchQueue.main.async {
                self.titleLabel.font = titleFont
            }
        }
    }
    var titleColor: UIColor? {
        didSet {
            guard let titleColor = titleColor else { return }
            DispatchQueue.main.async {
                self.titleLabel.textColor = titleColor
            }
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24)
        label.textAlignment = .center
        return label
    }()
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        return layout
    }()
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .white
        collectionView.register(SlideCollectionViewCell.self, forCellWithReuseIdentifier: collectionViewCellIdentifier)
        return collectionView
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 55
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.separatorColor = .white
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.register(OptionTableViewCell.self, forCellReuseIdentifier: tableViewCellIdentifier)
        tableView.tableFooterView = UIView(frame: .zero)
        return tableView
    }()
    
    private var tableViewHeightConstraint: NSLayoutConstraint?
    fileprivate var notNowButtonHidden: Bool {
        return cancelMessage == nil
    }
    fileprivate var notNowButtonStyle: OptionStyle {
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
    
    func animateDraggingToTheRight(duration: TimeInterval = 2) {
        UIView.animate(withDuration: duration / 2, delay: 0, options: .allowUserInteraction, animations: {
            self.collectionView.contentOffset = CGPoint(x: 120, y: 0)
            self.layoutIfNeeded()
        }) {
            if !$0 { return }
            UIView.animate(withDuration: duration / 2, delay: 0, options: .allowUserInteraction, animations: {
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
        backgroundColor = .white
        layer.masksToBounds = true
        layer.cornerRadius = 10
        let views: [UIView] = [titleLabel, collectionView, tableView]
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
    }
    
    private func setUpConstraints() {
        tableViewHeightConstraint = NSLayoutConstraint(item: tableView, attribute: .height,
                                                       relatedBy: .equal, toItem: nil,
                                                       attribute: .notAnAttribute, multiplier: 1,
                                                       constant: tableView.contentSize.height)
        
        [
            NSLayoutConstraint(item: titleLabel, attribute: .top,
                relatedBy: .equal, toItem: self, attribute: .top,
                multiplier: 1, constant: 16),
            NSLayoutConstraint(item: titleLabel, attribute: .leading,
                relatedBy: .equal, toItem: self, attribute: .leading,
                multiplier: 1, constant: 0),
            NSLayoutConstraint(item: titleLabel, attribute: .trailing,
                relatedBy: .equal, toItem: self, attribute: .trailing,
                multiplier: 1, constant: 0),
            
            NSLayoutConstraint(item: collectionView, attribute: .top,
                relatedBy: .equal, toItem: titleLabel, attribute: .bottom,
                multiplier: 1, constant: 0),
            NSLayoutConstraint(item: collectionView, attribute: .leading,
                relatedBy: .equal, toItem: self, attribute: .leading,
                multiplier: 1, constant: 0),
            NSLayoutConstraint(item: collectionView, attribute: .trailing,
                relatedBy: .equal, toItem: self, attribute: .trailing,
                multiplier: 1, constant: 0),
            
            NSLayoutConstraint(item: tableView, attribute: .top,
                relatedBy: .equal, toItem: collectionView, attribute: .bottom,
                multiplier: 1, constant: 0),
            NSLayoutConstraint(item: tableView, attribute: .leading,
                relatedBy: .equal, toItem: self, attribute: .leading,
                multiplier: 1, constant: 0),
            NSLayoutConstraint(item: tableView, attribute: .trailing,
                relatedBy: .equal, toItem: self, attribute: .trailing,
                multiplier: 1, constant: 0),
            NSLayoutConstraint(item: tableView, attribute: .bottom,
                relatedBy: .equal, toItem: self, attribute: .bottom,
                multiplier: 1, constant: 0),
            
            tableViewHeightConstraint
            ].flatMap{ $0 }.forEach { $0.isActive = true }
    }
    
    private func reloadTableView() {
        DispatchQueue.main.async {
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
            ?? OptionStyle(backgroundColor: .orange, textFont: .systemFont(ofSize: 17), textColor: .white, accessoryType: .checkmark)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (options?.count ?? 0) + (notNowButtonHidden ? 0 : 1)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsets.zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = OptionTableViewCell.init(style: .default, reuseIdentifier: tableViewCellIdentifier)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        guard let options = self.options else { return }
        if indexPath.row < options.count {
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
            SlideStyle(backgroundColor: nil, titleFont: .systemFont(ofSize: 16),
                       subtitleFont: .systemFont(ofSize: 16), titleColor: nil,
                       subtitleColor: .lightGray)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: collectionViewCellIdentifier, for: indexPath) as! SlideCollectionViewCell
        
        cell.setUp(withSlideStyle: slideStyle(atIndex: indexPath.row))
        if let slide = slides?[indexPath.row] {
            cell.setUp(withSlide: slide)
        }
        
        return cell
    }
    
}
