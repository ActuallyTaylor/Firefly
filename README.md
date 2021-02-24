<p align="center">
    <img src="/Icon.png" alt="Firefly logo" width="128" maxHeight=“128" />
</p>

<p align="center">
    <img src="https://img.shields.io/badge/iOS-13.0+-green.svg" />
    <img src="https://img.shields.io/badge/Swift-5.3-orange.svg" />
    <a href="https://twitter.com/LinemanZachary">
        <img src="https://img.shields.io/badge/Contact-@LinemanZachary-blue.svg?style=flat" alt="Twitter: @LinemanZachary" />
    </a>
</p>

# Firefly
Firefly is a pure swift iOS syntax highlighter based of off [Sourceful](https://github.com/twostraws/Sourceful), [SavannaKit](https://github.com/louisdh/savannakit), [SyntaxKit](https://github.com/palle-k/SyntaxKit), and previously [Highlightr](https://github.com/raspu/Highlightr). Highlighter has since been remove from the project in favor of a pure swift solution.
### Issues
Issues are hosted on both this repo and the [Jellycuts Issue Repo](https://github.com/ActuallyZach/Jellycuts-Issues/issues/30). This is done because a lot of issues that occur with Firefly are reported through Jellycuts and it does not make sense to mirror them across to this repo. 

# How does Firefly Work?
Firefly is written in pure swift, and uses NSRegularExpressions for detecting tokens to highlight. Once tokens are detected they are colored based on the current theme.

# Using Firefly in your project
If you are going to use Firefly in your project, I request that you include a link back to this github page somewhere. If you would like to you can also [email me](mailto:zachary.lineman@gmail.com) and I will add you into the list of apps that use Firefly on this page.

# About this project
This project is was inspired by Paul Hudson’s (@twostraws) Sourceful syntax highlighter and Highlightr by J.P Illanes (@raspu). Sourceful is a project combining Louis D’hauwe's SavannaKit and Source Editor. Highlightr merges Highlight.js with swift.

## Features
* Line Numbers
* Changeable Themes
* Changeable Languages
* Basic String, Parentheses, and Bracket completion

### Supports
* 2 Languages
* 59 Themes

# How To Use
To start using you can either crate a UIView in storyboards and assign it the class SyntaxTextView, or by creating a SyntaxTextView programmatically. You can then assign the editors language inside your View Controller. Firefly also lightly supports Swift UI.

## Sample Code
### UI Kit
A basic setup for a Firefly View
```swift
import UIKit
import Firefly

class ViewController: UIViewController {

    @IBOutlet weak var fireflyView: FireflySyntaxView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Use the setup function
        fireflyView.setup(theme: themeName, language: "jelly", font: "system", offsetKeyboard: true, keyboardOffset: 10, dynamicGutter: true, gutterWidth: 20, placeholdersAllowed: true, linkPlaceholders: false)
    }
}
```
### Set everything at once
This allows you to set almost all ascpets of the view at once so you do not accidently cause extra highlight calls.
```swift
fireflyView.setup(theme: themeName, language: "jelly", font: "system", offsetKeyboard: true, keyboardOffset: 10, dynamicGutter: true, gutterWidth: 20, placeholdersAllowed: true, linkPlaceholders: false)
```

### Set individual parts about the view
#### Set the text in the Firefly View
```swift
fireflyView.text = “My code string”
```
#### Set the Firefly View's Theme
```swift
fireflyView.setTheme(name: "Basic")
```
#### Set the Firefly View's Language
```swift
fireflyView.setLanguage(nLanguage: "default")
```
#### Set the Firefly View's Gutter Width
```swift
fireView.setGutterWidth(width: 20)
```
#### Set the Firefly View’s Keyboard Offset
The keyboard offset is the space between the bottom of firefly view and the keyboard frame. You should use this to make space for any keyboard input views.
```swift
fireflyView.setKeyboardOffset(offset: 85)
```

#### Tell the view if it should dynamically adjust for the keyboard
```swift
fireView.setShouldOffsetKeyboard(bool: true)
```

#### Set the Firefly View’s Font
```swift
fireflyView.setFont(font: "Source Code Pro")
```
#### Tell the view if it should dynamically update the gutter width
```swift
fireflyView.setDynamicGutter(bool: true)
```

#### Tell the view if it should show placeholders or not
A placeholder can be used to deeplink to a different part of your app or open a link. Used for documentation in Jellycuts.
```swift
fireView.setPlaceholdersAllowed(bool: true)
```

#### Tell the view if it placeholders should also be links
```swift
fireView.setLinkPlaceholders(bool: true)
```

#### Get the current theme set for the Firefly View
This returns the value for the current theme. You can use this to get details about what the View looks like and color other parts of your app accordingly.
```swift
let theme = fireflyView.getCurrentTheme()
```

#### List all supported languages
```swift
fireflyView().availableLanguages()
```

#### List all supported themes
```swift
fireflyView().availableThemes()
```

### Swift UI
Swift UI is not fully supported but it is still supported. An example view for Swift UI is below. This will set you up with a basic swift UI Fiefly view.

```swift
struct ContentView: View {
    @State var text = """
    if(x == 3) {
        quickLook()
    }
    import Shortcuts 1090.2
    #Color: red, #Icon: shortcuts
    Function()
    functionWithParams(test: test)
    // This is a comment
    /*
    This is a multi line comment
    */
    "String"
    \"""
    Multi Line Text
    More Text
    \"""
    """
    var body: some View {
        FireflySyntaxEditor(text: $text, language: "jelly", theme: "Xcode Dark", fontName: "system" , didChangeText: { (editor) in
            print("Did change text")
        }, didChangeSelectedRange: { (editor, range) in
            print("Did change selected range")
        }, textViewDidBeginEditing: { (editor) in
            print("Did begin editing")
        })
    }
}
```


# Adding your own content
## Adding your own language
Languages are a dictionary of definitions that tell the syntax highlighter how to detect a token.

Example of a language definition:
```swift
let defaultLanguage: [String: Any] = [
    "comment": [
        "regex": "//.*?(\\n|$)", // The regex used for highlighting
        "group": 0, // The regex group that should be highlighted
        "relevance": 5, // The releavance over other tokens
        "options": [], // Regular expression options
        "multiline": false // If the token is multiline
    ],
    "multi_comment": [
        "regex": "/\\*.*?\\*/", // The regex used for highlighting
        "group": 0, // The regex group that should be highlighted
        "relevance": 5, // The releavance over other tokens
        "options": [NSRegularExpression.Options.dotMatchesLineSeparators],  // Regular expression options
        "multiline": true // If the token is multiline
    ],
]
```

### Adding your language
To add your own language  to the languages array within the languages dictionary.
```swift
let languages: [String: [String: Any]] = [
    "default": defaultLanguage,
    "jelly": jellyLanguage,
    "swift": swiftLanguage
]
```

## Adding a Theme
Themes are a dictionary with color values telling the highlighter what color to highlight different tokens.

Example of a theme definition:
```swift
"Basic": [
    "default": "#000000", // The default font color
    "background": "#FFFFFF", // The background color
    "currentLine": "#F3F3F4", // Color of the current line
    "selection": "#A4CDFF", // The selection color of the text view
    "cursor": "#000000", // The cursor color of the text view
    "definitions": [ // These are the definitions that tell the highlighter what color to highlight different types of definitions.
        "function": "#2B839F",
        "keyword": "#0000FF",
        "identifier": "#2B839F",
        "string": "#A31515",
        "mult_string": "#A31515",
        "comment": "#008000",
        "multi_comment": "#008000",
        "numbers": "#000000",
        "url": "#0000FF"
    ]
]
```

# Apps that use Firefly
1. [Jellycuts](https://jellycuts.com)
2. [App Maker](https://appmakerios.com)

# To-Do
- [x] Support for Theme Changing

- [x] Support for Language Changing

- [x] Dynmaically creating Gutter and Line styles

- [x] Fix issues with themes not showing the correct colors when the token has a font weight modifier - Not really fixed, just a workaround currently.

- [x] Modify, update and implement SavannaKit / SyntaxKit LineNumberLayoutManager for better and faster line numbers

- [x] Speed increasments for loading larger files

- [x] Multi-line string support

- [x] Swift UI support

- [x] Placeholders

- [ ] Autocompletion

- [ ] Collapsable lines

- [ ] More languages

- [ ] Rewrite the NSTextStorage subclass in obj-c. This will bring speed improvments.

-[ ] Support VSCode Themes or a converter for VSCode -> Firefly theme

-[ ] Highlight current line with tinting of line number and line fragmenet

~~- [ ] Upgrade Highlighter version~~

# Credits
Sourceful is a project merging together SavannaKit and SourceEditor, and then udpdated too a modern version of Swift. It is maintained by Paul Hudson. This project was used as a starting ground for Firefly but has been largely removed from the working copy. Sourceful is licensed under the MIT license; see [Sourceful LICENSE](https://github.com/twostraws/Sourceful/blob/main/LICENSE) for more information.

Highlightr is a project taking Highlight.js and allowing it to interact with Swift. Highlighter has been removed from the working copy in favor of a full swift approach. Highlightr is licensed under the MIT license; see [Highlightr LICENSE](https://github.com/raspu/Highlightr/blob/master/LICENSE) for more information.

SyntaxKit is a project created by Palle Klewitz for iOS syntax highlighting. This project was used as a reference for issues in code. SyntaxKit is licensed under the MIT license; see [SyntaxKit LICENSE](https://github.com/palle-k/SyntaxKit/blob/master/license) for more information.

SavannaKit is a project created by Louis D'hauwe. Firefly uses a modified version of LineNumberLayoutManager. SavannaKit is licensed under the MIT license; see [SavannaKit LICENSE](https://github.com/louisdh/savannakit/blob/master/LICENSE) for more information.
