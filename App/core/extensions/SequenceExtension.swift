//
//  SequenceExtension.swift
//  App
//
//  Created by Omar Brugna on 31/07/23.
//

import Foundation

extension Sequence {
    
    public func sumOf(_ selector: (Element) -> Int) -> Int {
        return self.reduce(into: 0) { (sum, element) in
            sum += selector(element)
        }
    }
    
    public func limitedTo(_ limit: Int) -> [Element] {
        var limitedModels = [Element]()
        var index = 0
        for model in self {
            index += 1
            limitedModels.append(model)
            if index == limit { break }
        }
        return limitedModels
    }
}
