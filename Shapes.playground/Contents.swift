import Foundation

// enums makes string the same as
// name of case when you don't specify
// CaseIterable makes the enum iterable in order of definition

//enum ColorName: String, CaseIterable {
//    case black, silver, gray, white, maroon, red, purple, fuchsia, green,
//    lime, olive, yellow, navy, blue, teal, aqua
//}

let fill = CSSColor.ColorName.gray

// Associated Values - gives two cases
// ie. CSSColor can be named - associated with ColorName
// OR rgb - associated with rgb (2nd case)
enum CSSColor {
    case named(name: ColorName)
    case rgb(red: UInt8, green: UInt8, blue: UInt8)
}

// enum extension to get string representation
// adopt standard Swift lib protocols to inter-operate
extension CSSColor: CustomStringConvertible {
    var description: String {
        switch self {
        case .named(let colorName):
            return colorName.rawValue
        case .rgb(let red, let green, let blue):
            return String(format: "#%02X%02X%02X", red, green, blue)
        }
    }
}

let color1 = CSSColor.named(name: .red)
let color2 = CSSColor.rgb(red: 0xAA, green: 0xAA, blue: 0xAA)

print("color 1 = \(color1), color2 = \(color2)")

// Note: The extension style is nice because it makes what you define fully explicit, in order to conform to a given protocol.
// In the case of CustomStringConvertible, you’re required to implement a getter for description.

// Custom Initializers with an enum - just like classes and structs
extension CSSColor {
    init(gray: UInt8) {
        self = .rgb(red: gray, green: gray, blue: gray)
    }
}

let color3 = CSSColor(gray: 0xaa)
print(color3)

// Namespace with enum - named types can act as a namespace for organization
extension CSSColor {
    enum ColorName: String, CaseIterable {
        case black, silver, gray, white, maroon, red, purple, fuchsia, green,
        lime, olive, yellow, navy, blue, teal, aqua
    }
}

// update loop to use CSSColor namespace
for color in CSSColor.ColorName.allCases {
    print("I love the color \(color).")
}
