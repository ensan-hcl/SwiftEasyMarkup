//
//  MarkupBuilder.swift
//  MarkupBuilder
//
//  Created by ensan on 2021/09/11.
//

import SwiftUI

public struct Markup<Content: MarkupView>: MarkupView {
    private var alignment: HorizontalAlignment
    private var contents: () -> Content
    public init(alignment: HorizontalAlignment = .center, @MarkupBuilder contents: @escaping () -> Content) {
        self.alignment = alignment
        self.contents = contents
    }
    public var body: some View {
        VStack (alignment: alignment) {
            contents()
        }
    }
}

public protocol MarkupView: View {}

extension EmptyView: MarkupView {}
extension AnyView: MarkupView {}
extension Group: MarkupView where Content: View {}
public struct _EitherView<First: MarkupView, Second: MarkupView>: MarkupView  {
    enum Either {
        case first(() -> First)
        case second(() -> Second)
    }
    init(@ViewBuilder first: @escaping () -> First) {
        self.content = .first(first)
    }
    init(@ViewBuilder second: @escaping () -> Second) {
        self.content = .second(second)
    }
    let content: Either

    public var body: some View {
        switch content {
        case let .first(content):
            content()
        case let .second(content):
            content()
        }
    }
}

@resultBuilder
public struct MarkupBuilder {
    public static func buildBlock<T0: MarkupView> (_ t0: T0) -> some MarkupView {
        return t0
    }

    public static func buildBlock<T0: MarkupView, T1: MarkupView> (_ t0: T0, _ t1: T1) -> some MarkupView {
        return Group {
            t0
            t1
        }
    }

    public static func buildBlock<T0: MarkupView, T1: MarkupView, T2: MarkupView> (_ t0: T0, _ t1: T1, _ t2: T2) -> some MarkupView {
        return Group {
            t0
            t1
            t2
        }
    }

    public static func buildBlock<T0: MarkupView, T1: MarkupView, T2: MarkupView, T3: MarkupView> (_ t0: T0, _ t1: T1, _ t2: T2, _ t3: T3) -> some MarkupView {
        return Group {
            t0
            t1
            t2
            t3
        }
    }

    public static func buildBlock<T0: MarkupView, T1: MarkupView, T2: MarkupView, T3: MarkupView, T4: MarkupView> (_ t0: T0, _ t1: T1, _ t2: T2, _ t3: T3, _ t4: T4) -> some MarkupView {
        return Group {
            t0
            t1
            t2
            t3
            t4
        }
    }

    public static func buildBlock<T0: MarkupView, T1: MarkupView, T2: MarkupView, T3: MarkupView, T4: MarkupView, T5: MarkupView> (_ t0: T0, _ t1: T1, _ t2: T2, _ t3: T3, _ t4: T4, _ t5: T5) -> some MarkupView {
        return Group {
            t0
            t1
            t2
            t3
            t4
            t5
        }
    }

    public static func buildBlock<T0: MarkupView, T1: MarkupView, T2: MarkupView, T3: MarkupView, T4: MarkupView, T5: MarkupView, T6: MarkupView> (_ t0: T0, _ t1: T1, _ t2: T2, _ t3: T3, _ t4: T4, _ t5: T5, _ t6: T6) -> some MarkupView {
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

    public static func buildBlock<T0: MarkupView, T1: MarkupView, T2: MarkupView, T3: MarkupView, T4: MarkupView, T5: MarkupView, T6: MarkupView, T7: MarkupView> (_ t0: T0, _ t1: T1, _ t2: T2, _ t3: T3, _ t4: T4, _ t5: T5, _ t6: T6, _ t7: T7) -> some MarkupView {
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

    public static func buildBlock<T0: MarkupView, T1: MarkupView, T2: MarkupView, T3: MarkupView, T4: MarkupView, T5: MarkupView, T6: MarkupView, T7: MarkupView, T8: MarkupView> (_ t0: T0, _ t1: T1, _ t2: T2, _ t3: T3, _ t4: T4, _ t5: T5, _ t6: T6, _ t7: T7, _ t8: T8) -> some MarkupView {
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

    public static func buildBlock<T0: MarkupView, T1: MarkupView, T2: MarkupView, T3: MarkupView, T4: MarkupView, T5: MarkupView, T6: MarkupView, T7: MarkupView, T8: MarkupView, T9: MarkupView> (_ t0: T0, _ t1: T1, _ t2: T2, _ t3: T3, _ t4: T4, _ t5: T5, _ t6: T6, _ t7: T7, _ t8: T8, _ t9: T9) -> some MarkupView {
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

    public static func buildOptional<T0: MarkupView>(_ t0: T0?) -> _EitherView<T0, EmptyView> {
        if let t0 = t0 {
            return _EitherView {
                t0
            }
        } else {
            return _EitherView {
                EmptyView()
            }
        }
    }

    public static func buildEither<First: MarkupView, Second: MarkupView>(first: First) -> _EitherView<First, Second> {
        _EitherView {
            first
        }
    }

    public static func buildEither<First: MarkupView, Second: MarkupView>(second: Second) -> _EitherView<First, Second> {
        _EitherView {
            second
        }
    }

    public static func buildLimitedAvailability<T0: MarkupView>(_ t0: T0) -> AnyView {
        return AnyView(t0)
    }

    public static func buildExpression(_ expression: LocalizedStringKey) -> MarkupText {
        return MarkupText(expression)
    }

    public static func buildExpression<T0: MarkupView>(_ expression: T0) -> T0 {
        return expression
    }

}


