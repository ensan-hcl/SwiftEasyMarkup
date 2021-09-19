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
    public typealias LexicalToken = ParseContext.LexicalToken

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
            case .numberLiteral:
                attributedString.foregroundColor = .blue
            case .operator:
                attributedString.foregroundColor = .gray
            case .specialIdentifier, .specialAttribute:
                attributedString.foregroundColor = .orange
                attributedString.font = .body.bold().monospaced()
            case .parenthesis, .delimiter, .attribute, .unknown: break
            }
            return attributedString
        }
    }

    public enum ParseContext: SyntaxParserParseContext {
        case global(endCondition: ParseEndCondition)
        case stringLiteral
        case comment

        public enum LexicalToken {
            case identifier, `operator`, parenthesis, delimiter, numberLiteral, hashKeyword, attribute, unknown
            case inlineComment, partialComment, commentBlockStart, commentBlockEnd
            case hashString, stringInterpolationStart, stringBlockDelimiter, partialStringLiteral
            public var necessaryRegularExpression: String {
                switch self {
                case .partialStringLiteral:
                    fatalError("don't need implementation")
                case .stringInterpolationStart:
                    return #"\\\("#
                case .partialComment:
                    fatalError("don't need implementation")
                case .commentBlockStart:
                    return #"/\*"#
                case .commentBlockEnd:
                    return #"\*/"#
                case .stringBlockDelimiter:
                    return #""""|^(\\\\)*""#
                case .hashString:
                    return ##"#+".*"#+"##
                case .inlineComment:
                    return "(//.*)"
                case .identifier:
                    return "\\$[0-9]+|\\$[a-zA-Z_\u{00A8}\u{00AA}\u{00AF}\u{00B2}-\u{00B5}\u{00B7}-\u{00BA}\u{00BC}-\u{00BE}\u{00C0}-\u{00D6}\u{00D8}-\u{00F6}\u{00F8}-\u{00FF}\u{0100}-\u{02FF}\u{0370}-\u{167F}\u{1681}-\u{180D}\u{180F}-\u{1DBF}\u{1E00}-\u{1FFF}\u{200B}-\u{200D}\u{202A}-\u{202E}\u{203F}-\u{2040}\u{2054}\u{2060}-\u{206F}\u{2070}-\u{20CF}\u{2100}-\u{218F}\u{2460}-\u{24FF}\u{2776}-\u{2793}\u{2C00}-\u{2DFF}\u{2E80}-\u{2FFF}\u{3004}-\u{3007}\u{3021}-\u{302F}\u{3031}-\u{303F}\u{3040}-\u{D7FF}\u{F900}-\u{FD3D}\u{FD40}-\u{FDCF}\u{FDF0}-\u{FE1F}\u{FE30}-\u{FE44}\u{FE47}-\u{FFFD}\u{00010000}-\u{0001FFFD}\u{00020000}-\u{0002FFFD}\u{00030000}-\u{0003FFFD}\u{00040000}-\u{0004FFFD}\u{00050000}-\u{0005FFFD}\u{00060000}-\u{0006FFFD}\u{00070000}-\u{0007FFFD}\u{00080000}-\u{0008FFFD}\u{00090000}-\u{0009FFFD}\u{000A0000}-\u{000AFFFD}\u{000B0000}-\u{000BFFFD}\u{000C0000}-\u{000CFFFD}\u{000D0000}-\u{000DFFFD}\u{000E0000}-\u{000FFFFD}0-9\u{0300}-\u{036F}\u{1DC9}-\u{1DFF}\u{20D0}-\u{20FF}\u{FE20}-\u{FE2F}]+|`[a-zA-Z_\u{00A8}\u{00AA}\u{00AF}\u{00B2}-\u{00B5}\u{00B7}-\u{00BA}\u{00BC}-\u{00BE}\u{00C0}-\u{00D6}\u{00D8}-\u{00F6}\u{00F8}-\u{00FF}\u{0100}-\u{02FF}\u{0370}-\u{167F}\u{1681}-\u{180D}\u{180F}-\u{1DBF}\u{1E00}-\u{1FFF}\u{200B}-\u{200D}\u{202A}-\u{202E}\u{203F}-\u{2040}\u{2054}\u{2060}-\u{206F}\u{2070}-\u{20CF}\u{2100}-\u{218F}\u{2460}-\u{24FF}\u{2776}-\u{2793}\u{2C00}-\u{2DFF}\u{2E80}-\u{2FFF}\u{3004}-\u{3007}\u{3021}-\u{302F}\u{3031}-\u{303F}\u{3040}-\u{D7FF}\u{F900}-\u{FD3D}\u{FD40}-\u{FDCF}\u{FDF0}-\u{FE1F}\u{FE30}-\u{FE44}\u{FE47}-\u{FFFD}\u{00010000}-\u{0001FFFD}\u{00020000}-\u{0002FFFD}\u{00030000}-\u{0003FFFD}\u{00040000}-\u{0004FFFD}\u{00050000}-\u{0005FFFD}\u{00060000}-\u{0006FFFD}\u{00070000}-\u{0007FFFD}\u{00080000}-\u{0008FFFD}\u{00090000}-\u{0009FFFD}\u{000A0000}-\u{000AFFFD}\u{000B0000}-\u{000BFFFD}\u{000C0000}-\u{000CFFFD}\u{000D0000}-\u{000DFFFD}\u{000E0000}-\u{000FFFFD}][a-zA-Z_\u{00A8}\u{00AA}\u{00AF}\u{00B2}-\u{00B5}\u{00B7}-\u{00BA}\u{00BC}-\u{00BE}\u{00C0}-\u{00D6}\u{00D8}-\u{00F6}\u{00F8}-\u{00FF}\u{0100}-\u{02FF}\u{0370}-\u{167F}\u{1681}-\u{180D}\u{180F}-\u{1DBF}\u{1E00}-\u{1FFF}\u{200B}-\u{200D}\u{202A}-\u{202E}\u{203F}-\u{2040}\u{2054}\u{2060}-\u{206F}\u{2070}-\u{20CF}\u{2100}-\u{218F}\u{2460}-\u{24FF}\u{2776}-\u{2793}\u{2C00}-\u{2DFF}\u{2E80}-\u{2FFF}\u{3004}-\u{3007}\u{3021}-\u{302F}\u{3031}-\u{303F}\u{3040}-\u{D7FF}\u{F900}-\u{FD3D}\u{FD40}-\u{FDCF}\u{FDF0}-\u{FE1F}\u{FE30}-\u{FE44}\u{FE47}-\u{FFFD}\u{00010000}-\u{0001FFFD}\u{00020000}-\u{0002FFFD}\u{00030000}-\u{0003FFFD}\u{00040000}-\u{0004FFFD}\u{00050000}-\u{0005FFFD}\u{00060000}-\u{0006FFFD}\u{00070000}-\u{0007FFFD}\u{00080000}-\u{0008FFFD}\u{00090000}-\u{0009FFFD}\u{000A0000}-\u{000AFFFD}\u{000B0000}-\u{000BFFFD}\u{000C0000}-\u{000CFFFD}\u{000D0000}-\u{000DFFFD}\u{000E0000}-\u{000FFFFD}0-9\u{0300}-\u{036F}\u{1DC9}-\u{1DFF}\u{20D0}-\u{20FF}\u{FE20}-\u{FE2F}]*`|[a-zA-Z_\u{00A8}\u{00AA}\u{00AF}\u{00B2}-\u{00B5}\u{00B7}-\u{00BA}\u{00BC}-\u{00BE}\u{00C0}-\u{00D6}\u{00D8}-\u{00F6}\u{00F8}-\u{00FF}\u{0100}-\u{02FF}\u{0370}-\u{167F}\u{1681}-\u{180D}\u{180F}-\u{1DBF}\u{1E00}-\u{1FFF}\u{200B}-\u{200D}\u{202A}-\u{202E}\u{203F}-\u{2040}\u{2054}\u{2060}-\u{206F}\u{2070}-\u{20CF}\u{2100}-\u{218F}\u{2460}-\u{24FF}\u{2776}-\u{2793}\u{2C00}-\u{2DFF}\u{2E80}-\u{2FFF}\u{3004}-\u{3007}\u{3021}-\u{302F}\u{3031}-\u{303F}\u{3040}-\u{D7FF}\u{F900}-\u{FD3D}\u{FD40}-\u{FDCF}\u{FDF0}-\u{FE1F}\u{FE30}-\u{FE44}\u{FE47}-\u{FFFD}\u{00010000}-\u{0001FFFD}\u{00020000}-\u{0002FFFD}\u{00030000}-\u{0003FFFD}\u{00040000}-\u{0004FFFD}\u{00050000}-\u{0005FFFD}\u{00060000}-\u{0006FFFD}\u{00070000}-\u{0007FFFD}\u{00080000}-\u{0008FFFD}\u{00090000}-\u{0009FFFD}\u{000A0000}-\u{000AFFFD}\u{000B0000}-\u{000BFFFD}\u{000C0000}-\u{000CFFFD}\u{000D0000}-\u{000DFFFD}\u{000E0000}-\u{000FFFFD}][a-zA-Z_\u{00A8}\u{00AA}\u{00AF}\u{00B2}-\u{00B5}\u{00B7}-\u{00BA}\u{00BC}-\u{00BE}\u{00C0}-\u{00D6}\u{00D8}-\u{00F6}\u{00F8}-\u{00FF}\u{0100}-\u{02FF}\u{0370}-\u{167F}\u{1681}-\u{180D}\u{180F}-\u{1DBF}\u{1E00}-\u{1FFF}\u{200B}-\u{200D}\u{202A}-\u{202E}\u{203F}-\u{2040}\u{2054}\u{2060}-\u{206F}\u{2070}-\u{20CF}\u{2100}-\u{218F}\u{2460}-\u{24FF}\u{2776}-\u{2793}\u{2C00}-\u{2DFF}\u{2E80}-\u{2FFF}\u{3004}-\u{3007}\u{3021}-\u{302F}\u{3031}-\u{303F}\u{3040}-\u{D7FF}\u{F900}-\u{FD3D}\u{FD40}-\u{FDCF}\u{FDF0}-\u{FE1F}\u{FE30}-\u{FE44}\u{FE47}-\u{FFFD}\u{00010000}-\u{0001FFFD}\u{00020000}-\u{0002FFFD}\u{00030000}-\u{0003FFFD}\u{00040000}-\u{0004FFFD}\u{00050000}-\u{0005FFFD}\u{00060000}-\u{0006FFFD}\u{00070000}-\u{0007FFFD}\u{00080000}-\u{0008FFFD}\u{00090000}-\u{0009FFFD}\u{000A0000}-\u{000AFFFD}\u{000B0000}-\u{000BFFFD}\u{000C0000}-\u{000CFFFD}\u{000D0000}-\u{000DFFFD}\u{000E0000}-\u{000FFFFD}0-9\u{0300}-\u{036F}\u{1DC9}-\u{1DFF}\u{20D0}-\u{20FF}\u{FE20}-\u{FE2F}]*"
                case .attribute:
                    return "@(\(Self.identifier.necessaryRegularExpression))"
                case .hashKeyword:
                    return "#warning|#sourceLocation|#selector|#line|#imageLiteral|#if|#function|#fileLiteral|#file|#error|#endif|#elseif|#else|#column|#colorLiteral|#available"
                case .numberLiteral:
                    return #"(-?((0x[0-9A-Fa-f][0-9A-Fa-f_]*((\.[0-9A-Fa-f][0-9A-Fa-f_]*[pP][-+]?[0-9][0-9_]*)|(\.[0-9A-Fa-f][0-9A-Fa-f_]*)|([pP][-+]?[0-9][0-9_]*)))|([0-9][0-9_]*((\.[0-9][0-9_]*[eE][-+]?[0-9][0-9_]*)|(\.[0-9][0-9_]*)|([eE][-+]?[0-9][0-9_]*)))))|(-?(0b[01][01_]*|0o[0-7][0-7_]*|0x[0-9A-Fa-f][0-9A-Fa-f_]*|[0-9][0-9_]*))"#
                case .operator:
                    return "([/=\\-\\+\\!\\*%<>&|\\^~\\?¡-§©-«¬-®°-±¶»¿×÷‖-‗†-‧‰-‾⁁-⁓⁕-⁞←-⏿─-❵➔-⯿⸀-⹿、-〃〈-〠〰][/=\\-\\+\\!\\*%<>&|\\^~\\?¡-§©-«¬-®°-±¶»¿×÷‖-‗†-‧‰-‾⁁-⁓⁕-⁞←-⏿─-❵➔-⯿⸀-⹿、-〃〈-〠〰̀-ͯ᷀-᷿⃐-⃿︀-️︠-︯󠄀-󠇯]*)|(\\.[\\./=\\-\\+\\!\\*%<>&|\\^~\\?¡-§©-«¬-®°-±¶»¿×÷‖-‗†-‧‰-‾⁁-⁓⁕-⁞←-⏿─-❵➔-⯿⸀-⹿、-〃〈-〠〰̀-ͯ᷀-᷿⃐-⃿︀-️︠-︯󠄀-󠇯]*)"
                case .parenthesis:
                    return #"[<\(\[{}\])>]"#
                case .delimiter:
                    return #"[,.:;]|\n+|([ \t]+)"#
                case .unknown:
                    return "[\\s\\S]"
                }
            }
        }

        public enum ParseEndCondition {
            case last    // 最後までとにかく調べる
            case mismatchParentheses  // 対応していない括弧を発見した場合
            case findToken(LexicalToken)  // 特定のトークンを発見した場合
        }

        public var parseOrder: [LexicalToken] {
            switch self {
            case .global:
                return [.commentBlockStart, .hashString, .stringBlockDelimiter, .inlineComment, .numberLiteral, .operator, .hashKeyword, .attribute, .identifier, .delimiter, .parenthesis, .unknown]
            case .stringLiteral:
                return [.stringInterpolationStart, .stringBlockDelimiter, .unknown]
            case .comment:
                return [.commentBlockStart, .commentBlockEnd, .unknown]
            }
        }

        public static let top: Self = .global(endCondition: .last)

        func checkTransition(token: LexicalToken, string: String) -> ParseContext? {
            switch self {
            case .global:
                if case .stringBlockDelimiter = token {
                    return .stringLiteral
                }
                if case .commentBlockStart = token {
                    return .comment
                }
            case .comment:
                if case .commentBlockStart = token {
                    return .comment
                }
            case .stringLiteral:
                if case .stringInterpolationStart = token {
                    return .global(endCondition: .mismatchParentheses)
                }
            }
            return nil
        }

        var endCondition: ParseEndCondition {
            switch self {
            case let .global(endCondition: condition): return condition
            case .comment: return .findToken(.commentBlockEnd)
            case .stringLiteral: return .findToken(.stringBlockDelimiter)
            }
        }

        func modifyUnknownToken(string: String) -> LexicalToken {
            switch self {
            case .global: return .unknown
            case .comment: return .partialComment
            case .stringLiteral: return .partialStringLiteral
            }
        }
    }

    public enum SemanticToken: String, CustomStringConvertible {
        case `operator`, parenthesis, delimiter, numberLiteral, unknown
        case string
        case comment
        case typelikeIdentifier, valueIdentifier, specialIdentifier
        case attribute, specialAttribute // @available or etc

        public var description: String {
            return self.rawValue
        }

        static let specialAttributeExpression =  "@warn_unqualified_access|@usableFromInline|@unknown|@testable|@resultBuilder|@requires_stored_property_inits|@propertyWrapper|@objcMembers|@objc|@nonobjc|@nonescaping|@main|@inlinable|@frozen|@escaping|@dynamicMemberLookup|@dynamicCallable|@discardableResult|@convention|@available|@autoclosure|@UIApplicationMain|@NSManaged|@NSCopying|@NSApplicationMain|@IBOutlet|@IBInspectable|@IBDesignable|@IBAction|@GKInspectable"
        static let specialKeywordExpression =  "willSet|while|where|weak|var|typealias|try|true|throws|throw|switch|super|subscript|struct|static|some|set|self|right|return|rethrows|required|repeat|public|protocol|private|prefix|precedencgroup|postfix|override|optional|operator|open|nonmutating|nonisolated|nil|mutating|let|left|lazy|isolated|is|internal|inout|init|infix|indirect|in|import|if|guard|get|func|for|final|fileprivate|false|fallthrough|extension|enum|dynamic|do|didSet|deinit|defer|default|convenience|continue|class|catch|case|break|await|async|associativity|associatedtype|as|actor|Type|Self|Protocol|Any"
    }

    public func semantify(from lexicalTokens: [(token: LexicalToken, string: String)]) -> [(token: SemanticToken, string: String)] {
        return lexicalTokens.reduce(into: [(token: SemanticToken, string: String)]()) { result, pair in
            let (token, string) = pair
            let semanticToken: SemanticToken
            switch token {
            case .attribute:
                if let range = string.range(of: SemanticToken.specialAttributeExpression, options: .regularExpression), string[range] == string {
                    semanticToken = .specialAttribute
                } else {
                    semanticToken = .attribute
                }
            case .inlineComment, .commentBlockStart, .commentBlockEnd, .partialComment: semanticToken = .comment
            case .delimiter: semanticToken = .delimiter
            case .identifier:
                if let range = string.range(of: SemanticToken.specialKeywordExpression, options: .regularExpression), string[range] == string {
                    semanticToken = .specialIdentifier
                } else {
                    semanticToken = (string.first?.isUppercase ?? false) ? .typelikeIdentifier : .valueIdentifier
                }
            case .hashKeyword: semanticToken = .specialIdentifier
            case .numberLiteral: semanticToken = .numberLiteral
            case .operator: semanticToken = .operator
            case .parenthesis: semanticToken = .parenthesis
            case .stringBlockDelimiter, .stringInterpolationStart, .partialStringLiteral, .hashString: semanticToken = .string
            case .unknown: semanticToken = .unknown
            }
            if let last = result.last {
                if case .string = last.token, semanticToken == .string {
                    result[result.endIndex - 1].string += string
                    return
                }
            }
            result.append((semanticToken, string))
        }
    }

    public func lex(code: inout Substring, target: ParseContext = .global(endCondition: .last)) -> [(ParseContext.LexicalToken, String)] {
        func parenPair(with string: String) -> String? {
            if string == "}" { return "{" }
            if string == "]" { return "[" }
            if string == ")" { return "(" }
            if string == ">" { return "<" }
            return nil
        }
        var matches: [String: Int] = [:]   // 括弧の種類: カウント
        var lexicalTokens: [(LexicalToken, String)] = []
        let endCondition = target.endCondition
        while !code.isEmpty {
            for lexicalToken in target.parseOrder {
                if let range = code.range(of: "^(\(lexicalToken.necessaryRegularExpression))", options: .regularExpression) {
                    let tokenString = String(code[range])
                    if case .mismatchParentheses = endCondition, case .parenthesis = lexicalToken {
                        if let key = parenPair(with: tokenString) {
                            matches[key, default: 0] -= 1
                            if matches[key, default: 0] < 0 {
                                return lexicalTokens
                            }
                        } else {
                            matches[tokenString, default: 0] += 1
                        }
                    }
                    if case .unknown = lexicalToken {
                        let token = target.modifyUnknownToken(string: tokenString)
                        lexicalTokens.append((token, tokenString))
                        code = code[range.upperBound...]
                        break
                    }
                    lexicalTokens.append((lexicalToken, tokenString))
                    code = code[range.upperBound...]
                    if let transition = target.checkTransition(token: lexicalToken, string: tokenString) {
                        lexicalTokens.append(contentsOf: lex(code: &code, target: transition))
                        break
                    }
                    if case .findToken(let token) = endCondition, token == lexicalToken {
                        return lexicalTokens
                    }
                    break
                }
            }
        }
        return lexicalTokens
    }
}
