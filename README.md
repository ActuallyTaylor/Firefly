
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
Firefly is an iOS syntax highlighter based of off [Highlightr](https://github.com/raspu/Highlightr), [SavannaKit](https://github.com/louisdh/savannakit), [SyntaxKit](https://github.com/palle-k/SyntaxKit), and [Sourceful](https://github.com/twostraws/Sourceful). These projects allowed for the basis of Firefly with Highlightr as the main syntax highlighter and the other repositories for sources and references of code. The firefly syntax highlighter is extremely easy to use with only one view needed to get full syntax highlighting up and running.

# Using Firefly in your project
If you are going to use Firefly in your project, I request that you include a link back to this github page somewhere. If you would like to you can also [email me](mailto:zachary.lineman@gmail.com) and I will add you into the list of apps that use Firefly on this page.

# About this project
This project is a combination of Sourceful by Paul Hudson (@twostraws) and Highlightr by J.P. Illanes (@raspu). Sourceful is a project combining Louis D’hauwe's SavannaKit and Source Editor. Highlightr merges Highlight.js with swift.

## Features
Firefly includes a line number counter, changeable themes, and changeable languages. It is not the fastest solution but works well on large files.

### Supports
* 186 Languages
* 90 Themes

## How To Use
To start using you can either crate a UIView in storyboards and assign it the class SyntaxTextView, or by creating a SyntaxTextView programmatically. You can then assign the editors language inside your View Controller.

### Sample Code
Set the Editor langauge to Swift and the theme too xcode dark
```swift
import UIKit
import Firefly

class ViewController: UIViewController {

    @IBOutlet weak var fireflyView: FireflySyntaxView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Sets the Firefly View's theme to a theme that corresponds to the given name
        fireflyView.setTheme(name: "xcode-dark")
        // Sets the Firefly View's language to the corresponding language
        fireflyView.setLanguage(nLanguage: "swift")
        // Sets the gutter width of the Firefly view
        fireflyView.gutterWidth = 20
    }
}
```
### Set the Firefly View's Theme
```
fireflyView.setTheme(name: "xcode-dark")
```
### Set the Firefly View's Language
```
fireflyView.setLanguage(nLanguage: "swift")
```
### Set the Firefly View's Gutter Width
```
fireflyView.gutterWidth = 20
```

### List all supported languages
```swift
Highlightr()?.supportedLanguages()
```
### List all supported themes
```swift
Highlightr()?.availableThemes()
```

# Apps that use Firefly
1. Jellycuts

# To-Do
- [x] Support for Theme Changing

- [x] Support for Language Changing

- [x] Dynmaically creating Gutter and Line styles

- [x] Fix issues with themes not showing the correct colors when the token has a font weight modifier - Not really fixed, just a workaround currently.

- [x] Modify, update and implement SavannaKit / SyntaxKit LineNumberLayoutManager for better and faster line numbers

- [ ] Swift UI support

- [ ] Collapsable Lines

- [ ] Speed increasments for loading larger files

- [ ] Placeholders

- [ ] Autocompletion

# Credits
Sourceful is a project merging together SavannaKit and SourceEditor, and then udpdated too a modern version of Swift. It is maintained by Paul Hudson. This project was used as a starting ground for Firefly but has been largely removed from the working copy. Sourceful is licensed under the MIT license; see [Sourceful LICENSE](https://github.com/twostraws/Sourceful/blob/main/LICENSE) for more information.

Highlightr is a project taking Highlight.js and allowing it to interact with Swift. This project is used for syntax highlighting in Firefly. Highlightr is licensed under the MIT license; see [Highlightr LICENSE](https://github.com/raspu/Highlightr/blob/master/LICENSE) for more information.

SyntaxKit is a project created by Palle Klewitz for iOS syntax highlighting. This project was used as a reference for issues in code. SyntaxKit is licensed under the MIT license; see [SyntaxKit LICENSE](https://github.com/palle-k/SyntaxKit/blob/master/license) for more information.

SavannaKit is a project created by Louis D'hauwe. Firefly uses a modified version of LineNumberLayoutManager. SavannaKit is licensed under the MIT license; see [SavannaKit LICENSE](https://github.com/louisdh/savannakit/blob/master/LICENSE) for more information.





