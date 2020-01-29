//
//  CalculatorBasic.swift
//  Cal1
//
//  Created by hanmok on 2020/01/27.
//  Copyright © 2020 hanmok. All rights reserved.
//

import UIKit

struct CalculatorBasic{
//    var num : Double?
    var operation : String?
    //operation it will perform
//    var numberInput : Double?
    //the number printed in the process console
    var numberStorage = [[0],[0],[0],[0],[0],[0],[0],[0],[0]]
    // == currentTitle( collection of one bit of numbers)
    //used to connect each digit numbers
    var numberIntStorage = Array(repeating: 0, count: 10)
    // a number made by numberStorage[]
    var operationStorage = Array(repeating: "", count: 10)
    var processString = ""
    var processStringArray = Array(repeating: "", count: 10)
    var answer : Double?
    
    //the number printed in the process console
}
