import XCTest
@testable import SwiftEasyMarkup

// reference: https://docs.swift.org/swift-book/ReferenceManual/LexicalStructure.html

final class SwiftSyntaxParserTests: XCTestCase {
    func firstMatch(of string: String, regexp: String) -> String {
        if let range = string.range(of: regexp, options: [.regularExpression]) {
            return String(string[range])
        }
        return ""
    }

    func testIdentifierExpression() throws {
        let identifierHead =
        "a-zA-Z_\u{00A8}\u{00AA}\u{00AF}\u{00B2}-\u{00B5}\u{00B7}-\u{00BA}\u{00BC}-\u{00BE}\u{00C0}-\u{00D6}\u{00D8}-\u{00F6}\u{00F8}-\u{00FF}\u{0100}-\u{02FF}\u{0370}-\u{167F}\u{1681}-\u{180D}\u{180F}-\u{1DBF}\u{1E00}-\u{1FFF}\u{200B}-\u{200D}\u{202A}-\u{202E}\u{203F}-\u{2040}\u{2054}\u{2060}-\u{206F}\u{2070}-\u{20CF}\u{2100}-\u{218F}\u{2460}-\u{24FF}\u{2776}-\u{2793}\u{2C00}-\u{2DFF}\u{2E80}-\u{2FFF}\u{3004}-\u{3007}\u{3021}-\u{302F}\u{3031}-\u{303F}\u{3040}-\u{D7FF}\u{F900}-\u{FD3D}\u{FD40}-\u{FDCF}\u{FDF0}-\u{FE1F}\u{FE30}-\u{FE44}\u{FE47}-\u{FFFD}\u{10000}-\u{1FFFD}\u{20000}-\u{2FFFD}\u{30000}-\u{3FFFD}\u{40000}-\u{4FFFD}\u{50000}-\u{5FFFD}\u{60000}-\u{6FFFD}\u{70000}-\u{7FFFD}\u{80000}-\u{8FFFD}\u{90000}-\u{9FFFD}\u{A0000}-\u{AFFFD}\u{B0000}-\u{BFFFD}\u{C0000}-\u{CFFFD}\u{D0000}-\u{DFFFD}\u{E0000}-\u{FFFFD}"
        let identifierCharacter = "\(identifierHead)0-9\u{0300}-\u{036F}\u{1DC9}-\u{1DFF}\u{20D0}-\u{20FF}\u{FE20}-\u{FE2F}"
        let identifierExpression = "\\$[0-9]+|\\$[\(identifierCharacter)]+|`[\(identifierHead)][\(identifierCharacter)]*`|[\(identifierHead)][\(identifierCharacter)]*"

        // MARK: Check whether expression is correctly constructed
        let expression = SwiftParser.ParseContext.LexicalToken.identifier.necessaryRegularExpression
        XCTAssertEqual(expression, identifierExpression)
        if expression != identifierExpression {
            let escaped = identifierExpression.unicodeScalars.map{$0.escaped(asASCII: true)}.joined()
            print("Fix it: set SwiftParser.LexicalToken.identifier.necessaryRegularExpression as \(escaped)")
        }
    }

    func testAttributesExpression() throws {
        let attributes = [
            "@autoclosure", "@escaping", "@nonescaping", "@propertyWrapper", "@testable", "@frozen", "@main", "@unknown", "@resultBuilder", "@inlinable", "@usableFromInline", "@available", "@dynamicMemberLookup", "@dynamicCallable", "@objc", "@nonobjc", "@objcMembers", "@convention", "@discardableResult", "@IBAction", "@IBOutlet", "@IBDesignable", "@IBInspectable", "@GKInspectable", "@UIApplicationMain", "@NSApplicationMain", "@NSCopying", "@NSManaged", "@requires_stored_property_inits", "@warn_unqualified_access"
        ]
        let specialAttributeExpression = Array(Set(attributes)).sorted(by: >).joined(separator: "|")

        // MARK: Check whether expression is correctly constructed
        let expression = SwiftParser.SemanticToken.specialAttributeExpression
        XCTAssertEqual(expression, specialAttributeExpression)

        if expression != specialAttributeExpression {
            print("Fix it: set SwiftParser.SemanticToken.specialAttributeExpression as \(specialAttributeExpression)")
        }
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
        ]
        let specialKeywordExpression = Array(Set(keywords)).sorted(by: >).joined(separator: "|")

        // MARK: Check whether expression is correctly constructed
        let expression = SwiftParser.SemanticToken.specialKeywordExpression
        XCTAssertEqual(expression, specialKeywordExpression)

        if expression != specialKeywordExpression {
            print("Fix it: set SwiftParser.SemanticToken.specialKeywordExpression as \(specialKeywordExpression)")
        }
    }

    func testHashKeywordExpression() throws {
        let hashKeywords = [
            // #literal
            "#available", "#colorLiteral", "#column", "#else", "#elseif", "#endif", "#error", "#file", "#fileLiteral", "#function", "#if", "#imageLiteral", "#line", "#selector", "#sourceLocation", "#warning",
        ]
        let hashKeywordExpression = Array(Set(hashKeywords)).sorted(by: >).joined(separator: "|")

        // MARK: Check whether expression is correctly constructed
        let expression = SwiftParser.LexicalToken.hashKeyword.necessaryRegularExpression
        XCTAssertEqual(expression, hashKeywordExpression)

        if expression != hashKeywordExpression {
            print("Fix it: set SwiftParser.LexicalToken.hashKeyword.necessaryRegularExpression as \(hashKeywordExpression)")
        }
    }

    func testOperatorExpression() throws {
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

    func testHashStringLiteralExpression() throws {
        let hashStringLiteral = ##"#+".*"#+"##

        // MARK: Check whether expression is correctly constructed
        let expression = SwiftParser.LexicalToken.hashString.necessaryRegularExpression
        XCTAssertEqual(expression, hashStringLiteral)

        if expression != hashStringLiteral {
            print("Fix it: set SwiftParser.LexicalToken.hashString.necessaryRegularExpression as \(hashStringLiteral)")
        }
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
        let expression = SwiftParser.LexicalToken.numberLiteral.necessaryRegularExpression
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

