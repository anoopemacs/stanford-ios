//
//  CalculatorBrain.swift
//  Calculator2
//
//  Created by Anoop G R on 31/03/16.
//  Copyright © 2016 Anoop. All rights reserved.
//

//MODEL

import Foundation

class CalculatorBrain {
    
    private enum Op: CustomStringConvertible {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, Int, (Double, Double) -> Double)
        case Constant(String, () -> Double)
        case Variable(String)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _, _):
                    return symbol
                case .Constant(let symbol, _):
                    return symbol
                case .Variable(let variableName):
                    return variableName
                }
            }
        }
        
        var precedence: Int {
            get {
                switch  self {
                case .BinaryOperation(_, let precedence, _):
                    return precedence
                default:
                    return Int.max
                }
            }
        }
    }
    
    private var opStack = [Op]()
    
    func insertOperand(operand: Double) -> Double? {
        //insert operand and also evaluate
        opStack.append(.Operand(operand))
        return evaluate()
    }
    
    var variableValues = [String: Double]()
    
    func insertOperand(operand: String) -> Double? {
/*        if let operandDouble = variableValues[operand] {
            opStack.append(.Operand(operandDouble))
            return evaluate()
        }*/

            opStack.append(.Variable(operand))
            return evaluate()
    }
    
    private var knownOps = [String: Op]()
    
    init () {
        knownOps["*"] = Op.BinaryOperation("*", 3, *)
        knownOps["-"] = Op.BinaryOperation("-", 2) {$1 - $0}
        knownOps["+"] = Op.BinaryOperation("+", 1, +)
        knownOps["/"] = Op.BinaryOperation("/", 4) {$1 / $0}
        knownOps["sq"] = Op.UnaryOperation("sq", sqrt)
        knownOps["sin"] = Op.UnaryOperation("sin", sin)
        knownOps["cos"] = Op.UnaryOperation("cos", cos)
        knownOps["±"] = Op.UnaryOperation("±") {$0 * -1}
        knownOps["pi"] = Op.Constant("pi") {M_PI}
    }
    
    typealias PropertyList = AnyObject
    var program: PropertyList {
        get {
            return opStack.map{$0.description}
        }
        set {
            if let opSymbols = newValue as? Array<String> {
                var newOpStack = [Op]()
                for opSymbol in opSymbols {
                    if let operation = knownOps[opSymbol] {
                        newOpStack.append(operation)
                    }
                    else if let operand = NSNumberFormatter().numberFromString(opSymbol)?.doubleValue {
                        newOpStack.append(.Operand(operand))
                    }
                    else if let _ = variableValues[opSymbol] {
                        newOpStack.append(.Variable(opSymbol))
                    }
                }
                opStack = newOpStack
            }
        }
    }
    
    func insertOperation(opName: String) -> Double? {
        //insert operation and also evaluate
        if let operation = knownOps[opName] {
            opStack.append(operation)
        }
        return evaluate()
    }
    
    private func evaluate(arrayOfOps: [Op]) -> (result: Double?, remainingStack: [Op]) {
        if !arrayOfOps.isEmpty {
            var remainingStack = arrayOfOps
            let top = remainingStack.removeLast()
            switch top {
            case .Operand(let operand):
                return (operand, remainingStack)
            case .UnaryOperation(_, let operation):
                let opEvaluation = evaluate(remainingStack)
                if let operand = opEvaluation.result {
                    return (operation(operand), opEvaluation.remainingStack)
                }
            case .BinaryOperation(let sym, _, let operation):
                let op1Evaluation = evaluate(remainingStack)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingStack)
                    if let operand2 = op2Evaluation.result {
                        print("o1 = \(operand1), o2 = \(operand2), operation = \(sym)")
                        return (operation(operand1, operand2), remainingStack)
                    }
                }
            case .Constant(_, let operation):
                return (operation(), remainingStack)
            case .Variable(let variableName):
                if let variableValue = variableValues[variableName] {
                    return (variableValue, remainingStack)
                }
                else {
                    return (nil, remainingStack)
                }
            }
        }
        return (nil, arrayOfOps)
    }
    
    func evaluate() -> Double? {
        let (res, remainder) = evaluate(opStack)
        print("\(opStack) = \(res) with \(remainder) left over")
        return res
    }
    
    private func describe(arrayOfOps: [Op]) -> (retHistory: String, remainingOps: [Op], precedence: Int) {
        if !arrayOfOps.isEmpty {
            var remainingStack = arrayOfOps
            let top = remainingStack.removeLast()
            
            switch top {
            case .Operand(let operand):
                return (operand.description, remainingStack, Int.max)
            case .UnaryOperation(let symbol, _):
                let (inputForUnaryOperatorAsString, remainingStack1, _) = describe(remainingStack)
                return ( symbol + "(" + inputForUnaryOperatorAsString + ")", remainingStack1, 6)
            case .BinaryOperation(let symbol, _, _):
                let (secondInputForBinaryOperator, remainingStack1, _) = describe(remainingStack)
                let (firstInputForBinaryOperator, remainingStack2, _) = describe(remainingStack1)
                let ret = "(" + firstInputForBinaryOperator + " " + symbol + " " + secondInputForBinaryOperator + ")"
                return (ret, remainingStack2, 6)
            case .Constant(let symbol, _):
                return (symbol, remainingStack, 6)
            case .Variable(let variableName):
                return (variableName, remainingStack, 6)
            }
        }
        return ("?", arrayOfOps, Int.max)
    }
    
    //description of CalculatorBrain
    var description: String {
        // need to add a while loop here
        var (description, remainingStack, _) = describe(opStack)
        while remainingStack.count > 0 {
            let nextEvaluation = describe(remainingStack)
            remainingStack = nextEvaluation.remainingOps
            let nextDescription = nextEvaluation.retHistory
            
            description = nextDescription + " , " + description
        }
        return description + "="
    }
    
    func clearAll () {
        opStack.removeAll()
        variableValues = Dictionary<String, Double>()
    }
    
}
