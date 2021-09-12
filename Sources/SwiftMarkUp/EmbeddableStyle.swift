//
//  EmbeddableStyle.swift
//  EmbeddableStyle
//
//  Created by ensan on 2021/09/11.
//

import Foundation
import SwiftUI

prefix operator *
prefix operator **
prefix operator ***

public prefix func * (value: LocalizedStringKey) -> StyledTexts.Italic {
    return .init(value: value)
}
public prefix func ** (value: LocalizedStringKey) -> StyledTexts.Bold {
    return .init(value: value)
}
public prefix func *** (value: LocalizedStringKey) -> StyledTexts.BoldItalic {
    return .init(value: value)
}

infix operator |

@available(iOS 15, macOS 12, watchOS 8, tvOS 15, *)
public func | (lhs: String, rhs: String) -> StyledTexts.Link {
    var attributedString = AttributedString(lhs)
    let range = Range(uncheckedBounds: (attributedString.startIndex, attributedString.endIndex))
    attributedString[range].link = URL(string: rhs)
    return .init(link: attributedString)
}

prefix operator </>
public prefix func </>(value: LocalizedStringKey) -> StyledTexts.Code {
    return .init(code: Text(value))
}

infix operator </>
@available(iOS 15, macOS 12, watchOS 8, tvOS 15, *)
public func </>(language: String, code: String) -> StyledTexts.Code {
    switch language {
    case "swift":
        let highlighted = SyntaxHighlighter(parser: .swift).highlight(code: code, design: .swiftDefault)
        return .init(code: Text(highlighted))
    default: return .init(code: Text(code))
    }
}

public protocol EmbeddableText {
    func appendInterpolation(to interpolation: inout LocalizedStringKey.StringInterpolation)
}

public enum StyledTexts {
    public struct Bold: MarkUpView, EmbeddableText {
        let value: LocalizedStringKey
        public func appendInterpolation(to interpolation: inout LocalizedStringKey.StringInterpolation) {
            interpolation.appendInterpolation(body)
        }
        public var body: Text {
            Text(value).bold()
        }
    }
    public struct Italic: MarkUpView, EmbeddableText {
        public typealias Body = Text
        let value: LocalizedStringKey
        public func appendInterpolation(to interpolation: inout LocalizedStringKey.StringInterpolation) {
            interpolation.appendInterpolation(body)
        }
        public var body: Text {
            Text(value).italic()
        }
    }
    public struct BoldItalic: MarkUpView, EmbeddableText {
        public typealias Body = Text
        let value: LocalizedStringKey
        public func appendInterpolation(to interpolation: inout LocalizedStringKey.StringInterpolation) {
            interpolation.appendInterpolation(body)
        }
        public var body: Text {
            Text(value).bold().italic()
        }
    }
    @available(iOS 15, macOS 12, watchOS 8, tvOS 15, *)
    public struct Link: MarkUpView, EmbeddableText {
        public typealias Body = Text
        let link: AttributedString
        public func appendInterpolation(to interpolation: inout LocalizedStringKey.StringInterpolation) {
            interpolation.appendInterpolation(link)
        }
        public var body: Text {
            Text(link)
        }
    }
    public struct Code: MarkUpView, EmbeddableText {
        @Environment(\.colorScheme) private var colorScheme
        private var backgroundColor: Color {
            switch colorScheme {
            case .light:
                return .init(white: 0.95)
            case .dark:
                return .init(white: 0.15)
            @unknown default:
                return .init(white: 0.95)
            }
        }
        let code: Text
        public func appendInterpolation(to interpolation: inout LocalizedStringKey.StringInterpolation) {
            let font: Font = .system(.body, design: .monospaced)
            interpolation.appendInterpolation(code.font(font))
        }
        public var body: some View {
            ScrollView(.horizontal) {
                code
                    .font(.system(.body, design: .monospaced))
                    .padding(5)
                    .background(Rectangle().fill(backgroundColor))
            }
        }
    }
}

public extension LocalizedStringKey.StringInterpolation {
    mutating func appendInterpolation<T: EmbeddableText>(_ text: T) {
        text.appendInterpolation(to: &self)
    }
}
