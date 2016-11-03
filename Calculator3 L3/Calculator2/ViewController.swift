//
//  ViewController.swift
//  Calculator2
//
//  Created by Anoop G R on 28/03/16.
//  Copyright © 2016 Anoop. All rights reserved.
//

//CONTROLLER

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfTypingNumber = false
    
    var brain = CalculatorBrain()
    
    @IBOutlet weak var historyLabel: UILabel!
    
    func updateHistoryLabel () {
        historyLabel.text = brain.description
    }
    
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
    
    @IBAction func enter() {
        if let displayValueUnwrapped = displayValue {
            userIsInTheMiddleOfTypingNumber = false
            if let result = brain.insertOperand(displayValueUnwrapped) {
                displayValue = result
            }
            else {
                displayValue = nil
            }
        }
        else {
            // wipe out the display as requested in asgn 1.4
            display.text = " "
        }
        
        updateHistoryLabel()
        
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
//                    print("else entered in setter & display.text = \(display.text)")
                }
            }
            else {
                display.text = " "
                print("displayValue = nil")
            }
            userIsInTheMiddleOfTypingNumber = false
        }
    }

    @IBAction func operatePress(sender: UIButton) {
        if userIsInTheMiddleOfTypingNumber {
            // user forgot to press enter
            enter()
        }
        if let operationtitle = sender.currentTitle {
            if let result = brain.insertOperation(operationtitle) {
                displayValue = result
            }
            else {
                displayValue = nil
            }
        }
        
        updateHistoryLabel()
    }

    
    
    @IBAction func clear() {
        print("clear all pressed")
        displayValue = 0
        brain.clearAll()
        updateHistoryLabel()
    }

    @IBAction func backSpacePressed() {
        if display.text!.characters.count >= 2 {
            display.text = String (display.text!.characters.dropLast())
        }
        else {
            display.text = "0"
        }
    }

    @IBAction func plusMinus(sender: UIButton) {
        if let displayValueUnwrapped = displayValue {
            if userIsInTheMiddleOfTypingNumber {
                displayValue = displayValueUnwrapped * -1
                userIsInTheMiddleOfTypingNumber = true
            }
            else {
                operatePress(sender)
            }
        }
    }
    
    @IBAction func insertDisplayIntoMemory(sender: UIButton) {
        userIsInTheMiddleOfTypingNumber = false
        
        if let displayValueUnwrapped = displayValue {
            brain.variableValues["M"] = displayValueUnwrapped
        }
        else {
            print("cannot push it into memory")
            displayValue = nil
        }
        if let result = brain.evaluate() {
            displayValue = result
        }
        else {
            print("failed evaluation in insertDisplayIntoMemory function")
            displayValue = nil
        }
    }
    
    @IBAction func insertMemoryIntoBrain(sender: UIButton) {
        if userIsInTheMiddleOfTypingNumber {
            //user forgot to press enter
            enter()
        }
        if let result = brain.insertOperand("M") {
            displayValue = result
        }
        else {
            print("memory could not be loaded into brainStack")
            displayValue = nil
        }
    }
}

