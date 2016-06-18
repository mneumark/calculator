//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Micah Neumark on 6/1/16.
//  Copyright © 2016 Maniacal Yeti. All rights reserved.
//

import Foundation

class CalculatorBrain {
    var result: Double {
        get {
            return accumulator
        }
    }
    
    var description: String {
        get {
            return humanReadableOperation
        }
    }
    
    var isPartialResult: Bool {
        get {
            return pending != nil
        }
    }
    
    private var humanReadableOperation = " "
    private var onFirstOperand = true
    private var accumulator = 0.0
    
    private var operations: Dictionary<String, Operation> = [
        "τ": Operation.Constant(M_PI_2),
        "π": Operation.Constant(M_PI),
        "e": Operation.Constant(M_E),
        "±": Operation.UnaryOperation({ -$0 }),
        "√": Operation.UnaryOperation(sqrt),
        "sin": Operation.UnaryOperation(sin),
        "cos": Operation.UnaryOperation(cos),
        "tan": Operation.UnaryOperation(tan),
        "×": Operation.BinaryOperation({ $0 * $1 }),
        "÷": Operation.BinaryOperation({ $0 / $1 }),
        "+": Operation.BinaryOperation({ $0 + $1 }),
        "−": Operation.BinaryOperation({ $0 - $1 }),
        "=": Operation.Equals
    ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    func setOperand(operand: Double) {
        accumulator = operand
        if humanReadableOperation == " " || pending == nil {
            humanReadableOperation = String(accumulator)
            onFirstOperand = true
        } else {
            humanReadableOperation += " " + String(accumulator)
            onFirstOperand = false
        }
    }
    
    func performOperation(symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value):
                setOperand(value)
            case .UnaryOperation(let function):
                executePendingBinaryOperation()
                accumulator = function(accumulator)
                humanReadableOperation = "\(symbol)(\(humanReadableOperation))"
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
                if (symbol == "÷" || symbol == "×") && !onFirstOperand {
                    humanReadableOperation = "(\(humanReadableOperation)) \(symbol)"
                } else {
                    humanReadableOperation += " " + symbol
                }
            case .Equals:
                executePendingBinaryOperation()
            }
        }
    }
    
    func clear() {
        accumulator = 0.0
        onFirstOperand = true
        humanReadableOperation = " "
        pending = nil
    }
    
    private func executePendingBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
   
}