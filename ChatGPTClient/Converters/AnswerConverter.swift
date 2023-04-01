//
//  AnswerConverter.swift
//  ChatGPTClient
//
//  Created by Alexey Pichukov on 01.04.2023.
//

import Foundation

struct AnswerConverter {

    /// Splits text into blocks of items
    static func splitToBlocks(string: String) -> [TextBlock] {

        var string = string
        let codeToken = "```"
        var items: [TextBlock] = []
        var ranges: [(Int, Int, Bool)] = []
        var codeStartFound = false
        var firstIndex = 0

        let array = Array(string)
        for i in 0..<array.count {
            var token = ""
            guard i <= array.count - 3 else {
                ranges.append((firstIndex, array.count-1, false))
                break
            }
            token = "\(array[i])\(array[i+1])\(array[i+2])"
            if token == codeToken {
                if codeStartFound {
                    ranges.append((firstIndex, i+2, true))
                    codeStartFound = false
                    firstIndex = i+3
                    if firstIndex >= array.count {
                        break
                    }
                } else {
                    if firstIndex != i {
                        ranges.append((firstIndex, i-1, false))
                    }
                    codeStartFound = true
                    firstIndex = i
                }
            }
        }

        for range in ranges.reversed() {
            let start = string.index(string.startIndex, offsetBy: range.0)
            let end = string.index(string.startIndex, offsetBy: range.1)
            let _range = start...end
            items.append(
                .init(
                    value: String(string[_range]),
                    type: range.2 ? .code : .text
                )
            )
            string.removeSubrange(_range)
        }

        return items.reversed()
    }
}
