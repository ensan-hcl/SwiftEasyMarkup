//
//  MarkUpBuilder.swift
//  MarkUpBuilder
//
//  Created by ensan on 2021/09/11.
//

import SwiftUI

struct MarkUp<Content: MarkUpView>: View {
    private var alignment: HorizontalAlignment
    private var contents: () -> Content
    init(alignment: HorizontalAlignment = .center, @MarkUpBuilder contents: @escaping () -> Content) {
        self.alignment = alignment
        self.contents = contents
    }
    var body: some View {
        VStack (alignment: alignment) {
            contents()
        }
    }
}

protocol MarkUpView: View {}

extension Group: MarkUpView where Content: View {}

@resultBuilder
struct MarkUpBuilder {
    static func buildBlock<T0: MarkUpView> (_ t0: T0) -> some MarkUpView {
        return t0
    }
    static func buildBlock<T0: MarkUpView, T1: MarkUpView> (_ t0: T0, _ t1: T1) -> some MarkUpView {
        return Group {
            t0
            t1
        }
    }
    static func buildBlock<T0: MarkUpView, T1: MarkUpView, T2: MarkUpView> (_ t0: T0, _ t1: T1, _ t2: T2) -> some MarkUpView {
        return Group {
            t0
            t1
            t2
        }
    }
    static func buildBlock<T0: MarkUpView, T1: MarkUpView, T2: MarkUpView, T3: MarkUpView> (_ t0: T0, _ t1: T1, _ t2: T2, _ t3: T3) -> some MarkUpView {
        return Group {
            t0
            t1
            t2
            t3
        }
    }
    static func buildBlock<T0: MarkUpView, T1: MarkUpView, T2: MarkUpView, T3: MarkUpView, T4: MarkUpView> (_ t0: T0, _ t1: T1, _ t2: T2, _ t3: T3, _ t4: T4) -> some MarkUpView {
        return Group {
            t0
            t1
            t2
            t3
            t4
        }
    }
    static func buildBlock<T0: MarkUpView, T1: MarkUpView, T2: MarkUpView, T3: MarkUpView, T4: MarkUpView, T5: MarkUpView> (_ t0: T0, _ t1: T1, _ t2: T2, _ t3: T3, _ t4: T4, _ t5: T5) -> some MarkUpView {
        return Group {
            t0
            t1
            t2
            t3
            t4
            t5
        }
    }
    static func buildBlock<T0: MarkUpView, T1: MarkUpView, T2: MarkUpView, T3: MarkUpView, T4: MarkUpView, T5: MarkUpView, T6: MarkUpView> (_ t0: T0, _ t1: T1, _ t2: T2, _ t3: T3, _ t4: T4, _ t5: T5, _ t6: T6) -> some MarkUpView {
        return Group {
            t0
            t1
            t2
            t3
            t4
            t5
            t6
        }
    }

    static func buildBlock<T0: MarkUpView, T1: MarkUpView, T2: MarkUpView, T3: MarkUpView, T4: MarkUpView, T5: MarkUpView, T6: MarkUpView, T7: MarkUpView> (_ t0: T0, _ t1: T1, _ t2: T2, _ t3: T3, _ t4: T4, _ t5: T5, _ t6: T6, _ t7: T7) -> some MarkUpView {
        return Group {
            t0
            t1
            t2
            t3
            t4
            t5
            t6
            t7
        }
    }

    static func buildBlock<T0: MarkUpView, T1: MarkUpView, T2: MarkUpView, T3: MarkUpView, T4: MarkUpView, T5: MarkUpView, T6: MarkUpView, T7: MarkUpView, T8: MarkUpView> (_ t0: T0, _ t1: T1, _ t2: T2, _ t3: T3, _ t4: T4, _ t5: T5, _ t6: T6, _ t7: T7, _ t8: T8) -> some MarkUpView {
        return Group {
            t0
            t1
            t2
            t3
            t4
            t5
            t6
            t7
            t8
        }
    }

    static func buildBlock<T0: MarkUpView, T1: MarkUpView, T2: MarkUpView, T3: MarkUpView, T4: MarkUpView, T5: MarkUpView, T6: MarkUpView, T7: MarkUpView, T8: MarkUpView, T9: MarkUpView> (_ t0: T0, _ t1: T1, _ t2: T2, _ t3: T3, _ t4: T4, _ t5: T5, _ t6: T6, _ t7: T7, _ t8: T8, _ t9: T9) -> some MarkUpView {
        return Group {
            t0
            t1
            t2
            t3
            t4
            t5
            t6
            t7
            t8
            t9
        }
    }

    static func buildEither<T0: MarkUpView>(first t0: T0) -> T0 {
        return t0
    }

    static func buildEither<T0: MarkUpView>(second t0: T0) -> T0 {
        return t0
    }

    static func buildLimitedAvailability<T0: MarkUpView>(_ t0: T0) -> T0 {
        return t0
    }

    static func buildExpression(_ expression: LocalizedStringKey) -> MarkUpText {
        return MarkUpText(expression)
    }

    static func buildExpression<T0: MarkUpView>(_ expression: T0) -> T0 {
        return expression
    }

}

