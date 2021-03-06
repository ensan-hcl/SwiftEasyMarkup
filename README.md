# SwiftEasyMarkup

A markup DSL created in Swift for SwiftUI.

SwiftEasyMarkup version: 0.3.0

Swift version: 5.5

## Features

SwiftEasyMarkup can handle styles in a way which is similar to Markdown format.

* Clear syntax powered by operators and string interpolations 
* Links, *Italic*, **Bold**, and `Code`
* Headers, Quote block, tabbed block, and Code block with syntax highlight
* Condition-dependent text with `if` and `switch` statements
* Design injection with SwiftUI like `.fooStyle(.style)` syntax

```swift
Markup(alignment: .leading) {
    -"Header"                                                                 // h1
    "This is normal text."                                                    // p
    --"Header2"                                                               // h2
    "\(*"italic"), \(**"bold"), \(***"bold italic"), and \(</>"code")."       // styles
    **"This is bold text."                                                    // b
    ---"Header \(*"3")"                                                       // h3 and partial italic
    >"Quote here"                                                             // quote
    // code block with syntax highlight
    "swift"</>"""
    // Convert number into Japnaese Kansuji
    let formatter = NumberFormatter()
    formatter.numberStyle = .spellOut
    formatter.locale = .init(identifier: "ja-JP")
    let number = 123456789012345678
    if let string = formatter.string(from: NSNumber(value: number)){
        print(string)   //十二京三千四百五十六兆七千八百九十億千二百三十四万五千六百七十八
    }
    """
    let appleLink = "https://www.apple.com/"                                  // declare constants
    |"Let's see \("Apple.com" ~~ appleLink)"                                  // link and tab
    if isOK {                                                                 // if handling
        ***"You can use if statements"
        if #available(iOS 15, *) {
            "You can also use #available checking"
        }
    } else {
        ***"Else can be used"
    }
}
```

## Implementation

SwiftEasyMarkup uses result builders to achieve declarative markup, and using operators to support markdown like syntax. It also uses custom StringInterpolation to support partial styling.

It now depends on SwiftUI and some new features on iOS14/macOS11/watchOS7/tvOS14. Therefore it requires these environments. Using some features also requiers iOS15/macOS12/watchOS8/tvOS15.  

## Todos

SwiftEasyMarkup is now working in progress. It requires:

* Add more supports of syntax highlights
* Add support for environments where SwiftUI cannot be used
