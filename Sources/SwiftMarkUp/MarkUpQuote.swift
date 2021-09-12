//
//  MarkUpQuote.swift
//  MarkUpQuote
//
//  Created by ensan on 2021/09/11.
//

import SwiftUI

struct MarkUpQuote: MarkUpView {
    enum Level: Int {
        case one = 1, two, three, four, five, six
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
prefix func >(value: LocalizedStringKey) -> MarkUpQuote {
    return .init(value, level: .one)
}

prefix operator >>
prefix func >>(value: LocalizedStringKey) -> MarkUpQuote {
    return .init(value, level: .two)
}

prefix operator >>>
prefix func >>>(value: LocalizedStringKey) -> MarkUpQuote {
    return .init(value, level: .three)
}

prefix operator >>>>
prefix func >>>>(value: LocalizedStringKey) -> MarkUpQuote {
    return .init(value, level: .four)
}

prefix operator >>>>>
prefix func >>>>>(value: LocalizedStringKey) -> MarkUpQuote {
    return .init(value, level: .five)
}

prefix operator >>>>>>
prefix func >>>>>>(value: LocalizedStringKey) -> MarkUpQuote {
    return .init(value, level: .six)
}
