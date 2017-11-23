//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Kyle Bolton on 5/18/16.
//  Copyright © 2016 Kyle Bolton. All rights reserved.
//

import Foundation

func multiply(op1: Double, op2: Double) -> Double {
    return op1 * op2
}

func random() -> Double {
    return drand48()
}

class CalculatorBrain {

    private var accumulator = 0.0
    private var history: [String] = []
    private var lastOperation :LastOperation = .Clear

    private let dotdotdot: String = " ..."

    private let operations: Dictionary<String, Operation> = [
        "π": Operation.Constant(Double.pi),
        "e": Operation.Constant(M_E),
        "√": Operation.UnaryOperation(sqrt),
        "cos": Operation.UnaryOperation(cos),
        "sin": Operation.UnaryOperation(sin),
        "tan": Operation.UnaryOperation(tan),
        "log10": Operation.UnaryOperation(log10),
        "×": Operation.BinaryOperation({ $0 * $1 }),
        "−": Operation.BinaryOperation({ $0 - $1 }),
        "÷": Operation.BinaryOperation({ $0 / $1 }),
        "+": Operation.BinaryOperation({ $0 + $1 }),
        "=": Operation.Equals,
        "c": Operation.Clear
    ]

    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
        case Clear
    }

    private enum LastOperation {
        case Digit
        case Constant
        case UnaryOperation
        case BinaryOperation
        case Equals
        case Clear
    }

    func setOperand(operand: Double) {
        if lastOperation == .UnaryOperation {
            history.removeAll()
        }

        accumulator = operand
        history.append(String(operand))
        lastOperation = .Digit
    }

    func performOperand(symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value):
                history.append(symbol)
                accumulator = value
                lastOperation = .Constant
            case .UnaryOperation(let function):
                wrapWithParens(symbol: symbol)
                accumulator = function(accumulator)
                lastOperation = .UnaryOperation
            case .BinaryOperation(let function):
                if lastOperation == .Equals {
                    history.removeLast()
                }
                history.append(symbol)
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
                lastOperation = .BinaryOperation
            case .Equals:
                if lastOperation == .BinaryOperation {
                    history.append(String(accumulator))
                }
                history.append(symbol)
                executePendingBinaryOperation()
                lastOperation = .Equals
            case .Clear:
                clear()
                lastOperation = .Clear
            }
        }
    }

    var result: Double {
        get {
            return accumulator;
        }
    }

    var isPartialResult: Bool {
        get {
            return pending != nil
        }
    }

    var description: String {
        get {
            if pending != nil {
                return history.joined(separator: " ") + dotdotdot
            }

            return history.joined(separator: " ")
        }
    }

    private func wrapWithParens(symbol: String) {
        if lastOperation == .Equals {
            history.insert(")", at: history.count - 1)
            history.insert(symbol, at: 0)
            history.insert("(", at: 1)
        } else {
            history.insert(symbol, at: history.count - 1)
            history.insert("(", at: history.count - 1)
            history.insert(")", at: history.count)
        }
    }

    private func executePendingBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }

    private func clear() {
        accumulator = 0
        pending = nil
        history.removeAll()
        lastOperation = .Clear
    }

    private var pending: PendingBinaryOperationInfo?

    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
}
