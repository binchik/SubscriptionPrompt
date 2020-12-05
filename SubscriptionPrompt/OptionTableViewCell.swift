//
//  OptionTableViewCell.swift
//  SubscriptionPrompt
//
//  Created by Binur Konarbayev on 7/16/16.
//
//

import UIKit

final class OptionTableViewCell: UITableViewCell {
    fileprivate var disclosureType: UITableViewCell.AccessoryType?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpViews()
    }
    
    fileprivate func setUpViews() {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .orange
        selectedBackgroundView = backgroundView
        textLabel?.textAlignment = .center
    }
}

extension OptionTableViewCell {
    func setUp(withOption option: Option) {
        accessoryType = option.checked ? (disclosureType ?? .checkmark) : .none
        textLabel?.text = option.title
    }
    
    func setUp(withOptionStyle style: OptionStyle) {
        backgroundColor = style.backgroundColor
        textLabel?.font = style.textFont
        textLabel?.textColor = style.textColor
        disclosureType = style.accessoryType
    }
}
