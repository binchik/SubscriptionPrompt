//
//  SlideStyle.swift
//  SubscriptionPrompt
//
//  Created by Binur Konarbayev on 7/16/16.
//
//

import UIKit

@objc public final class SlideStyle: NSObject {
    let backgroundColor: UIColor?
    let titleFont: UIFont?
    let subtitleFont: UIFont?
    let titleColor: UIColor?
    let subtitleColor: UIColor?
    
    public init(backgroundColor: UIColor? = nil, titleFont: UIFont? = nil,
                subtitleFont: UIFont? = nil, titleColor: UIColor? = nil,
                subtitleColor: UIColor? = nil) {
        self.backgroundColor = backgroundColor
        self.titleFont = titleFont
        self.subtitleFont = subtitleFont
        self.titleColor = titleColor
        self.subtitleColor = subtitleColor
    }
}
