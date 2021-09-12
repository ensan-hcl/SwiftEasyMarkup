//
//  SyntaxHighlight.swift
//  SyntaxHighlight
//
//  Created by ensan on 2021/09/11.
//

import Foundation
import SwiftUI

@available(iOS 15, macOS 12, watchOS 8, tvOS 15, *)
struct SyntaxHighlighter<Parser: SyntaxParser> {
    private var parser: Parser
    init(parser: Parser) {
        self.parser = parser
    }
    func highlight<Design: SyntaxHighlightDesign>(code: String, design: Design) -> AttributedString where Design.Token == Parser.SemanticToken {
        let attributedStrings = parser.parse(code: code).map{design.attribute(token: $0, string: $1)}
        return attributedStrings.reduce(AttributedString(""), +)
    }
}

protocol SyntaxParser {
    associatedtype LexicalToken: SyntaxParserLexicalToken
    associatedtype SemanticToken
    static var parseOrder: [LexicalToken] { get }
    static func createList(from lexicalTokens: [(token: LexicalToken, string: String)]) -> [(token: SemanticToken, string: String)]

    func parse(code: String) -> [(token: SemanticToken, string: String)]
}

protocol SyntaxParserLexicalToken {
    var necessaryRegularExpression: String { get }
}

@available(iOS 15, macOS 12, watchOS 8, tvOS 15, *)
protocol SyntaxHighlightDesign {
    associatedtype Token
    func attribute(token: Token, string: String) -> AttributedString
}


extension SyntaxParser {
    func parse(code: String) -> [(token: SemanticToken, string: String)] {
        var substring = code[...]
        var lexicalTokens: [(LexicalToken, String)] = []
        while !substring.isEmpty {
            for lexicalToken in Self.parseOrder {
                if let range = substring.range(of: "^(\(lexicalToken.necessaryRegularExpression))", options: .regularExpression) {
                    let tokenString = String(substring[range])
                    lexicalTokens.append((lexicalToken, tokenString))
                    substring = substring[range.upperBound...]
                    break
                }
            }
        }
        return Self.createList(from: lexicalTokens)
    }
}
