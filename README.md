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
An iOS syntax highlighter which combines and gthen updates [Sourceful](https://github.com/twostraws/Sourceful) and [Highlightr](https://github.com/raspu/Highlightr). It also leverages the power of both too create a fast and featured editor.

## About this project
This project is a combination of Sourceful by Paul Hudson (@twostraws) and Highlightr by J.P. Illanes (@raspu). Sourceful is a project combining Louis D’hauwe's SavannaKit and Source Editor. Highlightr merges Highlight.js with swift.

## Features
Firefly includes a line number counter, changeable themes, and changeable languages. It is not the fastest solution but works well on large files.

### Supports
* 185 Languages
* 90 Themes

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

# To-Do
- [x] Support for Theme Changing

- [x] Support for Language Changing

- [x] Dynmaically creating Gutter and Line styles

- [ ] Swift UI support

- [ ] Collapsable Lines

- [ ] Speed increasments for loading larger files

- [ ] Placeholders

- [ ] Autocompletion

# Credits
Sourceful is a project merging together SavannaKit and SourceEditor, and then udpdated too a modern version of Swift. It is maintained by Paul Hudson.
Highlightr is a project taking Highlight.js and allowing it to interact with Swift.

Sourceful is licensed under the MIT license; see LICENSE for more information.
Highlightr is licensed under the MIT license; see LICENSE for more information.
