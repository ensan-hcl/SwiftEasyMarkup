//
//  SwiftSyntaxHighlight.swift
//  SwiftSyntaxHighlight
//
//  Created by ensan on 2021/09/12.
//

import Foundation

extension SyntaxParser where Self == SwiftParser {
    static var swift: Self {
        Self()
    }
}

@available(iOS 15, macOS 12, watchOS 8, tvOS 15, *)
extension SyntaxHighlightDesign where Self == SwiftParser.DefaultDesign {
    static var swiftDefault: Self {
        Self()
    }
}

struct SwiftParser: SyntaxParser {
    @available(iOS 15, macOS 12, watchOS 8, tvOS 15, *)
    struct DefaultDesign: SyntaxHighlightDesign {
        func attribute(token: SemanticToken, string: String) -> AttributedString {
            var attributedString = AttributedString(string)
            switch token {
            case .comment:
                attributedString.foregroundColor = .green
            case .valueIdentifier: break
            case .typelikeIdentifier: break
            case .string:
                attributedString.foregroundColor = .red
            case .number:
                attributedString.foregroundColor = .blue
            case .operator:
                attributedString.foregroundColor = .gray
            case .keyword:
                attributedString.foregroundColor = .orange
                attributedString.font = .body.bold().monospaced()
            case .parenthesis: break
            case .delimiter: break
            case .attribute: break
            case .unknown: break
            }
            return attributedString
        }
    }

    enum LexicalToken: SyntaxParserLexicalToken {
        case comment                  // コメント
        case identifier       // 型に近いものの名前
        case string                   // 文字列
        case number                   // 数値リテラル
        case `operator`               // 識別子
        case keyword                  // 予約語
        case parenthesis              // 括弧
        case delimiter                // 区切り文字
        case attribute                // 属性
        case unknown                  // 不明

        static var keywords = [
            "Any", "Type", ".Protocol", "Self",
            "true", "false", "nil", "self",
            "struct", "class", "enum", "actor", "protocol", "where", "extension", "associatedtype", "typealias", "some",
            "var", "let", "case", "lazy", "weak", "static", "dynamic", "get", "set", "didSet", "willSet", "inout",
            "func", "return", "throw", "throws", "rethrows", "try", "async", "await", "mutating", "nonmutating", "isolated", "nonisolated",
            "init", "deinit", "convenience", "required", "subscript", "indirect",
            "private", "fileprivate", "internal", "public", "open", "final", "override", "super", "optional",
            "while", "if", "for", "in", "guard", "switch", "catch", "do", "defer", "default", "fallthrough", "continue", "break", "as", "is", "repeat", "import",
            "prefix", "infix", "postfix", "operator", "precedencgroup", "associativity", "left", "right",
            "#available", "#colorLiteral", "#column", "#else", "#elseif", "#endif", "#error", "#file", "#fileLiteral", "#function", "#if", "#imageLiteral", "#line", "#selector", "#sourceLocation", "#warning",
            "@autoclosure", "@escaping", "@nonescaping", "@propertyWrapper", "@testable", "@frozen", "@main", "@unknown", "@resultBuilder", "@inlinable", "@usableFromInline", "@available", "@dynamicMemberLookup", "@dynamicCallable", "@objc", "@nonobjc", "@objcMembers", "@convention", "@discardableResult", "@IBAction", "@IBOutlet", "@IBDesignable", "@IBInspectable", "@GKInspectable", "@UIApplicationMain", "@NSApplicationMain", "@NSCopying", "@NSManaged", "@requires_stored_property_inits", "@warn_unqualified_access"
        ]

        // reference: https://docs.swift.org/swift-book/ReferenceManual/LexicalStructure.html
        var necessaryRegularExpression: String {
            switch self {
            case .comment:
                // //を用いたコメント、/**/に対応。厳密にはネストしたコメントに対処する必要がある
                return #"(/\*[\\s\\S]*?\*/)|(//.*)"#
            case .identifier:
                // valueとtypeでは識別子の種類は一緒
                let identifierHead =
                "a-zA-Z_\u{00A8}\u{00AA}\u{00AF}\u{00B2}-\u{00B5}\u{00B7}-\u{00BA}\u{00BC}-\u{00BE}\u{00C0}-\u{00D6}\u{00D8}-\u{00F6}\u{00F8}-\u{00FF}\u{0100}-\u{02FF}\u{0370}-\u{167F}\u{1681}-\u{180D}\u{180F}-\u{1DBF}\u{1E00}-\u{1FFF}\u{200B}-\u{200D}\u{202A}-\u{202E}\u{203F}-\u{2040}\u{2054}\u{2060}-\u{206F}\u{2070}-\u{20CF}\u{2100}-\u{218F}\u{2460}-\u{24FF}\u{2776}-\u{2793}\u{2C00}-\u{2DFF}\u{2E80}-\u{2FFF}\u{3004}-\u{3007}\u{3021}-\u{302F}\u{3031}-\u{303F}\u{3040}-\u{D7FF}\u{F900}-\u{FD3D}\u{FD40}-\u{FDCF}\u{FDF0}-\u{FE1F}\u{FE30}-\u{FE44}\u{FE47}-\u{FFFD}\u{10000}-\u{1FFFD}\u{20000}-\u{2FFFD}\u{30000}-\u{3FFFD}\u{40000}-\u{4FFFD}\u{50000}-\u{5FFFD}\u{60000}-\u{6FFFD}\u{70000}-\u{7FFFD}\u{80000}-\u{8FFFD}\u{90000}-\u{9FFFD}\u{A0000}-\u{AFFFD}\u{B0000}-\u{BFFFD}\u{C0000}-\u{CFFFD}\u{D0000}-\u{DFFFD}\u{E0000}-\u{FFFFD}"
                let identifierCharacter = "\(identifierHead)0-9\u{0300}-\u{036F}\u{1DC9}-\u{1DFF}\u{20D0}-\u{20FF}\u{FE20}-\u{FE2F}"
                let identifier = "\\$[0-9]+|\\$[\(identifierCharacter)]+|`[\(identifierHead)][\(identifierCharacter)]*`|[\(identifierHead)][\(identifierCharacter)]*"
                return identifier
            case .attribute:
                return "@(\(Self.identifier.necessaryRegularExpression))"
            case .string:
                // \nでない\"または\+何かの連続であり、最後は"または改行
                /*
                 let normalString = #""([^\\"\n]|\\.)*["|\n]"#
                 let multilineString = #""""[^]*?["""|\n]"#
                 let sharpstring = "#".*"#"

                 let stringLiteral "(\(sharpstring))|(\(multilineString))|\(normalString)"
                 */
                // 参考: https://refluxflow.blogspot.com/2007/09/blog-post.html
                return ##"(#".*"#)|(\"\"\"[\\s\\S]*?[\"\"\"|\\n])|\"([^\\\\\"\\n]|\\\\.)*[\"|\\n]"##
            case .number:
                /*
                 let binaryLiteral = "0b[01][01_]*"
                 let octalLiteral = "0o[0-7][0-7_]*"
                 let decimalLiteral = "[0-9][0-9_]*"
                 let hexadecimalLiteral = "0x[0-9A-Fa-f][0-9A-Fa-f_]*"
                 let integerLiteral = "\(binaryLiteral)|\(octalLiteral)|\(hexadecimalLiteral)|\(decimalLiteral)"
                 */
                /*
                 let decimalLiteral = #"[0-9][0-9_]*(\.[0-9][0-9_]*)?([eE][-+]?[0-9][0-9_]*)?"#
                 let hexadecimalLiteral = #"0x[0-9A-Fa-f][0-9A-Fa-f]*(\.[0-9A-Fa-f][0-9A-Fa-f]*)?([pP][-+]?[0-9][0-9_]*)?"#
                 let floatingPointLiteral = "\(hexadecimalLiteral)|\(decimalLiteral)"
                 */

                /*
                 let integerLiteral = "0b[01][01_]*|0o[0-7][0-7_]*|0x[0-9A-Fa-f][0-9A-Fa-f_]*|[0-9][0-9_]*"
                 let floatingPointLiteral = #"0x[0-9A-Fa-f][0-9A-Fa-f]*(\.[0-9A-Fa-f][0-9A-Fa-f]*)?([pP][-+]?[0-9][0-9_]*)?|[0-9][0-9_]*(\.[0-9][0-9_]*)?([eE][-+]?[0-9][0-9_]*)?"#

                 let numberLiteral = "(-?(\(floatingPointLiteral)))|(-?(\(integerLiteral)))"
                 */
                return #"(-?(0x[0-9A-Fa-f][0-9A-Fa-f]*(\.[0-9A-Fa-f][0-9A-Fa-f]*)?([pP][-+]?[0-9][0-9_]*)?|[0-9][0-9_]*(\.[0-9][0-9_]*)?([eE][-+]?[0-9][0-9_]*)?))|(-?(0b[01][01_]*|0o[0-7][0-7_]*|0x[0-9A-Fa-f][0-9A-Fa-f_]*|[0-9][0-9_]*))"#
            case .operator:
                /*
                 let operatorHead = "/=\\-\\+\\!\\*%<>&|\\^~\\?\u{00A1}-\u{00A7}\u{00A9}-\u{00AB}\u{00AC}-\u{00AE}\u{00B0}-\u{00B1}\u{00B6}\u{00BB}\u{00BF}\u{00D7}\u{00F7}\u{2016}-\u{2017}\u{2020}-\u{2027}\u{2030}-\u{203E}\u{2041}-\u{2053}\u{2055}-\u{205E}\u{2190}-\u{23FF}\u{2500}-\u{2775}\u{2794}-\u{2BFF}\u{2E00}-\u{2E7F}\u{3001}-\u{3003}\u{3008}-\u{3020}\u{3030}"
                 let operatorCharacter = "\(operatorHead)\u{0300}-\u{036F}\u{1DC0}-\u{1DFF}\u{20D0}-\u{20FF}\u{FE00}-\u{FE0F}\u{FE20}-\u{FE2F}\u{E0100}-\u{E01EF}"
                 let nonDotOperator = "[\(operatorHead)][\(operatorCharacter)]*"
                 let dotOperator = "\\.[\\.\(operatorCharacter)]*"
                 let operators = "(\(nonDotOperator))|(\(dotOperator))"
                 */
                return "([/=\\-\\+\\!\\*%<>&|\\^~\\?¡-§©-«¬-®°-±¶»¿×÷‖-‗†-‧‰-‾⁁-⁓⁕-⁞←-⏿─-❵➔-⯿⸀-⹿、-〃〈-〠〰][/=\\-\\+\\!\\*%<>&|\\^~\\?¡-§©-«¬-®°-±¶»¿×÷‖-‗†-‧‰-‾⁁-⁓⁕-⁞←-⏿─-❵➔-⯿⸀-⹿、-〃〈-〠〰̀-ͯ᷀-᷿⃐-⃿︀-️︠-︯󠄀-󠇯]*)|(\\.[\\./=\\-\\+\\!\\*%<>&|\\^~\\?¡-§©-«¬-®°-±¶»¿×÷‖-‗†-‧‰-‾⁁-⁓⁕-⁞←-⏿─-❵➔-⯿⸀-⹿、-〃〈-〠〰̀-ͯ᷀-᷿⃐-⃿︀-️︠-︯󠄀-󠇯]*)"
            case .keyword:
                return Self.keywords.joined(separator: "|")
            case .parenthesis:
                return #"[<\(\[{}\])>]"#
            case .delimiter:
                return #"[,.:;]|\n+|([ \t]+)"#
            case .unknown:
                return "[\\s\\S]"
            }
        }

    }
    enum SemanticToken {
        case comment                  // コメント
        case valueIdentifier          // 変数の名前
        case typelikeIdentifier       // 型に近いものの名前
        case string                   // 文字列
        case number                   // 数値リテラル
        case `operator`               // 識別子
        case keyword                  // 予約語
        case parenthesis              // 括弧
        case delimiter                // 区切り文字
        case attribute                // 属性
        case unknown                  // 不明
    }
    static var parseOrder: [LexicalToken] = [.comment, .string, .number, .operator, .keyword, .attribute, .identifier, .delimiter, .parenthesis, .unknown]
    static func createList(from lexicalTokens: [(token: LexicalToken, string: String)]) -> [(token: SemanticToken, string: String)] {
        return lexicalTokens.map { token, string in
            let semanticToken: SemanticToken
            switch token {
            case .attribute: semanticToken = .attribute
            case .comment: semanticToken = .comment
            case .delimiter: semanticToken = .delimiter
            case .identifier: semanticToken = (string.first?.isUppercase ?? false) ? .typelikeIdentifier : .valueIdentifier
            case .keyword: semanticToken = .keyword
            case .number: semanticToken = .number
            case .operator: semanticToken = .operator
            case .parenthesis: semanticToken = .parenthesis
            case .string: semanticToken = .string
            case .unknown: semanticToken = .unknown
            }
            return (semanticToken, string)
        }
    }
}

