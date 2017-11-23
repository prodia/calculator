//
//  ViewController.swift
//  Calculator
//
//  Created by Kyle Bolton on 5/18/16.
//  Copyright © 2016 Kyle Bolton. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var display: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    private var brain = CalculatorBrain()
    private var userIsInTheMiddleOfTyping = false
    private let DECIMAL_CHAR = "."
    
    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        
        set {
            display.text = String(newValue)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - IBActions
extension ViewController {
    
    @IBAction private func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            if digit != DECIMAL_CHAR || display.text!.range(of: DECIMAL_CHAR) == nil {
                display.text = textCurrentlyInDisplay + digit
            }
        } else {
            if digit == DECIMAL_CHAR {
                display.text = "0\(digit)"
            } else {
                display.text = digit
            }
        }
        
        userIsInTheMiddleOfTyping = true
    }
    
    @IBAction private func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(operand: displayValue)
            userIsInTheMiddleOfTyping = false
        }
        
        if let mathOperation = sender.currentTitle {
            brain.performOperand(symbol: mathOperation)
        }
        
        displayValue = brain.result
        descriptionLabel.text = brain.description
    }
}

