//
//  ChatGPTClientTests.swift
//  ChatGPTClientTests
//
//  Created by Alexey Pichukov on 01.04.2023.
//

import XCTest

final class ChatGPTConverterTests: XCTestCase {

    private let testAnswer = "Here\'s a sample code for bubble sort algorithm in Swift:\n\n```swift\nfunc bubbleSort(_ array: inout [Int]) {\n    guard array.count > 1 else {\n        return\n    }\n\n    for i in 0..<array.count {\n        var swapped = false\n        for j in 1..<array.count-i {\n            if array[j] < array[j-1] {\n                array.swapAt(j, j-1)\n                swapped = true\n            }\n        }\n        if !swapped {\n            return\n        }\n    }\n}\n```\n\nYou can call this function with an array of integers like this:\n\n```\nvar numbers = [23, 1, 56, 8, 102, -10]\nbubbleSort(&numbers)\nprint(numbers) // [-10, 1, 8, 23, 56, 102]\n```"
    private let emptyAnswer = ""
    private let textOnlyAnswer = "Hello world"
    private let textOnlyShortAnswer = "O"
    private let codeOnlyAnswer = "```\nvar numbers = [23, 1, 56, 8, 102, -10]\nbubbleSort(&numbers)\nprint(numbers) // [-10, 1, 8, 23, 56, 102]\n```"

    func test_splitToBlocks_answer() throws {
        // Given
        let answer = testAnswer

        // When
        let blocks = AnswerConverter.splitToBlocks(string: answer)

        // Then
        XCTAssertEqual(blocks.count, 4)
        XCTAssertEqual(blocks[0].type, .text)
        XCTAssertEqual(blocks[1].type, .code)
        XCTAssertEqual(blocks[2].type, .text)
        XCTAssertEqual(blocks[3].type, .code)
    }

    func test_splitToBlocks_emptyAnswer() {
        // Given
        let answer = emptyAnswer

        // When
        let blocks = AnswerConverter.splitToBlocks(string: answer)

        // Then
        XCTAssertEqual(blocks.count, 0)
    }

    func test_splitToBlocks_textOnlyAnswer() {
        // Given
        let answer = textOnlyAnswer

        // When
        let blocks = AnswerConverter.splitToBlocks(string: answer)

        // Then
        XCTAssertEqual(blocks.count, 1)
        XCTAssertEqual(blocks[0].type, .text)
        XCTAssertEqual(blocks[0].value, textOnlyAnswer)
    }

    func test_splitToBlocks_textOnlyShortAnswer() {
        // Given
        let answer = textOnlyShortAnswer

        // When
        let blocks = AnswerConverter.splitToBlocks(string: answer)

        // Then
        XCTAssertEqual(blocks.count, 1)
        XCTAssertEqual(blocks[0].type, .text)
        XCTAssertEqual(blocks[0].value, textOnlyShortAnswer)
    }

    func test_splitToBlocks_codeOnlyAnswer() {
        // Given
        let answer = codeOnlyAnswer

        // When
        let blocks = AnswerConverter.splitToBlocks(string: answer)

        // Then
        XCTAssertEqual(blocks.count, 1)
        XCTAssertEqual(blocks[0].type, .code)
        XCTAssertEqual(blocks[0].value, codeOnlyAnswer)
    }
}
