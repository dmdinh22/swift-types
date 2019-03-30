import Foundation

// ## ENUMS ##
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

//takeaway: enums are great for picking items from a list of well-known things (ie. days of week, faces of a coin)

// ## STRUCTS ##
// to allow users to define their own custom shapes,
// enum is not a good type - cannot add new enum cases later in an extension

// when creating new model - start w/ protocol (like an interface)
protocol Drawable {
    func draw(with context: DrawingContext)
}

protocol DrawingContext {
    func draw(_ circle: Circle)
//    func draw(_ circleClass: CircleClass)
    func draw(_ rectangle: Rectangle)
}

// define Circle struct that adopts Drawable protocol
@dynamicMemberLookup
struct Circle: Drawable {
    var strokeWidth = 5
    var strokeColor = CSSColor.named(name: .red)
    var fillColor = CSSColor.named(name: .yellow)
    var center = (x: 80.0, y: 160.0)
    var radius = 60.0
    
    // adopting the Drawable protocol
    func draw(with context: DrawingContext) {
        context.draw(self)
    }
    // implement subscript(dynamicMember:) to fulfill @dynamicMemberLookup
    subscript(dynamicMember member: String) -> String {
        let properties = ["name": "Mr Circle"]
        return properties[member, default: ""]
    }
}

let circle = Circle()
let circleName = circle.name

// @dynamicMemberLookup can be added to class, struct, enum or protocol

// Structs vs Classes
// structs are value types and classes are reference types

// VALUES TYPES
var a = 10
var b = a
a = 30 // b still holds value of 10
a == b // evaluates false 30 != 10

var aCircle = Circle()
aCircle.radius = 60.0
var bCircle = aCircle
aCircle.radius = 1000.0 // b.radius holds value of 60.0
print(bCircle.radius)

// REFERENCE TYPES
class CircleClass: Drawable {
    var strokeWidth = 5
    var strokeColor = CSSColor.named(name: .red)
    var fillColor = CSSColor.named(name: .yellow)
    var center = (x: 80.0, y: 160.0)
    var radius = 60.0
    
    func draw(with context: DrawingContext) {
//        context.draw(self)
    }
}

var x = CircleClass() // class based circle
x.radius = 60.0
var y = x
x.radius = 1000.0
// y.radius also references the x object, which means y.radius becomes 1000.0
print(y.radius)

struct Rectangle: Drawable {
    var strokeWidth = 5
    var strokeColor = CSSColor.named(name: .teal)
    var fillColor = CSSColor.named(name: .aqua)
    var origin = (x: 110.0, y: 10.0)
    var size = (width: 100.0, height: 130.0)
    
    func draw(with context: DrawingContext) {
        context.draw(self)
    }
}

final class SVGContext: DrawingContext {
    private var commands: [String] = [] //initialized as empty string array
    
    var width = 250
    var height = 250
    
    // 1
    func draw(_ circle: Circle) {
        let command =
        """
        <circle cx='\(circle.center.x)' cy='\(circle.center.y)\' r='\(circle.radius)' \
        stroke='\(circle.strokeColor)' fill='\(circle.fillColor)' \
        stroke-width='\(circle.strokeWidth)' />
        """
        
        commands.append(command)
    }
    
    // 2
    func draw(_ rectangle: Rectangle) {
        let command =
        """
        <rect x='\(rectangle.origin.x)' y='\(rectangle.origin.y)' \
        width='\(rectangle.size.width)' height='\(rectangle.size.height)' \
        stroke='\(rectangle.strokeColor)' fill='\(rectangle.fillColor)' \
        stroke-width='\(rectangle.strokeWidth)' />

        """
        commands.append(command)
    }
    
    var svgString: String {
        var output = "<svg width='\(width)' height='\(height)'>"
        
        for command in commands {
            output += command
        }
        
        output += "</svg>"
        return output
    }
    
    var htmlString: String {
        return  "<!DOCTYPE html><html><body> \(svgString) </body></html>"
    }
}

struct SVGDocument {
    var drawables: [Drawable] = []
    
    var htmlString: String {
        let context = SVGContext()
        for drawable in drawables {
            drawable.draw(with: context)
        }
        
        return context.htmlString
    }
    
    mutating func append(_ drawable: Drawable) {
        drawables.append(drawable)
    }
}

var document = SVGDocument()

let rectangle = Rectangle()
document.append(rectangle)

let circle = Circle()
document.append(circle)

let htmlString = document.htmlString
print(htmlString)

import WebKit
import PlaygroundSupport
let view = WKWebView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
view.loadHTMLString(htmlString, baseURL: nil)
PlaygroundPage.current.liveView = view


// ## CLASSES ##
// for reference
//
//class Shape {
//    var strokeWidth = 1
//    var strokeColor = CSSColor.named(name: .black)
//    var fillColor = CSSColor.named(name: .black)
//    var origin = (x: 0.0, y: 0.0)
//    func draw(with context: DrawingContext) { fatalError("not implemented") }
//}
//
//class Circle: Shape {
//    override init() {
//        super.init()
//        strokeWidth = 5
//        strokeColor = CSSColor.named(name: .red)
//        fillColor = CSSColor.named(name: .yellow)
//        origin = (x: 80.0, y: 80.0)
//    }
//
//    var radius = 60.0
//    override func draw(with context: DrawingContext) {
//        context.draw(self)
//    }
//}
//
//class Rectangle: Shape {
//    override init() {
//        super.init()
//        strokeWidth = 5
//        strokeColor = CSSColor.named(name: .teal)
//        fillColor = CSSColor.named(name: .aqua)
//        origin = (x: 110.0, y: 10.0)
//    }
//
//    var size = (width: 100.0, height: 130.0)
//    override func draw(with context: DrawingContext) {
//        context.draw(self)
//    }
//}


extension Circle {
    var diameter: Double {
        get {
            return radius * 2
        }
        
        set {
            radius = newValue / 2
        }
    }
    
    var area: Double {
        return radius * radius * Double.pi
    }
    
    var perimeter: Double {
        return 2 * radius * Double.pi
    }
    
    // structs do not allow mutating stored props
    // need to declare that it's mutating to allow it
    mutating func shift(x: Double, y: Double) {
        center.x += x
        center.y += y
    }
}

// ## RETROACTIVE MODELING ##
// - extend behavior of model type before implementation of it
extension Rectangle {
    var area: Double {
        return size.width * size.height
    }
    
    var perimeter: Double {
        return 2 * (size.width + size.height)
    }
}

protocol ClosedShape {
    var area: Double { get }
    var perimeter: Double { get }
}

// conform to the protocol retroactively
extension Circle: ClosedShape {}
extension Rectangle: ClosedShape {}

func totalPerimeter(shapes: [ClosedShape]) -> Double {
    return shapes.reduce(0) { $1 + $1.perimeter }
}

totalPerimeter(shapes: [circle, rectangle])
