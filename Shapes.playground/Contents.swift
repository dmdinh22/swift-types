import Foundation

// enums makes string the same as
// name of case when you don't specify
enum ColorName: String, CaseIterable {
    case black, silver, gray, white, maroon, red, purple, fuchsia, green,
    lime, olive, yellow, navy, blue, teal, aqua
}

let fill = ColorName.gray
 
for color in ColorName.allCases {
    print("I love the color \(color).")
}
