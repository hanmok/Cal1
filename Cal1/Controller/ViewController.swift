//
//  ViewController.swift
//  Cal1
//
//  Created by hanmok on 2020/01/25.
//  Copyright © 2020 hanmok. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var index = 0
    var calc = CalculatorBasic()
    var operString : String?
    var numWordStringStorage = [""]
    var isOperatorPressed = false
   
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
         processView.text = "0"
    }
    //MARK: - <#func numberPressed
    @IBAction func numberPressed(_ sender: UIButton){
        if calc.numWordIntStorage[index] <= Int(1e18){
            //prevents app from crushing of limit of Int number
            let myOptional = sender.currentTitle
            if let safeOptional = myOptional{
                 numWordStringStorage[index] += String(safeOptional)
                calc.processString += String(safeOptional)
            }
            calc.numWordIntStorage[index] = Int(numWordStringStorage[index])!
            print("numWordStringStorage[\(index)] :\(numWordStringStorage[index])")
            printProcess()
        }
    }
    //MARK: - <#func operationPressed
    @IBAction func operationPressed(_ sender: UIButton){
        //        print(sender.titleLabel!)
        if let operInput = sender.currentTitle{
            switch operInput{//operation String
            case "+": print("+ button pressed"); calc.operationStorage[index] = "+"
            case "-" : print("- button pressed"); calc.operationStorage[index] = "-"
            case "X" : print(" X button pressed"); calc.operationStorage[index] = "x"
            case "/" : print("/ button pressed");  calc.operationStorage[index] = "/"
            default: print("other buttons pressed")
            calc.operationStorage[index] = "operation button error"
            }
            calc.processString += calc.operationStorage[index]
            print("operString = \(calc.operationStorage[index])")
      
            print("calc.operationStorage[index] : \(calc.operationStorage[index])")
        }
        
        calc.operationStorage.append("")
        calc.numWordIntStorage.append(0)
        numWordStringStorage.append("")
        calc.processStringArray.append("")
        isOperatorPressed = true
        printProcess()
        index += 1
       
    }
    //MARK: - <#func clearPressed
    @IBAction func clearPressed(_ sender: UIButton) {
        index = 0
        calc.operation = ""
        calc.numWordIntStorage = [0]
        calc.operationStorage = [""]
        calc.processStringArray = [""]
        numWordStringStorage = [""]
        calc.processString = ""
      
        printProcess()
        processView.text = "0"
    }
    //MARK: - <#func ansPressed
    
    @IBAction func ansPressed(_ sender: UIButton) {
        
    }
    //MARK: - <#func printProcess
    func printProcess(){
            processView.text = calc.processString
        }
        
        
    }

