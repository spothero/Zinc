//
//  PropertyReflecting.swift
//  ZincFramework
//
//  Created by Brian Drelling on 6/4/19.
//

protocol PropertyReflecting {
    var properties: [String] { get }
}

extension PropertyReflecting {
    var properties: [String] {
        return Mirror(reflecting: self).children.compactMap { $0.label }
    }
}
