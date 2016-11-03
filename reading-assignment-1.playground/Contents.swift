//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
let minInt = Int.min

let maxInt = Int.max
log10(Double(maxInt))

Int64.max

//Tuples
let http404error = (404, "Not Found")
// above type is (Int, String)

//decoding a tuple
let (statusCode, statusMessage) = http404error
print("statusCode = \(statusCode); statusMessage = \(statusMessage)")

let (justTheStatusCode, _) = http404error
print("statusCode = \(justTheStatusCode)")
print(http404error.1)

let http200Status = (c: 200, m: "OK")
print(http200Status.c)

let x = Int (3.14)
let y = Int ("123")

let name = "Anoop-GR"
name[name.startIndex]
name[name.startIndex.successor()]
name[name.startIndex.advancedBy(4)]
name[name.endIndex.predecessor()]

let greeting = "Guten Tag!"
for index in greeting.characters.indices {
    print(index)
    print(greeting[index])
}

let myNameArray = Array (name.characters)


// get and set for computed property

struct Point {
    var x = 0.0, y = 0.0
}
struct Size {
    var width = 0.0, height = 0.0
}
struct Rect {
    var origin = Point()
    var size = Size()
    var center: Point {
        get {
            let center_x = origin.x + size.width / 2
            let center_y = origin.y + size.height / 2
            return Point(x: center_x, y: center_y)
        }
        set {
            origin.x = newValue.x - (size.width / 2)
            origin.y = newValue.y - (size.height / 2)
        }
    }
}
var square = Rect (origin: Point(x: 0.0, y: 0.0), size: Size(width: 10, height: 10))
print("origin is at \(square.origin.x) & \(square.origin.y)")

square.center.x = 15
square.center.y = 15
print("origin is at \(square.origin.x) & \(square.origin.y)")

