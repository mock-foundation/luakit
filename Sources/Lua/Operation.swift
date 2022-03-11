//
//  Operation.swift
//  
//
//  Created by Егор Яковенко on 11.03.2022.
//

public enum Operation: Int32 {
    case addition = 0
    case subtraction = 1
    case multiplication = 2
    case floatDivision = 5
    case floorDivision = 6
    case modulo = 3
    case expo = 4
    case unaryMinus = 12
    case bitwiseNot = 13
    case bitwiseAnd = 7
    case bitwiseOr = 8
    case bitwiseExclusiveOr = 9
    case shiftLeft = 10
    case shiftRight = 11
}
