import XCTest
@testable import SwiftMarkUp

final class SwiftSyntaxHighlightTests: XCTestCase {
    func firstMatch(of string: String, regexp: String) -> String {
        if let range = string.range(of: regexp, options: [.regularExpression]) {
            return String(string[range])
        }
        return ""
    }

    func testKeywordsExpression() throws {
        let keywords = [
            // special value relating keywords
            "true", "false", "nil", "self", "super",

            // special type relating keywords
            "Any", "Type", "Protocol", "Self",

            // type relating keywords
            "struct", "class", "enum", "actor", "protocol", "where", "extension", "associatedtype", "typealias",

            // access controls
            "private", "fileprivate", "internal", "public", "open",

            // declaration of functions/values relating keywords
            "var", "let", "case", "lazy", "weak", "static", "dynamic", "get", "set", "didSet", "willSet", "inout", "func", "throws", "rethrows", "async", "mutating", "nonmutating", "isolated", "nonisolated", "some", "init", "deinit", "convenience", "required", "subscript", "indirect", "final", "override", "optional",

            // statements
            "while", "if", "for", "in", "guard", "switch", "catch", "do", "defer", "default", "fallthrough", "continue", "break", "repeat", "import", "await", "try", "return", "throw",

            // operator relating keywords
            "as", "is", "prefix", "infix", "postfix", "operator", "precedencgroup", "associativity", "left", "right",

            // #literal
            "#available", "#colorLiteral", "#column", "#else", "#elseif", "#endif", "#error", "#file", "#fileLiteral", "#function", "#if", "#imageLiteral", "#line", "#selector", "#sourceLocation", "#warning",

            // attributes
            "@autoclosure", "@escaping", "@nonescaping", "@propertyWrapper", "@testable", "@frozen", "@main", "@unknown", "@resultBuilder", "@inlinable", "@usableFromInline", "@available", "@dynamicMemberLookup", "@dynamicCallable", "@objc", "@nonobjc", "@objcMembers", "@convention", "@discardableResult", "@IBAction", "@IBOutlet", "@IBDesignable", "@IBInspectable", "@GKInspectable", "@UIApplicationMain", "@NSApplicationMain", "@NSCopying", "@NSManaged", "@requires_stored_property_inits", "@warn_unqualified_access"
        ]
        let keywordExpression = Array(Set(keywords)).sorted().joined(separator: "|")

        // MARK: Check whether expression is correctly constructed
        let expression = SwiftParser.LexicalToken.keyword.necessaryRegularExpression
        XCTAssertEqual(expression, keywordExpression)

        if expression != keywordExpression {
            print("Fix it: set SwiftParser.LexicalToken.keyword.necessaryRegularExpression as \(keywordExpression)")
        }
    }

    func testOperatorexpression() throws {
        let operatorHead = "/=\\-\\+\\!\\*%<>&|\\^~\\?\u{00A1}-\u{00A7}\u{00A9}-\u{00AB}\u{00AC}-\u{00AE}\u{00B0}-\u{00B1}\u{00B6}\u{00BB}\u{00BF}\u{00D7}\u{00F7}\u{2016}-\u{2017}\u{2020}-\u{2027}\u{2030}-\u{203E}\u{2041}-\u{2053}\u{2055}-\u{205E}\u{2190}-\u{23FF}\u{2500}-\u{2775}\u{2794}-\u{2BFF}\u{2E00}-\u{2E7F}\u{3001}-\u{3003}\u{3008}-\u{3020}\u{3030}"
        let operatorCharacter = "\(operatorHead)\u{0300}-\u{036F}\u{1DC0}-\u{1DFF}\u{20D0}-\u{20FF}\u{FE00}-\u{FE0F}\u{FE20}-\u{FE2F}\u{E0100}-\u{E01EF}"
        let nonDotOperator = "[\(operatorHead)][\(operatorCharacter)]*"
        let dotOperator = "\\.[\\.\(operatorCharacter)]*"
        let operatorExpression = "(\(nonDotOperator))|(\(dotOperator))"

        // MARK: Check whether expression is correctly constructed
        let expression = SwiftParser.LexicalToken.operator.necessaryRegularExpression
        XCTAssertEqual(expression, operatorExpression)

        if expression != operatorExpression {
            print("Fix it: set SwiftParser.LexicalToken.operator.necessaryRegularExpression as \(operatorExpression)")
        }
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

