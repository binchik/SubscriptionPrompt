//
//  Option.swift
//  Pods
//
//  Created by Binur Konarbayev on 7/15/16.
//
//

import Foundation

public struct Option {
    public let title: String?
    public var checked: Bool
    
    public init(title: String?, checked: Bool = false) {
        self.title = title
        self.checked = checked
    }
}
