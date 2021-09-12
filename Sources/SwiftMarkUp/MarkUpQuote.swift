//
//  MarkUpQuote.swift
//  MarkUpQuote
//
//  Created by ensan on 2021/09/11.
//

import SwiftUI

public struct MarkUpQuote: MarkUpView {
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
        HStack {
            ForEach (0 ..< level.rawValue) { _ in
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: 4)
                    .frame(height: 20)
            }
            Text(self.text)
                .foregroundColor(.gray)
        }
    }
}


prefix operator >
public prefix func >(value: LocalizedStringKey) -> MarkUpQuote {
    return .init(value, level: .one)
}

prefix operator >>
public prefix func >>(value: LocalizedStringKey) -> MarkUpQuote {
    return .init(value, level: .two)
}

prefix operator >>>
public prefix func >>>(value: LocalizedStringKey) -> MarkUpQuote {
    return .init(value, level: .three)
}

prefix operator >>>>
public prefix func >>>>(value: LocalizedStringKey) -> MarkUpQuote {
    return .init(value, level: .four)
}

prefix operator >>>>>
public prefix func >>>>>(value: LocalizedStringKey) -> MarkUpQuote {
    return .init(value, level: .five)
}

prefix operator >>>>>>
public prefix func >>>>>>(value: LocalizedStringKey) -> MarkUpQuote {
    return .init(value, level: .six)
}
