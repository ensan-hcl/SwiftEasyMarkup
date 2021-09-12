//
//  MarkUpHeader.swift
//  MarkUpHeader
//
//  Created by ensan on 2021/09/11.
//

import SwiftUI

struct MarkUpHeader: MarkUpView {
    enum Level {
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
    init(verbatim text: String, level: Level) {
        self.text = LocalizedStringKey(text)
        self.level = level
    }
    init(_ text: LocalizedStringKey, level: Level) {
        self.text = text
        self.level = level
    }
    var body: some View {
        Text(self.text)
            .font(self.level.font)
    }
}

prefix operator -
prefix func -(value: LocalizedStringKey) -> MarkUpHeader {
    return .init(value, level: .one)
}

prefix operator --
prefix func --(value: LocalizedStringKey) -> MarkUpHeader {
    return .init(value, level: .two)
}

prefix operator ---
prefix func ---(value: LocalizedStringKey) -> MarkUpHeader {
    return .init(value, level: .three)
}

prefix operator ----
prefix func ----(value: LocalizedStringKey) -> MarkUpHeader {
    return .init(value, level: .four)
}

prefix operator -----
prefix func -----(value: LocalizedStringKey) -> MarkUpHeader {
    return .init(value, level: .five)
}

prefix operator ------
prefix func ------(value: LocalizedStringKey) -> MarkUpHeader {
    return .init(value, level: .six)
}
