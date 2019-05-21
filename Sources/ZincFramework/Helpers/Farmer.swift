//
//  Farmer.swift
//  Zinc
//
//  Created by Brian Drelling on 5/20/2019.
//  Copyright © 2019 SpotHero. All rights reserved.
//

import Foundation
import Yams

class Farmer {
    static let shared = Farmer()

    func deserialize<T>(_ text: String) -> T? where T: Decodable {
        do {
            return try YAMLDecoder().decode(T.self, from: text)
        } catch {
            Lumberjack.shared.log(error)
            return nil
        }
    }
}
