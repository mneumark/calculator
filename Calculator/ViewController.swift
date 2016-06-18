//
//  ViewController.swift
//  Calculator
//
//  Created by Micah Neumark on 5/30/16.
//  Copyright © 2016 Maniacal Yeti. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private var brain = CalculatorBrain()
    private var userIsInTheMiddleOfTyping = false
    
    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    @IBOutlet private weak var display: UILabel!
    @IBOutlet private weak var sequence: UILabel!
    
    @IBAction private func touchDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            if (digit == "." && textCurrentlyInDisplay.rangeOfString(digit) == nil) || digit != "." {
                display.text = textCurrentlyInDisplay + digit
            }
        } else {
            display.text = digit
        }
        userIsInTheMiddleOfTyping = true
    }
    
    @IBAction func performOperation(sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        if brain.isPartialResult {
            sequence.text = "\(brain.description) ..."
        } else {
            sequence.text = "\(brain.description) ="
        }
        displayValue = brain.result
    }
    
    @IBAction func clear() {
        brain.clear()
        displayValue = brain.result
        sequence.text = brain.description
    }
}

