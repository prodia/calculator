//
//  ViewController.swift
//  Calculator
//
//  Created by Kyle Bolton on 5/18/16.
//  Copyright © 2016 Kyle Bolton. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet private weak var display: UILabel!
    
    @IBOutlet private weak var descriptionLabel: UILabel!

    private var userIsInTheMiddleOfTyping = false
    private let DECIMAL_CHAR = "."
    
    @IBAction private func touchDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            if digit != DECIMAL_CHAR || display.text!.rangeOfString(DECIMAL_CHAR) == nil {
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
    
    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        
        set {
            display.text = String(newValue)
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction private func performOperation(sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        
        if let mathOperation = sender.currentTitle {
            brain.performOperand(mathOperation)
        }
        
        displayValue = brain.result

        descriptionLabel.text = brain.description
    }
}

