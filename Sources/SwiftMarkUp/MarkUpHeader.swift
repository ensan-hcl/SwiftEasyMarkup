//
//  MarkUpHeader.swift
//  MarkUpHeader
//
//  Created by ensan on 2021/09/11.
//

import SwiftUI

public struct MarkUpHeader: MarkUpView {
    public enum Level {
        case one, two, three, four, five, six
        var font: Font {
            switch self {
            case .one: return .largeTitle
            case .two: return .title
            case .three: return .title2
            case .four: return .title3
            case .five: return .headline
            case .six: return .subheadline
            }
        }
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
        Text(self.text)
            .font(self.level.font)
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
