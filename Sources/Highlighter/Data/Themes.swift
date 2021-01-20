//
//  Themes.swift
//  Firefly
//
//  Created by Zachary lineman on 12/24/20.
//

import Foundation

let themes: [String: [String: Any]] = [
    "Basic": [
        "default": "#000000",
        "background": "#FFFFFF",
        "currentLine": "#F3F3F4",
        "selection": "#A4CDFF",
        "cursor": "#000000",
        "definitions": [
            "function": "#2B839F",
            "keyword": "#0000FF",
            "identifier": "#2B839F",
            "string": "#A31515",
            "mult_string": "#A31515",
            "comment": "#008000",
            "multi_comment": "#008000",
            "numbers": "#000000",
            "url": "#0000FF"
        ],
        "style": "light"
    ],
    "Civic": [
        "default": "#E1E2E7",
        "background": "#1F2029",
        "currentLine": "#282938",
        "selection": "#35404E",
        "cursor": "#FFFFFF",
        "definitions": [
            "function": "#1DA9A2",
            "keyword": "#D7008F",
            "identifier": "#25908D",
            "string": "#D3232E",
            "mult_string": "#D3232E",
            "comment": "#45BB3E",
            "multi_comment": "#45BB3E",
            "numbers": "#149C92",
            "url": "#5124E3"
        ],
        "style": "dark"
    ],
    "Xcode Dark": [
        "default": "#FFFFFFD9", // Plain Text
        "background": "#1F1F24",
        "currentLine": "#23252B",
        "selection": "#515B70",
        "cursor": "#FFFFFF",
        "definitions": [
            "function": "#67B7A4", // Project Function and Method Names
            "keyword": "#FC5FA3", // Keywords
            "identifier": "#A167E6", // Other Function and Method Names | Other Class Names
            "string": "#FC6A5D", // Strings
            "mult_string": "#FC6A5D", // String
            "comment": "#6C7986", // Comments
            "multi_comment": "#6C7986", // Comments
            "numbers": "#D0BF69", // Numbers
            "url": "#5482FF" // URL
        ],
        "style": "dark"
    ],
    "Xcode Light": [
        "default": "#000000D9", // Plain Text
        "background": "#FFFFFF",
        "currentLine": "#E8F2FF",
        "selection": "#A4CDFF",
        "cursor": "#000000",
        "definitions": [
            "function": "#326D74", // Project Function and Method Names
            "keyword": "#9B2393", // Keywords
            "identifier": "#6C36A9", // Other Function and Method Names | Other Class Names
            "string": "#C41A16", // Strings
            "mult_string": "#C41A16", // String
            "comment": "#5D6C79", // Comments
            "multi_comment": "#5D6C79", // Comments
            "numbers": "#9B2393", // Numbers
            "url": "#0E0EFF" // URL
        ],
        "style": "light"
    ],
    "Dusk": [
        "default": "#FFFFFF", // Plain Text
        "background": "#1E2028",
        "currentLine": "#2D2D2D",
        "selection": "#54554A",
        "cursor": "#FFFFFF",
        "definitions": [
            "function": "#83C057", // Project Function and Method Names
            "keyword": "#83C057", // Keywords
            "identifier": "#83C057", // Other Function and Method Names | Other Class Names
            "string": "#DB2C38", // Strings
            "mult_string": "#DB2C38", // String
            "comment": "#41B645", // Comments
            "multi_comment": "#41B645", // Comments
            "numbers": "#786DC4", // Numbers
            "url": "#4155D1" // URL
        ],
        "style": "dark"
    ],
    "Classic Dark": [
        "default": "#ffffffD9", // Plain Text
        "background": "#1F1F24",
        "currentLine": "#23252B",
        "selection": "#515B70",
        "cursor": "#FFFFFF",
        "definitions": [
            "function": "#67B7A4", // Project Function and Method Names
            "keyword": "#FC5FA3", // Keywords
            "identifier": "#A167E6", // Other Function and Method Names | Other Class Names
            "string": "#FC6A5D", // Strings
            "mult_string": "#FC6A5D", // String
            "comment": "#73A74E", // Comments
            "multi_comment": "#73A74E", // Comments
            "numbers": "#D0BF69", // Numbers
            "url": "#5482FF" // URL
        ],
        "style": "dark"
    ],
    "Classic Light": [
        "default": "#000000D9", // Plain Text
        "background": "#FFFFFF",
        "currentLine": "#E8F2FF",
        "selection": "#A4CDFF",
        "cursor": "#000000",
        "definitions": [
            "function": "#326D74", // Project Function and Method Names
            "keyword": "#9B2393", // Keywords
            "identifier": "#6C36A9", // Other Function and Method Names | Other Class Names
            "string": "#C41A16", // Strings
            "mult_string": "#C41A16", // String
            "comment": "#267507", // Comments
            "multi_comment": "#267507", // Comments
            "numbers": "#1C00CF", // Numbers
            "url": "#0E0EFF" // URL
        ],
        "style": "light"
    ],
    "Low Key": [
        "default": "#000000", // Plain Text
        "background": "#FFFFFF",
        "currentLine": "#F3F5F4",
        "selection": "#CFD5D1",
        "cursor": "#000000",
        "definitions": [
            "function": "#476A97", // Project Function and Method Names
            "keyword": "#262C6A", // Keywords
            "identifier": "#476A97", // Other Function and Method Names | Other Class Names
            "string": "#702C51", // Strings
            "mult_string": "#702C51", // String
            "comment": "#435138", // Comments
            "multi_comment": "#435138", // Comments
            "numbers": "#262C6A", // Numbers
            "url": "#12139F" // URL
        ],
        "style": "light"
    ],
    "Midnight": [
        "default": "#FFFFFF", // Plain Text
        "background": "#000000",
        "currentLine": "#1A1919",
        "selection": "#4B4740",
        "cursor": "#FFFFFF",
        "definitions": [
            "function": "#23FF83", // Project Function and Method Names
            "keyword": "#D31895", // Keywords
            "identifier": "#00A0FF", // Other Function and Method Names | Other Class Names
            "string": "#FF2C38", // Strings
            "mult_string": "#FF2C38", // String
            "comment": "#41CC45", // Comments
            "multi_comment": "#41CC45", // Comments
            "numbers": "#786DFF", // Numbers
            "url": "#4164FF" // URL
        ],
        "style": "dark"
    ],
    "Sunset": [
        "default": "#000000", // Plain Text
        "background": "#FFFCE5",
        "currentLine": "#FDF5D3",
        "selection": "#F9DF9C",
        "cursor": "#000000",
        "definitions": [
            "function": "#476A97", // Project Function and Method Names
            "keyword": "#294277", // Keywords
            "identifier": "#476A97", // Other Function and Method Names | Other Class Names
            "string": "#DF0700", // Strings
            "mult_string": "#DF0700", // String
            "comment": "#C3741C", // Comments
            "multi_comment": "#C3741C", // Comments
            "numbers": "#294277", // Numbers
            "url": "#4349AC" // URL
        ],
        "style": "light"
    ],
    "Blackboard": [
        "default": "#FFFFFF", // Plain Text
        "background": "#0C1021",
        "currentLine": "#121B36",
        "selection": "#253B76",
        "cursor": "#FFFFFF",
        "definitions": [
            "function": "#FF640E", // Project Function and Method Names
            "keyword": "#FADE2D", // Keywords
            "identifier": "#8DA6CE", // Other Function and Method Names | Other Class Names
            "string": "#54C539", // Strings
            "mult_string": "#54C539", // String
            "comment": "#AEAEAE", // Comments
            "multi_comment": "#AEAEAE", // Comments
            "numbers": "#786DFF", // Numbers
            "url": "#1919FF" // URL
        ],
        "style": "dark"
    ],
    "Coal Graal": [
        "default": "#ECECF6", // Plain Text
        "background": "#222222",
        "currentLine": "#524259",
        "selection": "#E3A2FF",
        "cursor": "#000000",
        "definitions": [
            "function": "#EDB272", // Project Function and Method Names
            "keyword": "#B4DE61", // Keywords
            "identifier": "#B4DE61", // Other Function and Method Names | Other Class Names
            "string": "#9CB9CE", // Strings
            "mult_string": "#9CB9CE", // String
            "comment": "#515151", // Comments
            "multi_comment": "#515151", // Comments
            "numbers": "#DED43F", // Numbers
            "url": "#B4DE61" // URL
        ],
        "style": "dark"
    ],
    "Cobalt": [
        "default": "#FFFFFF", // Plain Text
        "background": "#002240",
        "currentLine": "#2D333E",
        "selection": "#B36539",
        "cursor": "#FFFFFF",
        "definitions": [
            "function": "#00FF00", // Project Function and Method Names
            "keyword": "#FF9D00", // Keywords
            "identifier": "#00FF00", // Other Function and Method Names | Other Class Names
            "string": "#3AD900", // Strings
            "mult_string": "#3AD900", // String
            "comment": "#0088FF", // Comments
            "multi_comment": "#0088FF", // Comments
            "numbers": "#FF628C", // Numbers
            "url": "#3AD900" // URL
        ],
        "style": "dark"
    ],
    "Dracula": [
        "default": "#E0DFE0", // Plain Text
        "background": "#1E1F29",
        "currentLine": "#282935",
        "selection": "#44475A",
        "cursor": "#FFFFFF",
        "definitions": [
            "function": "#50FA7B", // Project Function and Method Names
            "keyword": "#FF79C6", // Keywords
            "identifier": "#8BE9FD", // Other Function and Method Names | Other Class Names
            "string": "#D15555", // Strings
            "mult_string": "#D15555", // String
            "comment": "#6272A4", // Comments
            "multi_comment": "#6272A4", // Comments
            "numbers": "#BD93F9", // Numbers
            "url": "#6272A4" // URL
        ],
        "style": "dark"
    ],
    "EGO": [
        "default": "#EDEDED", // Plain Text
        "background": "#121212",
        "currentLine": "#1D1F1F",
        "selection": "#3E4647",
        "cursor": "#FFFFFF",
        "definitions": [
            "function": "#83C057", // Project Function and Method Names
            "keyword": "#F7DA7C", // Keywords
            "identifier": "#96D5F2", // Other Function and Method Names | Other Class Names
            "string": "#E48181", // Strings
            "mult_string": "#E48181", // String
            "comment": "#605860", // Comments
            "multi_comment": "#605860", // Comments
            "numbers": "#786DC4", // Numbers
            "url": "#9CB2EF" // URL
        ],
        "style": "dark"
    ],
    "Flat Dark": [
        "default": "#ECF0F1", // Plain Text
        "background": "#2C3E50",
        "currentLine": "#2E4153",
        "selection": "#34495E",
        "cursor": "#ECF0F1",
        "definitions": [
            "function": "#1ABC9C", // Project Function and Method Names
            "keyword": "#E74C3C", // Keywords
            "identifier": "#3498DB", // Other Function and Method Names | Other Class Names
            "string": "#F1C40F", // Strings
            "mult_string": "#F1C40F", // String
            "comment": "#7F8C8D", // Comments
            "multi_comment": "#7F8C8D", // Comments
            "numbers": "#F1C40F", // Numbers
            "url": "#F1C40F" // URL
        ],
        "style": "dark"
    ],
    "Flat Light": [
        "default": "#2C3E50", // Plain Text
        "background": "#ECF0F1",
        "currentLine": "#E0E5E6",
        "selection": "#BDC3C7",
        "cursor": "#2C3E50",
        "definitions": [
            "function": "#1ABC9C", // Project Function and Method Names
            "keyword": "#C0392B", // Keywords
            "identifier": "#3498DB", // Other Function and Method Names | Other Class Names
            "string": "#8E44AD", // Strings
            "mult_string": "#8E44AD", // String
            "comment": "#7F8C8D", // Comments
            "multi_comment": "#7F8C8D", // Comments
            "numbers": "#8E44AD", // Numbers
            "url": "#8E44AD" // URL
        ],
        "style": "light"
    ],
    "Github Light": [
        "default": "#262626", // Plain Text
        "background": "#FFFFFF",
        "currentLine": "#FCFAEF",
        "selection": "#F5EBBD",
        "cursor": "#000000",
        "definitions": [
            "function": "#1872A2", // Project Function and Method Names
            "keyword": "#930049", // Keywords
            "identifier": "#1872A2", // Other Function and Method Names | Other Class Names
            "string": "#D2360B", // Strings
            "mult_string": "#D2360B", // String
            "comment": "#848684", // Comments
            "multi_comment": "#848684", // Comments
            "numbers": "#1872A2", // Numbers
            "url": "#333333" // URL
        ],
        "style": "dark"
    ],
    "Glitter Bomb": [
        "default": "#E9E2DE", // Plain Text
        "background": "#0B0A0A",
        "currentLine": "#151415",
        "selection": "#333236",
        "cursor": "#000000",
        "definitions": [
            "function": "#705393", // Project Function and Method Names
            "keyword": "#DAB900", // Keywords
            "identifier": "#705393", // Other Function and Method Names | Other Class Names
            "string": "#4D6537", // Strings
            "mult_string": "#4D6537", // String
            "comment": "#44444E", // Comments
            "multi_comment": "#44444E", // Comments
            "numbers": "#D3C788", // Numbers
            "url": "#DAB900" // URL
        ],
        "style": "dark"
    ],
    "Humane": [
        "default": "#000000", // Plain Text
        "background": "#E3D5C1",
        "currentLine": "#D5D3D0",
        "selection": "#ABCDFC",
        "cursor": "#000000",
        "definitions": [
            "function": "#305F65", // Project Function and Method Names
            "keyword": "#400080", // Keywords
            "identifier": "#6132A3", // Other Function and Method Names | Other Class Names
            "string": "#2643D6", // Strings
            "mult_string": "#2643D6", // String
            "comment": "#937A42", // Comments
            "multi_comment": "#937A42", // Comments
            "numbers": "#259241", // Numbers
            "url": "#259241" // URL
        ],
        "style": "light"
    ],
    "Kellys": [
        "default": "#ECECF6", // Plain Text
        "background": "#1F2023",
        "currentLine": "#50415A",
        "selection": "#E3A2FF",
        "cursor": "#828282",
        "definitions": [
            "function": "#88A2BD", // Project Function and Method Names
            "keyword": "#A2D412", // Keywords
            "identifier": "#88A2BD", // Other Function and Method Names | Other Class Names
            "string": "#D5C38C", // Strings
            "mult_string": "#D5C38C", // String
            "comment": "#515151", // Comments
            "multi_comment": "#515151", // Comments
            "numbers": "#FF8C34", // Numbers
            "url": "#A2D412" // URL
        ],
        "style": "dark"
    ],
    "Mangold": [
        "default": "#FFFFFF", // Plain Text
        "background": "#000000",
        "currentLine": "#0C0D15",
        "selection": "#2F3356",
        "cursor": "#FFFFFF",
        "definitions": [
            "function": "#EC7600", // Project Function and Method Names
            "keyword": "#E1ED5D", // Keywords
            "identifier": "#93C763", // Other Function and Method Names | Other Class Names
            "string": "#EC7600", // Strings
            "mult_string": "#EC7600", // String
            "comment": "#709CD8", // Comments
            "multi_comment": "#709CD8", // Comments
            "numbers": "#C0C078", // Numbers
            "url": "#1919FF" // URL
        ],
        "style": "dark"
    ],
    "Monoguy": [
        "default": "#F6F6EF", // Plain Text
        "background": "#1D1E1A",
        "currentLine": "#561A13CC",
        "selection": "#FF0C0033",
        "cursor": "#D2D2D2",
        "definitions": [
            "function": "#63CEFF", // Project Function and Method Names
            "keyword": "#C71449", // Keywords
            "identifier": "#63CEFF", // Other Function and Method Names | Other Class Names
            "string": "#FED721", // Strings
            "mult_string": "#FED721", // String
            "comment": "#585751", // Comments
            "multi_comment": "#585751", // Comments
            "numbers": "#FFB016", // Numbers
            "url": "#589FFF" // URL
        ],
        "style": "dark"
    ],
    "Monokai": [
        "default": "#E9E2DE", // Plain Text
        "background": "#1D1E1A",
        "currentLine": "#232321",
        "selection": "#333236",
        "cursor": "#FFFFFF",
        "definitions": [
            "function": "#FD971F", // Project Function and Method Names
            "keyword": "#F92672", // Keywords
            "identifier": "#FD971F", // Other Function and Method Names | Other Class Names
            "string": "#E7DC74", // Strings
            "mult_string": "#E7DC74", // String
            "comment": "#75715E", // Comments
            "multi_comment": "#75715E", // Comments
            "numbers": "#AE80FF", // Numbers
            "url": "#F92672" // URL
        ],
        "style": "dark"
    ],
    "Moodnight": [
        "default": "#C8C8C8", // Plain Text
        "background": "#03131C",
        "currentLine": "#232E2D",
        "selection": "#837C60",
        "cursor": "#FFFFFF",
        "definitions": [
            "function": "#24CD77", // Project Function and Method Names
            "keyword": "#FC9C16", // Keywords
            "identifier": "#00A0FF", // Other Function and Method Names | Other Class Names
            "string": "#FC5407", // Strings
            "mult_string": "#FC5407", // String
            "comment": "#247423", // Comments
            "multi_comment": "#247423", // Comments
            "numbers": "#786DFF", // Numbers
            "url": "#1919FF" // URL
        ],
        "style": "dark"
    ],
    "Night": [
        "default": "#ECECF6", // Plain Text
        "background": "#242331",
        "currentLine": "#544365",
        "selection": "#E3A2FF",
        "cursor": "#FFFFFF",
        "definitions": [
            "function": "#FF83FF", // Project Function and Method Names
            "keyword": "#00CFF8", // Keywords
            "identifier": "#8858DE", // Other Function and Method Names | Other Class Names
            "string": "#9DCBFF", // Strings
            "mult_string": "#9DCBFF", // String
            "comment": "#8C8C8C", // Comments
            "multi_comment": "#8C8C8C", // Comments
            "numbers": "#8FE763", // Numbers
            "url": "#00CFF8" // URL
        ],
        "style": "dark"
    ],
    "Objective Sheep": [
        "default": "#F1F1F1", // Plain Text
        "background": "#1F1F1F",
        "currentLine": "#37372F",
        "selection": "#7E7E60",
        "cursor": "#FFFFFF",
        "definitions": [
            "function": "#8F9F9E", // Project Function and Method Names
            "keyword": "#8397A7", // Keywords
            "identifier": "#698B33", // Other Function and Method Names | Other Class Names
            "string": "#D96B14", // Strings
            "mult_string": "#D96B14", // String
            "comment": "#7DA43D", // Comments
            "multi_comment": "#7DA43D", // Comments
            "numbers": "#CBCCCB", // Numbers
            "url": "#CBCCCB" // URL
        ],
        "style": "dark"
    ],
    "Obsidian Code": [
        "default": "#D9D9D9", // Plain Text
        "background": "#151B1D",
        "currentLine": "#1D2529",
        "selection": "#35434D",
        "cursor": "#E4E4E4",
        "definitions": [
            "function": "#C8CAD0", // Project Function and Method Names
            "keyword": "#91C155", // Keywords
            "identifier": "#5D7C9D", // Other Function and Method Names | Other Class Names
            "string": "#E87500", // Strings
            "mult_string": "#E87500", // String
            "comment": "#78816D", // Comments
            "multi_comment": "#78816D", // Comments
            "numbers": "#CFAB00", // Numbers
            "url": "#A3E7FF" // URL
        ],
        "style": "dark"
    ],
    "Pastel Menlo": [
        "default": "#F5F5F5", // Plain Text
        "background": "#161616",
        "currentLine": "#212121",
        "selection": "#424242",
        "cursor": "#BEBEBE",
        "definitions": [
            "function": "#EF7A6D", // Project Function and Method Names
            "keyword": "#CC762E", // Keywords
            "identifier": "#EF7A6D", // Other Function and Method Names | Other Class Names
            "string": "#A0C25F", // Strings
            "mult_string": "#A0C25F", // String
            "comment": "#666666", // Comments
            "multi_comment": "#666666", // Comments
            "numbers": "#6C99BB", // Numbers
            "url": "#5863FF" // URL
        ],
        "style": "dark"
    ],
    "Quiet Light": [
        "default": "#333333", // Plain Text
        "background": "#F5F5F5",
        "currentLine": "#E6F6D7",
        "selection": "#B9F77B",
        "cursor": "#333333",
        "definitions": [
            "function": "#AA3731", // Project Function and Method Names
            "keyword": "#325A8E", // Keywords
            "identifier": "#AA3731", // Other Function and Method Names | Other Class Names
            "string": "#448C27", // Strings
            "mult_string": "#448C27", // String
            "comment": "#AAAAAA", // Comments
            "multi_comment": "#AAAAAA", // Comments
            "numbers": "#AB6526", // Numbers
            "url": "#91B3E0" // URL
        ],
        "style": "light"
    ],
    "Raspberry Sorbet": [
        "default": "#C1C1C1", // Plain Text
        "background": "#0F0109",
        "currentLine": "#210213",
        "selection": "#580433",
        "cursor": "#FFF600",
        "definitions": [
            "function": "#35AB5F", // Project Function and Method Names
            "keyword": "#A16FB6", // Keywords
            "identifier": "#867DB6", // Other Function and Method Names | Other Class Names
            "string": "#80959A", // Strings
            "mult_string": "#80959A", // String
            "comment": "#4FFF91", // Comments
            "multi_comment": "#4FFF91", // Comments
            "numbers": "#CE58B4", // Numbers
            "url": "#1919FF" // URL
        ],
        "style": "dark"
    ],
    "Rearden Steel": [
        "default": "#F3F3F3", // Plain Text
        "background": "#26292C",
        "currentLine": "#2C312F",
        "selection": "#3F4738",
        "cursor": "#FFF600",
        "definitions": [
            "function": "#9B89E3", // Project Function and Method Names
            "keyword": "#9BD464", // Keywords
            "identifier": "#9BD464", // Other Function and Method Names | Other Class Names
            "string": "#F1A642", // Strings
            "mult_string": "#F1A642", // String
            "comment": "#59A6FF", // Comments
            "multi_comment": "#59A6FF", // Comments
            "numbers": "#F1A642", // Numbers
            "url": "#528FC7" // URL
        ],
        "style": "dark"
    ],
    "Resesif": [
        "default": "#E9E2DE", // Plain Text
        "background": "#232323",
        "currentLine": "#272728",
        "selection": "#333236",
        "cursor": "#FFFFFF",
        "definitions": [
            "function": "#D98339", // Project Function and Method Names
            "keyword": "#B2ED5D", // Keywords
            "identifier": "#D98339", // Other Function and Method Names | Other Class Names
            "string": "#B49CDA", // Strings
            "mult_string": "#B49CDA", // String
            "comment": "#8B8B8B", // Comments
            "multi_comment": "#8B8B8B", // Comments
            "numbers": "#B49CDA", // Numbers
            "url": "#B2ED5D" // URL
        ],
        "style": "dark"
    ],
    "Salander": [
        "default": "#F3F3ED", // Plain Text
        "background": "#000000",
        "currentLine": "#0E1111",
        "selection": "#3A4346",
        "cursor": "#80959A",
        "definitions": [
            "function": "#7A7EB5", // Project Function and Method Names
            "keyword": "#63667F", // Keywords
            "identifier": "#A0A4E1", // Other Function and Method Names | Other Class Names
            "string": "#BBAAD0", // Strings
            "mult_string": "#BBAAD0", // String
            "comment": "#99A1BC", // Comments
            "multi_comment": "#99A1BC", // Comments
            "numbers": "#63667F", // Numbers
            "url": "#564E7F" // URL
        ],
        "style": "dark"
    ],
    "Scratch Art": [
        "default": "#FFFFFF", // Plain Text
        "background": "#000000",
        "currentLine": "#040920",
        "selection": "#0F227F",
        "cursor": "#FFFFFF",
        "definitions": [
            "function": "#0080FF", // Project Function and Method Names
            "keyword": "#0080FF", // Keywords
            "identifier": "#0080FF", // Other Function and Method Names | Other Class Names
            "string": "#FF8000", // Strings
            "mult_string": "#FF8000", // String
            "comment": "#008000", // Comments
            "multi_comment": "#008000", // Comments
            "numbers": "#FF0000", // Numbers
            "url": "#0080FF" // URL
        ],
        "style": "dark"
    ],
    "Second Gear": [
        "default": "#FFFFFF", // Plain Text
        "background": "#2B2B2B",
        "currentLine": "#35373D",
        "selection": "#545D73",
        "cursor": "#FFFFFF",
        "definitions": [
            "function": "#FFC56C", // Project Function and Method Names
            "keyword": "#CC7833", // Keywords
            "identifier": "#DA4839", // Other Function and Method Names | Other Class Names
            "string": "#A4C260", // Strings
            "mult_string": "#A4C260", // String
            "comment": "#BB9357", // Comments
            "multi_comment": "#BB9357", // Comments
            "numbers": "#A4C260", // Numbers
            "url": "#A4C260" // URL
        ],
        "style": "dark"
    ],
    "Sidewalk Chalk": [
        "default": "#F2F2F2", // Plain Text
        "background": "#191919",
        "currentLine": "#4C3B52",
        "selection": "#E3A2FF",
        "cursor": "#E6E6E6",
        "definitions": [
            "function": "#86AEE1", // Project Function and Method Names
            "keyword": "#7DE35A", // Keywords
            "identifier": "#55B2D3", // Other Function and Method Names | Other Class Names
            "string": "#64ADF8", // Strings
            "mult_string": "#64ADF8", // String
            "comment": "#626262", // Comments
            "multi_comment": "#626262", // Comments
            "numbers": "#FFEE49", // Numbers
            "url": "#7DE35A" // URL
        ],
        "style": "dark"
    ],
    "Solarize Dark": [
        "default": "#708284", // Plain Text
        "background": "#042029",
        "currentLine": "#06222B",
        "selection": "#0A2933",
        "cursor": "#819090",
        "definitions": [
            "function": "#259286", // Project Function and Method Names
            "keyword": "#738A05", // Keywords
            "identifier": "#738A05", // Other Function and Method Names | Other Class Names
            "string": "#259286", // Strings
            "mult_string": "#259286", // String
            "comment": "#475B62", // Comments
            "multi_comment": "#475B62", // Comments
            "numbers": "#259286", // Numbers
            "url": "#595AB7" // URL
        ],
        "style": "dark"
    ],
    "Solarize Light": [
        "default": "#708284", // Plain Text
        "background": "#FCF4DC",
        "currentLine": "#F8F0D8",
        "selection": "#EAE3CB",
        "cursor": "#819090",
        "definitions": [
            "function": "#259286", // Project Function and Method Names
            "keyword": "#738A05", // Keywords
            "identifier": "#738A05", // Other Function and Method Names | Other Class Names
            "string": "#259286", // Strings
            "mult_string": "#259286", // String
            "comment": "#475B62", // Comments
            "multi_comment": "#475B62", // Comments
            "numbers": "#259286", // Numbers
            "url": "#595AB7" // URL
        ],
        "style": "light"
    ],
    "Solarized Dark": [
        "default": "#848F8F", // Plain Text
        "background": "#0D2028",
        "currentLine": "#0E222A",
        "selection": "#122832",
        "cursor": "#CCCCCC",
        "definitions": [
            "function": "#337AC4", // Project Function and Method Names
            "keyword": "#5DD8FF", // Keywords
            "identifier": "#337AC4", // Other Function and Method Names | Other Class Names
            "string": "#9F761A", // Strings
            "mult_string": "#9F761A", // String
            "comment": "#4A5A61", // Comments
            "multi_comment": "#4A5A61", // Comments
            "numbers": "#BC3332", // Numbers
            "url": "#337AC4" // URL
        ],
        "style": "dark"
    ],
    "Solarized Light": [
        "default": "#4A5A61", // Plain Text
        "background": "#FBF3DD",
        "currentLine": "#F7EFD9",
        "selection": "#E9E2CC",
        "cursor": "#CCCCCC",
        "definitions": [
            "function": "#337AC4", // Project Function and Method Names
            "keyword": "#5DD8FF", // Keywords
            "identifier": "#337AC4", // Other Function and Method Names | Other Class Names
            "string": "#9F761A", // Strings
            "mult_string": "#9F761A", // String
            "comment": "#848F8F", // Comments
            "multi_comment": "#848F8F", // Comments
            "numbers": "#BC3332", // Numbers
            "url": "#337AC4" // URL
        ],
        "style": "light"
    ],
    "Space Gray": [
        "default": "#B3B8C4", // Plain Text
        "background": "#20242C",
        "currentLine": "#454952C9",
        "selection": "#B3B8C426",
        "cursor": "#B3B8C4",
        "definitions": [
            "function": "#7D8FA3", // Project Function and Method Names
            "keyword": "#A57A9E", // Keywords
            "identifier": "#B04C58", // Other Function and Method Names | Other Class Names
            "string": "#95B47B", // Strings
            "mult_string": "#95B47B", // String
            "comment": "#3E4853", // Comments
            "multi_comment": "#3E4853", // Comments
            "numbers": "#C5735E", // Numbers
            "url": "#C5735E" // URL
        ],
        "style": "dark"
    ],
    "Space Dust": [
        "default": "#ECF0C1", // Plain Text
        "background": "#07171B",
        "currentLine": "#081F2B",
        "selection": "#0A385C",
        "cursor": "#ECF0C1",
        "definitions": [
            "function": "#009FC5", // Project Function and Method Names
            "keyword": "#EBC562", // Keywords
            "identifier": "#039FC5", // Other Function and Method Names | Other Class Names
            "string": "#4A9D8F", // Strings
            "mult_string": "#4A9D8F", // String
            "comment": "#6E5346", // Comments
            "multi_comment": "#6E5346", // Comments
            "numbers": "#4A9D8F", // Numbers
            "url": "#0D7D7B" // URL
        ],
        "style": "dark"
    ],
    "Tomorrow Night": [
        "default": "#C4C8C6", // Plain Text
        "background": "#1D1F21",
        "currentLine": "#232629",
        "selection": "#373B41",
        "cursor": "#C4C8C6",
        "definitions": [
            "function": "#F0C674", // Project Function and Method Names
            "keyword": "#B294BB", // Keywords
            "identifier": "#81A2BF", // Other Function and Method Names | Other Class Names
            "string": "#B5BD68", // Strings
            "mult_string": "#B5BD68", // String
            "comment": "#969896", // Comments
            "multi_comment": "#969896", // Comments
            "numbers": "#DE935F", // Numbers
            "url": "#81A2BF" // URL
        ],
        "style": "dark"
    ],
    "Twilight": [
        "default": "#F8F8F8", // Plain Text
        "background": "#0B0B0B",
        "currentLine": "#151512",
        "selection": "#333327",
        "cursor": "#A6A6A6",
        "definitions": [
            "function": "#d2d2d2", // Project Function and Method Names
            "keyword": "#F9EE98", // Keywords
            "identifier": "#F9EE98", // Other Function and Method Names | Other Class Names
            "string": "#8F9D6A", // Strings
            "mult_string": "#8F9D6A", // String
            "comment": "#5E5E5E", // Comments
            "multi_comment": "#5E5E5E", // Comments
            "numbers": "#786DC4", // Numbers
            "url": "#8F9D6A" // URL
        ],
        "style": "dark"
    ],
    "WWDC 2016": [
        "default": "#F9F8F5", // Plain Text
        "background": "#1F2128",
        "currentLine": "#57595EC9",
        "selection": "#FFFFFF26",
        "cursor": "#F8F8F2",
        "definitions": [
            "function": "#B97C50", // Project Function and Method Names
            "keyword": "#419B92", // Keywords
            "identifier": "#B97C50", // Other Function and Method Names | Other Class Names
            "string": "#85BF5D", // Strings
            "mult_string": "#85BF5D", // String
            "comment": "#63A845", // Comments
            "multi_comment": "#63A845", // Comments
            "numbers": "#85BF5D", // Numbers
            "url": "#7579BD" // URL
        ],
        "style": "dark"
    ],
    "Wentworth": [
        "default": "#FFFFFF", // Plain Text
        "background": "#000000",
        "currentLine": "#0B0D09",
        "selection": "#2E3522",
        "cursor": "#647832",
        "definitions": [
            "function": "#EA2015", // Project Function and Method Names
            "keyword": "#CCFF66", // Keywords
            "identifier": "#609000", // Other Function and Method Names | Other Class Names
            "string": "#80959A", // Strings
            "mult_string": "#80959A", // String
            "comment": "#D8D8A8", // Comments
            "multi_comment": "#D8D8A8", // Comments
            "numbers": "#C0C078", // Numbers
            "url": "#1919FF" // URL
        ],
        "style": "dark"
    ],
    "XCasts": [
        "default": "#D9D9D9", // Plain Text
        "background": "#2B2B2B",
        "currentLine": "#323F41",
        "selection": "#4A7D86",
        "cursor": "#FFE463",
        "definitions": [
            "function": "#C9AF55", // Project Function and Method Names
            "keyword": "#8E530D", // Keywords
            "identifier": "#C9AF55", // Other Function and Method Names | Other Class Names
            "string": "#68A354", // Strings
            "mult_string": "#68A354", // String
            "comment": "#615339", // Comments
            "multi_comment": "#615339", // Comments
            "numbers": "#5C5C5C", // Numbers
            "url": "#A3E7FF" // URL
        ],
        "style": "dark"
    ],
    "Sundells Colors": [
        "default": "#94ABAB", // Plain Text
        "background": "#191919",
        "currentLine": "#272D2FDB",
        "selection": "#52687073",
        "cursor": "#E7E7E7",
        "definitions": [
            "function": "#1A74CA", // Project Function and Method Names
            "keyword": "#CA186F", // Keywords
            "identifier": "#5957B9", // Other Function and Method Names | Other Class Names
            "string": "#C13707", // Strings
            "mult_string": "#C13707", // String
            "comment": "#465B62", // Comments
            "multi_comment": "#465B62", // Comments
            "numbers": "#D75D42", // Numbers
            "url": "#526870" // URL
        ],
        "style": "dark"
    ],
]
