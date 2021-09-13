import XCTest
import SwiftUI
@testable import SwiftMarkUp

// this test includes compile test, which would fail if an operator has collision with other Swift operators
final class MarkUpBuildersTests: XCTestCase {

    @ViewBuilder func complileTestOperators() -> some View {
        MarkUp {
            // MARK: Check link operator
            if #available(iOS 15, macOS 12, watchOS 8, tvOS 15, *) {
                "link operator compile is now failing"
                //"foo" | "bar"
                //"\("foo"|"bar")"
            }

            // MARK: Check emphasis operators
            MarkUp {
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
            MarkUp {
                |"foo"
                ||"foo"
                |||"foo"
                ||||"foo"
                |||||"foo"
                ||||||"foo"
            }
            // MARK: Check header operators
            MarkUp {
                -"foo"
                --"foo"
                ---"foo"
                ----"foo"
                -----"foo"
                ------"foo"
            }

            // MARK: Check quote operators
            MarkUp {
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
        MarkUp {
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

