//
//  MarkUpText.swift
//  MarkUpText
//
//  Created by ensan on 2021/09/11.
//

import SwiftUI

struct MarkUpText: MarkUpView {
    enum Level: Int {
        case one = 1, two, three, four, five, six
    }
    private var text: Text
    private var level: Level
    init(verbatim text: String, level: Level = .one) {
        self.text = Text(LocalizedStringKey(text))
        self.level = level
    }
    init(text: Text, level: Level = .one) {
        self.text = text
        self.level = level
    }
    init(_ text: LocalizedStringKey, level: Level = .one) {
        self.text = Text(text)
        self.level = level
    }
    var body: some View {
        self.text
            .padding(.leading, Double(self.level.rawValue) * 20)
    }
}

prefix operator |
prefix func |(value: LocalizedStringKey) -> MarkUpText {
    return .init(value, level: .one)
}

prefix operator ||
prefix func ||(value: LocalizedStringKey) -> MarkUpText {
    return .init(value, level: .two)
}

prefix operator |||
prefix func |||(value: LocalizedStringKey) -> MarkUpText {
    return .init(value, level: .three)
}

prefix operator ||||
prefix func ||||(value: LocalizedStringKey) -> MarkUpText {
    return .init(value, level: .four)
}

prefix operator |||||
prefix func |||||(value: LocalizedStringKey) -> MarkUpText {
    return .init(value, level: .five)
}

prefix operator ||||||
prefix func ||||||(value: LocalizedStringKey) -> MarkUpText {
    return .init(value, level: .six)
}
