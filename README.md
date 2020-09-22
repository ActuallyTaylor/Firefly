<p align="center">
    <img src="/Icon.png" alt="Firefly logo" width="128" maxHeight=“128" />
</p>

<p align="center">
    <img src="https://img.shields.io/badge/iOS-13.0+-green.svg" />
    <img src="https://img.shields.io/badge/Swift-5.0-orange.svg" />
    <a href="https://twitter.com/LinemanZachary">
        <img src="https://img.shields.io/badge/Contact-@LinemanZachary-blue.svg?style=flat" alt="Twitter: @LinemanZachary" />
    </a>
</p>

# Firefly
An iOS syntax highlighter based on [Sourceful](https://github.com/twostraws/Sourceful) and [Highlightr](https://github.com/raspu/Highlightr)

## About this project
This project is a combination of Sourceful by Paul Hudson (@twostraws) and Highlightr by J.P. Illanes (@raspu). Sourceful is a project combining Louis D’hauwe's SavannaKit and Source Editor. Highlightr merges Highlight.js with swift.

## How To Use
To start using you can either crate a UIView in storyboards and assign it the class SyntaxTextView, or by creating a SyntaxTextView programmatically. You can then assign the editors language inside your View Controller.
### Sample Code
Set the Editor langauge to Swift and the theme too atom-one
```swift
import UIKit
import Firefly

class MainVC: UIViewController, SyntaxTextViewDelegate {

    @IBOutlet weak var syntaxView: SyntaxTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Use the getTheme method from the Theme class to return a compatible theme that can assigned to the editor theme.
        let theme = Theme.getTheme(name: "atom-one")
        syntaxView.theme = theme
        //Languages are a string
        syntaxView.language = "swift"
    }
}
```
### List all supported languages
```swift
Highlightr()?.supportedLanguages()
```
### List all supported themes
```swift
Highlightr()?.availableThemes()
```
