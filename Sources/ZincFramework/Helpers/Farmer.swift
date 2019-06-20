// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation
import Yams

class Farmer {
    static let shared = Farmer()

    func deserialize<T>(_ text: String) -> T? where T: Decodable {
        do {
            return try YAMLDecoder().decode(T.self, from: text)
        } catch {
            Lumberjack.shared.report(error)
            return nil
        }
    }
}
