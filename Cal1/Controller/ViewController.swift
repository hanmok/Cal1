//
//  ViewController.swift
//  Cal1
//
//  Created by hanmok on 2020/01/25.
//  Copyright © 2020 hanmok. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var i = 0
    var index = 0
    var calculator = CalculatorBasic()
    var operString : String?
    //    var isoperationPressed : Bool?
    var numWordStringStorage = [""]
    //save a number with several digit in the form of String
    
    @IBOutlet weak var processView: UITextView!
    @IBOutlet weak var resultView: UITextView!
    @IBOutlet weak var operPlus: UIButton!
    @IBOutlet weak var ans: UIButton!
    
    @IBOutlet weak var num0: UIButton!
    @IBOutlet weak var num1: UIButton!
    @IBOutlet weak var num2: UIButton!
    @IBOutlet weak var num3: UIButton!
    @IBOutlet weak var num4: UIButton!
    @IBOutlet weak var num5: UIButton!
    @IBOutlet weak var num6: UIButton!
    @IBOutlet weak var num7: UIButton!
    @IBOutlet weak var num8: UIButton!
    @IBOutlet weak var num9: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        processView.isUserInteractionEnabled = false
        resultView.isUserInteractionEnabled = false
    }
    
    @IBAction func numberPressed(_ sender: UIButton) {
        if calculator.numberIntStorage[index] <= Int(1e18){
            //prevents app from crushing of limit of Int number
            let myOptional = sender.currentTitle
            if let safeOptional = myOptional{
                calculator.numSyllStorage.append(Int(safeOptional)!)
            }
            
            print("numSyllStorage : \(calculator.numSyllStorage[i])")
            
            numWordStringStorage[index] += String(calculator.numSyllStorage[i+1])
            print("numWordStringStorage :\(numWordStringStorage)")
            
            calculator.numberIntStorage[index] = Int(numWordStringStorage[index])!
            printProcess()
        }
        i += 1
    }
    
    @IBAction func operationPressed(_ sender: UIButton){
        //        print(sender.titleLabel!)
        if let operInput = sender.currentTitle{
            switch operInput{//operation String
            case "+": print("+ button pressed")
            calculator.operation = "+"
            case "-" : print("- button pressed")
            calculator.operation = "-"
            case "X" : print(" X button pressed")
            calculator.operation = "x"
            case "/" : print("/ button pressed")
            calculator.operation = "/"
            default:
                print("other buttons pressed")
                //                operString = "E"
                calculator.operation = "that's not a operation button .. "
            }
            print("operString = \(calculator.operation!)")
            calculator.operationStorage[index] = calculator.operation!
            print("calculator.operationStorage[index] : \(calculator.operationStorage[index])")
        }
        
        calculator.operationStorage.append("")
        calculator.numberIntStorage.append(0)
        printProcess()
        index += 1
        i = 0
        numWordStringStorage.append("")
    }
    
    @IBAction func clearPressed(_ sender: UIButton) {
        i = 0
        index = 0
        calculator.operation = ""
        calculator.numSyllStorage = [0]
        calculator.numberIntStorage = Array(repeating: 0, count: 10)
        calculator.operationStorage = Array(repeating: "", count: 10)
        calculator.processString = ""
        calculator.processStringArray = Array(repeating: "", count: 10)
        numWordStringStorage = Array(repeating: "", count: 10)
        printProcess()
        
    }
    
    @IBAction func equalPressed(_ sender: UIButton) {
    }
    func printProcess(){
        for j in 0 ... index{
            calculator.processStringArray[j] = numWordStringStorage[j] + calculator.operationStorage[j]
            print("calculator.processStringArray[\(j)] : \(calculator.processStringArray[j])")
       
            calculator.processString = calculator.processStringArray[0] + calculator.processStringArray[1] + calculator.processStringArray[2]
        }
                   processView.text = calculator.processString
    }
}

// processString = processStringArray[0] + 1 + 2 + ...
