import XCTest
@testable import SwiftMarkUp

final class SwiftSyntaxHighlightTests: XCTestCase {
    func firstMatch(of string: String, regexp: String) -> String {
        if let range = string.range(of: regexp, options: [.regularExpression]) {
            return String(string[range])
        }
        return ""
    }

    func testStringLiteralExpression() throws {
        // reference: https://refluxflow.blogspot.com/2007/09/blog-post.html

        let normalStringLiteral = #""([^\\"\n]|\\.)*["|\n]"#
        let multilineStringLiteral = #""""[\s\S]*?["""|\n]"#
        let sharpStringLiteral = ##"#+".*"#+"##
        let stringLiteral = "(\(sharpStringLiteral))|(\(multilineStringLiteral))|(\(normalStringLiteral))"

        // MARK: Check whether expression is correctly constructed
        let expression = SwiftParser.LexicalToken.string.necessaryRegularExpression
        XCTAssertEqual(expression, stringLiteral)

        if expression != stringLiteral {
            print("Fix it: set SwiftParser.LexicalToken.string.necessaryRegularExpression as \(stringLiteral)")
        }

        // MARK: Check whole expression
        XCTAssertEqual(firstMatch(of: #""aa\"a""#, regexp: expression),  #""aa\"a""#)

        // MARK: Check whole normalString
        XCTAssertEqual(firstMatch(of: #""aa\"a""#, regexp: normalStringLiteral),  #""aa\"a""#)
    }

    func testNumberLiteralExpression() throws {
        let binaryLiteral = "0b[01][01_]*"
        let octalLiteral = "0o[0-7][0-7_]*"
        let decimalLiteral = "[0-9][0-9_]*"
        let hexadecimalLiteral = "0x[0-9A-Fa-f][0-9A-Fa-f_]*"
        let integerLiteral = "\(binaryLiteral)|\(octalLiteral)|\(hexadecimalLiteral)|\(decimalLiteral)"
        let floatDecimalLiteral = #"[0-9][0-9_]*((\.[0-9][0-9_]*[eE][-+]?[0-9][0-9_]*)|(\.[0-9][0-9_]*)|([eE][-+]?[0-9][0-9_]*))"#
        let floatHexadecimalLiteral = #"0x[0-9A-Fa-f][0-9A-Fa-f_]*((\.[0-9A-Fa-f][0-9A-Fa-f_]*[pP][-+]?[0-9][0-9_]*)|(\.[0-9A-Fa-f][0-9A-Fa-f_]*)|([pP][-+]?[0-9][0-9_]*))"#
        let floatingPointLiteral = "(\(floatHexadecimalLiteral))|(\(floatDecimalLiteral))"
        let numberLiteral = "(-?(\(floatingPointLiteral)))|(-?(\(integerLiteral)))"

        // MARK: Check whether expression is correctly constructed
        let expression = SwiftParser.LexicalToken.number.necessaryRegularExpression
        XCTAssertEqual(expression, numberLiteral)

        if expression != numberLiteral {
            print("Fix it: set SwiftParser.LexicalToken.number.necessaryRegularExpression as \(numberLiteral)")
        }

        // MARK: Check whole expression
        XCTAssertEqual(firstMatch(of: "m0ca1154", regexp: expression), "0")
        XCTAssertEqual(firstMatch(of: "0x24F1_1g1a3", regexp: expression), "0x24F1_1")
        XCTAssertEqual(firstMatch(of: "14.2e-2", regexp: expression), "14.2e-2")
        XCTAssertEqual(firstMatch(of: "niave0o71c831", regexp: expression), "0o71")

        // MARK: Check floatDecimalLiteral
        XCTAssertEqual(firstMatch(of: "42", regexp: floatDecimalLiteral), "")
        XCTAssertEqual(firstMatch(of: "4.2", regexp: floatDecimalLiteral), "4.2")
        XCTAssertEqual(firstMatch(of: "4e-2", regexp: floatDecimalLiteral), "4e-2")
        XCTAssertEqual(firstMatch(of: "4.0e-2", regexp: floatDecimalLiteral), "4.0e-2")

        // MARK: Check hexadecimalLiteral
        XCTAssertEqual(firstMatch(of: "0x42", regexp: floatHexadecimalLiteral), "")
        XCTAssertEqual(firstMatch(of: "0x4.f", regexp: floatHexadecimalLiteral), "0x4.f")
        XCTAssertEqual(firstMatch(of: "0x4p-2", regexp: floatHexadecimalLiteral), "0x4p-2")
        XCTAssertEqual(firstMatch(of: "0x4.0p-2", regexp: floatHexadecimalLiteral), "0x4.0p-2")
    }

}

