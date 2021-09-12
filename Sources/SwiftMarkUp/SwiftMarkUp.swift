//
//  SwiftMarkUp.swift
//  SwiftMarkUp
//
//  Created by ensan on 2021/09/11.
//

import SwiftUI

@available(iOS 15, macOS 12, watchOS 8, tvOS 15, *)
struct TestView: View {
    @State private var isOK = false
    var body: some View {
        MarkUp(alignment: .leading) {
            -"Header"                                                                 // for <h1>
            "This is normal text."                                                    // for normal <p>
            --"Header2"                                                               // for <h2>
            "\(*"italic"), \(**"bold"), \(***"bold italic"), and \(</>"code")."       // styles
            **"This is bold text."                                                    // whole <b>
            ---"Header \(*"3")"                                                       // for <h3>
            >"Quote here"                                                             // for <quote>
            "swift"</>"""
            prefix operator -
            prefix func -(value: LocalizedStringKey) -> MarkUpHeader {
                return .init(value, level: .one)
            }
            """
            let appleLink = "https://www.apple.com/"
            |"Let's see \("Apple.com" | appleLink)"                                   // tabbed link
            if isOK {
                ***"If can be used"
            } else {
                ***"Else can be used"
            }
        }
        Toggle("Toggle me!", isOn: $isOK)
            .toggleStyle(.automatic)
    }
}

