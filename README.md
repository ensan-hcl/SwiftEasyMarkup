# SwiftMarkUp

A mark-up DSL created in Swift for SwiftUI.

SwiftMarkUp version: 0.1.0

Swift version: 5.5

## Features

SwiftMarkUp can handle styles in a way which is similar to Markdown format.

```swift
MarkUp(alignment: .leading) {
    -"Header"                                                                 // h1
    "This is normal text."                                                    // p
    --"Header2"                                                               // h2
    "\(*"italic"), \(**"bold"), \(***"bold italic"), and \(</>"code")."       // styles
    **"This is bold text."                                                    // b
    ---"Header \(*"3")"                                                       // h3 and partial italic
    >"Quote here"                                                             // quote
    // code block with syntax highlight
    "swift"</>"""
    print("Hello World"!)
    """
    let appleLink = "https://www.apple.com/"                                  // declare constants
    |"Let's see \("Apple.com" | appleLink)"                                   // link and tab
    if isOK {                                                                 // if handling
        ***"If can be used"
    } else {
        ***"Else can be used"
    }
}
```

## Implementation

SwiftMarkUp uses result builders to achieve declarative mark-up, and using operators to support markdown like syntax. It also uses custom StringInterpolation to support partial styling.

It now depends on SwiftUI and some new features on iOS14/macOS11. Therefore it requires these environments. Using syntax highlights also requiers iOS15/macOS12.  

## Todos

SwiftMarkup is now working in progress. It requires:

* Make design injectable with SwiftUI like syntax for MarkUp
* Add more support of syntax highlights
* Add support for environments where SwiftUI cannot be used
