//
//  SwiftSyntaxHighlight.swift
//  SwiftSyntaxHighlight
//
//  Created by ensan on 2021/09/12.
//

import Foundation

public extension SyntaxParser where Self == SwiftParser {
    static var swift: Self {
        Self()
    }
}

@available(iOS 15, macOS 12, watchOS 8, tvOS 15, *)
public extension SyntaxHighlightDesign where Self == SwiftParser.DefaultDesign {
    static var swiftDefault: Self {
        Self()
    }
}

public struct SwiftParser: SyntaxParser {
    @available(iOS 15, macOS 12, watchOS 8, tvOS 15, *)
    public struct DefaultDesign: SyntaxHighlightDesign {
        public func attribute(token: SemanticToken, string: String) -> AttributedString {
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

    public enum LexicalToken: SyntaxParserLexicalToken {
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

        // Rationale: In order to know how these expressions are generated, see Tests/SwiftMarkUpTests/SwiftSyntaxParserTests.swift
        public var necessaryRegularExpression: String {
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
                return ##"(#+".*"#+)|("""[\s\S]*?["""|\n])|("([^\\"\n]|\\.)*["|\n])"##
            case .number:
                return #"(-?((0x[0-9A-Fa-f][0-9A-Fa-f_]*((\.[0-9A-Fa-f][0-9A-Fa-f_]*[pP][-+]?[0-9][0-9_]*)|(\.[0-9A-Fa-f][0-9A-Fa-f_]*)|([pP][-+]?[0-9][0-9_]*)))|([0-9][0-9_]*((\.[0-9][0-9_]*[eE][-+]?[0-9][0-9_]*)|(\.[0-9][0-9_]*)|([eE][-+]?[0-9][0-9_]*)))))|(-?(0b[01][01_]*|0o[0-7][0-7_]*|0x[0-9A-Fa-f][0-9A-Fa-f_]*|[0-9][0-9_]*))"#
            case .operator:
                return "([/=\\-\\+\\!\\*%<>&|\\^~\\?¡-§©-«¬-®°-±¶»¿×÷‖-‗†-‧‰-‾⁁-⁓⁕-⁞←-⏿─-❵➔-⯿⸀-⹿、-〃〈-〠〰][/=\\-\\+\\!\\*%<>&|\\^~\\?¡-§©-«¬-®°-±¶»¿×÷‖-‗†-‧‰-‾⁁-⁓⁕-⁞←-⏿─-❵➔-⯿⸀-⹿、-〃〈-〠〰̀-ͯ᷀-᷿⃐-⃿︀-️︠-︯󠄀-󠇯]*)|(\\.[\\./=\\-\\+\\!\\*%<>&|\\^~\\?¡-§©-«¬-®°-±¶»¿×÷‖-‗†-‧‰-‾⁁-⁓⁕-⁞←-⏿─-❵➔-⯿⸀-⹿、-〃〈-〠〰̀-ͯ᷀-᷿⃐-⃿︀-️︠-︯󠄀-󠇯]*)"
            case .keyword:
                return "#available|#colorLiteral|#column|#else|#elseif|#endif|#error|#file|#fileLiteral|#function|#if|#imageLiteral|#line|#selector|#sourceLocation|#warning|@GKInspectable|@IBAction|@IBDesignable|@IBInspectable|@IBOutlet|@NSApplicationMain|@NSCopying|@NSManaged|@UIApplicationMain|@autoclosure|@available|@convention|@discardableResult|@dynamicCallable|@dynamicMemberLookup|@escaping|@frozen|@inlinable|@main|@nonescaping|@nonobjc|@objc|@objcMembers|@propertyWrapper|@requires_stored_property_inits|@resultBuilder|@testable|@unknown|@usableFromInline|@warn_unqualified_access|Any|Protocol|Self|Type|actor|as|associatedtype|associativity|async|await|break|case|catch|class|continue|convenience|default|defer|deinit|didSet|do|dynamic|enum|extension|fallthrough|false|fileprivate|final|for|func|get|guard|if|import|in|indirect|infix|init|inout|internal|is|isolated|lazy|left|let|mutating|nil|nonisolated|nonmutating|open|operator|optional|override|postfix|precedencgroup|prefix|private|protocol|public|repeat|required|rethrows|return|right|self|set|some|static|struct|subscript|super|switch|throw|throws|true|try|typealias|var|weak|where|while|willSet"
            case .parenthesis:
                return #"[<\(\[{}\])>]"#
            case .delimiter:
                return #"[,.:;]|\n+|([ \t]+)"#
            case .unknown:
                return "[\\s\\S]"
            }
        }

    }
    public enum SemanticToken {
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
    public static var parseOrder: [LexicalToken] = [.comment, .string, .number, .operator, .keyword, .attribute, .identifier, .delimiter, .parenthesis, .unknown]
    public static func createList(from lexicalTokens: [(token: LexicalToken, string: String)]) -> [(token: SemanticToken, string: String)] {
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

