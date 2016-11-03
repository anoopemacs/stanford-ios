//
//  ViewController.swift
//  Calculator2
//
//  Created by Anoop G R on 28/03/16.
//  Copyright © 2016 Anoop. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfTypingNumber = false
    
    @IBOutlet weak var historyLabel: UILabel!
    
    func addOpToHistory (sender: UIButton) {
        historyLabel.text = historyLabel.text! + sender.currentTitle! + "="
    }
    
    @IBAction func digitPress(sender: UIButton) {
        if userIsInTheMiddleOfTypingNumber {
            display.text = display.text! + sender.currentTitle!
        }
        else {
            display.text = sender.currentTitle!
            userIsInTheMiddleOfTypingNumber = true
        }
    }
    
    
    @IBAction func decimalPress(sender: UIButton) {
        if display.text!.rangeOfString(".") == nil {
            digitPress(sender)
        }
        else {
            print("cannot enter decimal dot twice")
        }
    }
    
    @IBAction func constantPressed(sender: UIButton) {
        if userIsInTheMiddleOfTypingNumber {
            // user forgot to press enter
            enter()
        }

        let name = sender.currentTitle!
        
        // update the display to show the constant pressed
        switch name {
        case "pi":
            displayValue = M_PI
            // other constants can be easily added here
        default: break
        }
    }

    var operandStack = Array<Double>()
    
    @IBAction func enter() {
        if let displayValueUnwrapped = displayValue {
            historyLabel.text = historyLabel.text! + " " + "\(displayValueUnwrapped)"
            operandStack.append(displayValueUnwrapped)
            print("operandStack = \(operandStack)")
            // now that appending is complete the bool turns false
            userIsInTheMiddleOfTypingNumber = false
        }
        else {
            // wipe out the display as requested in asgn 1.4
            display.text = ""
        }
    }
    // computed property example, now displayValue and displayText are in sync
    var displayValue: Double? {
        get {
            return NSNumberFormatter().numberFromString(display.text!) as? Double
        }
        set {
            if let newValueUnwrapped = newValue {
                if newValueUnwrapped % 1 == 0 {
                    display.text = String(format: "%.0f", newValueUnwrapped)
                }
                else {
                    display.text = String (newValueUnwrapped)
                }
            }
            userIsInTheMiddleOfTypingNumber = false
        }
    }

    @IBAction func operatePress(sender: UIButton) {
        
        addOpToHistory(sender)
        
        if userIsInTheMiddleOfTypingNumber {
            // user forgot to press enter
            enter()
        }
        let operationtitle = sender.currentTitle!
        switch operationtitle {
        case "*": performOperation {$0 * $1}
        case "/": performOperation {$1 / $0}
        case "-": performOperation {$1 - $0}
        case "+": performOperation {$0 + $1}
        case "sq": performOperation {sqrt($0)}
        case "sin": performOperation {sin($0 * M_PI / 180)}
        case "cos": performOperation {cos($0 * M_PI / 180)}
        default: break
        }
    }
    
    @nonobjc
    func performOperation (operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation (operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }

    @nonobjc
    func performOperation (operation: Double -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation (operandStack.removeLast())
            enter()
        }
    }
    
    
    @IBAction func clear() {
        print("clear all pressed")
        displayValue = 0
        historyLabel.text = "h:"
        operandStack = Array<Double>()
    }

    @IBAction func backSpacePressed() {
        if display.text!.characters.count >= 2 {
            display.text = String (display.text!.characters.dropLast())
        }
        else {
            display.text = "0"
        }
    }
    @IBAction func plusMinus() {
        if let displayValueUnwrapped = displayValue {
            if userIsInTheMiddleOfTypingNumber {
                displayValue = displayValueUnwrapped * -1
                userIsInTheMiddleOfTypingNumber = true
            }
            else {
                displayValue = displayValueUnwrapped * -1
            }
        }
    }
    
}

