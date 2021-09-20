//
//  MarkUpHeader.swift
//  MarkUpHeader
//
//  Created by ensan on 2021/09/11.
//

import SwiftUI

public struct MarkUpHeader: MarkUpView {
    @Environment(\.headerStyle) private var headerStyle
    public enum Level {
        case one, two, three, four, five, six
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
        headerStyle.makeBody(Text(self.text), level: self.level)
    }
}

public protocol HeaderStyle {
    associatedtype Body: View
    func makeBody(_ item: Text, level: MarkUpHeader.Level) -> Body
}

public struct DefaultHeaderStyle: HeaderStyle {
    func font(level: MarkUpHeader.Level) -> Font {
        switch level {
        case .one: return .largeTitle
        case .two: return .title
        case .three: return .title2
        case .four: return .title3
        case .five: return .headline
        case .six: return .subheadline
        }
    }
    public func makeBody(_ item: Text, level: MarkUpHeader.Level) -> some View {
        item
            .font(font(level: level))
    }
}

private struct AnyHeaderStyle: HeaderStyle {
    private let makeBody: (Text, MarkUpHeader.Level) -> AnyView
    init<S: HeaderStyle>(_ style: S) {
        self.makeBody = { item, level in AnyView(style.makeBody(item, level: level))}
    }
    func makeBody(_ item: Text, level: MarkUpHeader.Level) -> some View {
        self.makeBody(item, level)
    }
}

private extension EnvironmentValues {
    var headerStyle: AnyHeaderStyle {
        get { self[HeaderStyleKey.self] }
        set { self[HeaderStyleKey.self] = newValue }
    }
}
private struct HeaderStyleKey: EnvironmentKey {
    static let defaultValue: AnyHeaderStyle = .init(.default)
}

public extension HeaderStyle where Self == DefaultHeaderStyle {
    static var `default`: Self { Self() }
}

public extension View {
    func headerStyle<S: HeaderStyle>(_ style: S) -> some View {
        self.environment(\.headerStyle, .init(style))
    }
}

prefix operator -
public prefix func -(value: LocalizedStringKey) -> MarkUpHeader {
    return .init(value, level: .one)
}

prefix operator --
public prefix func --(value: LocalizedStringKey) -> MarkUpHeader {
    return .init(value, level: .two)
}

prefix operator ---
public prefix func ---(value: LocalizedStringKey) -> MarkUpHeader {
    return .init(value, level: .three)
}

prefix operator ----
public prefix func ----(value: LocalizedStringKey) -> MarkUpHeader {
    return .init(value, level: .four)
}

prefix operator -----
public prefix func -----(value: LocalizedStringKey) -> MarkUpHeader {
    return .init(value, level: .five)
}

prefix operator ------
public prefix func ------(value: LocalizedStringKey) -> MarkUpHeader {
    return .init(value, level: .six)
}
