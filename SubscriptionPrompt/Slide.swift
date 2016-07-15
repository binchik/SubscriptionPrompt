//
//  Slide.swift
//  SubscriptionPrompt
//
//  Created by Binur Konarbayev on 7/15/16.
//
//

import UIKit

public struct Slide {
    public let image: UIImage?
    public let title: String?
    public let subtitle: String?
    
    public init(image: UIImage?, title: String?, subtitle: String?) {
        self.image = image
        self.title = title
        self.subtitle = subtitle
    }
}
