//
//  MarkupQuote.swift
//  MarkupQuote
//
//  Created by ensan on 2021/09/11.
//

import SwiftUI

public struct MarkupQuote: MarkupView {
    @Environment(\.quoteStyle) private var quoteStyle
    public enum Level: Int {
        case one = 1, two, three, four, five, six
    }
    private var text: LocalizedStringKey
    private var level: Level
    public init(verbatim text: String, level: Level) {
        self.text = LocalizedStringKey(text)
        self.level = level
    }
    public init(_ text: LocalizedStringKey, level: Level) {
        self.text = text
        self.level = level
    }
    public var body: some View {
        quoteStyle.makeBody(Text(self.text), level: level.rawValue)
    }
}

public protocol QuoteStyle {
    associatedtype Body: View
    func makeBody(_ item: Text, level: Int) -> Body
}

public struct DefaultQuoteStyle: QuoteStyle {
    public func makeBody(_ item: Text, level: Int) -> some View {
        HStack {
            ForEach (0 ..< level) { _ in
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: 4)
                    .frame(height: 20)
            }
            item
                .foregroundColor(.gray)
        }
    }
}

private struct AnyQuoteStyle: QuoteStyle {
    private let makeBody: (Text, Int) -> AnyView
    init<S: QuoteStyle>(_ style: S) {
        self.makeBody = { item, level in AnyView(style.makeBody(item, level: level))}
    }
    func makeBody(_ item: Text, level: Int) -> some View {
        self.makeBody(item, level)
    }
}

private extension EnvironmentValues {
    var quoteStyle: AnyQuoteStyle {
        get { self[QuoteStyleKey.self] }
        set { self[QuoteStyleKey.self] = newValue }
    }
}
private struct QuoteStyleKey: EnvironmentKey {
    static let defaultValue: AnyQuoteStyle = .init(.default)
}

public extension QuoteStyle where Self == DefaultQuoteStyle {
    static var `default`: Self { Self() }
}

public extension View {
    func quoteStyle<S: QuoteStyle>(_ style: S) -> some View {
        self.environment(\.quoteStyle, .init(style))
    }
}

prefix operator >
public prefix func >(value: LocalizedStringKey) -> MarkupQuote {
    return .init(value, level: .one)
}

prefix operator >>
public prefix func >>(value: LocalizedStringKey) -> MarkupQuote {
    return .init(value, level: .two)
}

prefix operator >>>
public prefix func >>>(value: LocalizedStringKey) -> MarkupQuote {
    return .init(value, level: .three)
}

prefix operator >>>>
public prefix func >>>>(value: LocalizedStringKey) -> MarkupQuote {
    return .init(value, level: .four)
}

prefix operator >>>>>
public prefix func >>>>>(value: LocalizedStringKey) -> MarkupQuote {
    return .init(value, level: .five)
}

prefix operator >>>>>>
public prefix func >>>>>>(value: LocalizedStringKey) -> MarkupQuote {
    return .init(value, level: .six)
}
