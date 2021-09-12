//
//  MarkUpText.swift
//  MarkUpText
//
//  Created by ensan on 2021/09/11.
//

import SwiftUI

public struct MarkUpText: MarkUpView {
    public enum Level: Int {
        case one = 1, two, three, four, five, six
    }
    private var text: Text
    private var level: Level
    public init(verbatim text: String, level: Level = .one) {
        self.text = Text(LocalizedStringKey(text))
        self.level = level
    }
    public init(text: Text, level: Level = .one) {
        self.text = text
        self.level = level
    }
    public init(_ text: LocalizedStringKey, level: Level = .one) {
        self.text = Text(text)
        self.level = level
    }
    public var body: some View {
        self.text
            .padding(.leading, Double(self.level.rawValue) * 20)
    }
}

prefix operator |
public prefix func |(value: LocalizedStringKey) -> MarkUpText {
    return .init(value, level: .one)
}

prefix operator ||
public prefix func ||(value: LocalizedStringKey) -> MarkUpText {
    return .init(value, level: .two)
}

prefix operator |||
public prefix func |||(value: LocalizedStringKey) -> MarkUpText {
    return .init(value, level: .three)
}

prefix operator ||||
public prefix func ||||(value: LocalizedStringKey) -> MarkUpText {
    return .init(value, level: .four)
}

prefix operator |||||
public prefix func |||||(value: LocalizedStringKey) -> MarkUpText {
    return .init(value, level: .five)
}

prefix operator ||||||
public prefix func ||||||(value: LocalizedStringKey) -> MarkUpText {
    return .init(value, level: .six)
}
