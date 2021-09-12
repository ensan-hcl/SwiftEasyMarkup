import XCTest
@testable import SwiftMarkUp

final class SwiftSyntaxHighlightTests: XCTestCase {
    func firstMatch(of string: String, regexp: String) -> String {
        if let range = string.range(of: regexp, options: [.regularExpression]) {
            return String(string[range])
        }
        return ""
    }

    func testExample() throws {
        let normalStringExpression = #""([^\\"\n]|\\.)*["|\n]"#
        XCTAssertEqual(firstMatch(of: #""aa\"a""#, regexp: normalStringExpression),  #""aa\"a""#)
        let stringExpression = SwiftParser.LexicalToken.string.necessaryRegularExpression
        XCTAssertEqual(firstMatch(of: #""aa\"a""#, regexp: stringExpression),  #""aa\"a""#)
    }
}

