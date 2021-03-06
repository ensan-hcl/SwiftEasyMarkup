import XCTest
import SwiftUI
@testable import SwiftEasyMarkup

// this test includes compile test, which would fail if an operator has collision with other Swift operators
final class MarkupBuildersTests: XCTestCase {

    @ViewBuilder func complileTestStyles() -> some View {
        // MARK: Check header styles
        Markup {
            -"foo"
            --"foo"
            ---"foo"
            ----"foo"
            -----"foo"
            ------"foo"
        }
        .headerStyle(.default)

        // MARK: Check quote styles
        Markup {
            >"foo"
            >>"foo"
            >>>"foo"
            >>>>"foo"
            >>>>>"foo"
            >>>>>>"foo"
        }
        .quoteStyle(.default)
    }
    
    @ViewBuilder func complileTestOperators() -> some View {
        Markup {
            // MARK: Check link operator
            if #available(iOS 15, macOS 12, watchOS 8, tvOS 15, *) {
                "foo" ~~ "bar"
                "\("foo"~~"bar")"
            }

            // MARK: Check emphasis operators
            Markup {
                *"foo"
                "\(*"foo")"

                **"foo"
                "\(**"foo")"

                ***"foo"
                "\(***"foo")"
            }

            // MARK: Check monospace operator
            if #available(iOS 15, macOS 12, watchOS 8, tvOS 15, *) {
                </>"foo"
                "\(</>"foo")"
                "lang"</>"code"
            }

            // MARK: Check tab operators
            Markup {
                |"foo"
                ||"foo"
                |||"foo"
                ||||"foo"
                |||||"foo"
                ||||||"foo"
            }
            // MARK: Check header operators
            Markup {
                -"foo"
                --"foo"
                ---"foo"
                ----"foo"
                -----"foo"
                ------"foo"
            }

            // MARK: Check quote operators
            Markup {
                >"foo"
                >>"foo"
                >>>"foo"
                >>>>"foo"
                >>>>>"foo"
                >>>>>>"foo"
            }
        }
    }
    private let bool1 = Bool.random()
    private let bool2 = Bool.random()

    @ViewBuilder func complileTestIfs() -> some View {
        Markup {
            // MARK: Check optional if
            if self.bool1 {
                "foo"
            }
            if self.bool1 {
                "foo"
            } else {
                "bar"
            }
            if self.bool1 {
                "foo"
            } else if self.bool2 {
                "bar"
            } else {
                "baz"
            }
            switch (self.bool1, self.bool2) {
            case (true, true): "foo"
            case (true, false): "bar"
            case (false, true): "baz"
            case (false, false): "cuz"
            }
            if #available(iOS 9999, *) {
                "Wow, are you in the year 12005??? How are you doing?"
            }
            if #available(iOS 5, *) {
                "OK"
            } else {
                "You're still using an operating system that predates iOS5 in 2021! Incredible!"
            }
        }
    }

    func testCompile() throws {
        let _ = complileTestOperators()
        let _ = complileTestIfs()
    }
}

