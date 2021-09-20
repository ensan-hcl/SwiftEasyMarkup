//
//  SyntaxHighlight.swift
//  SyntaxHighlight
//
//  Created by ensan on 2021/09/11.
//

import Foundation
import SwiftUI

@available(iOS 15, macOS 12, watchOS 8, tvOS 15, *)
public struct SyntaxHighlighter<Parser: SyntaxParser> {
    private var parser: Parser
    public init(parser: Parser) {
        self.parser = parser
    }
    public func highlight<Design: SyntaxHighlightDesign>(code: String, design: Design) -> AttributedString where Design.Token == Parser.SemanticToken {
        let attributedStrings = parse(code: code).map{design.attribute(token: $0, string: $1)}
        return attributedStrings.reduce(AttributedString(""), +)
    }
    func parse(code: String) -> [(token: Parser.SemanticToken, string: String)] {
        var substring = code[...]
        let lexicalTokens = parser.lex(code: &substring, target: .top)
        return parser.semantify(from: lexicalTokens)
    }
}

public protocol SyntaxParser {
    associatedtype ParseContext: SyntaxParserParseContext
    associatedtype SemanticToken
    func lex(code: inout Substring, target: ParseContext) -> [(ParseContext.LexicalToken, String)]
    func semantify(from lexicalTokens: [(token: ParseContext.LexicalToken, string: String)]) -> [(token: SemanticToken, string: String)]
}

public protocol SyntaxParserParseContext {
    associatedtype LexicalToken
    static var top: Self { get }
}

@available(iOS 15, macOS 12, watchOS 8, tvOS 15, *)
public protocol SyntaxHighlightDesign {
    associatedtype Token
    func attribute(token: Token, string: String) -> AttributedString
}
