// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation
import Logging
import Yams

class YAMLDeserializer {
    static let shared = YAMLDeserializer()
    
    func deserialize<T>(_ text: String) -> T? where T: Decodable {
        do {
            return try YAMLDecoder().decode(T.self, from: text)
        } catch {
            Zinc.logger.error("\(error.localizedDescription)")
            return nil
        }
    }
}
