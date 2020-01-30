//
//  ViewController.swift
//  Cal1
//
//  Created by hanmok on 2020/01/25.
//  Copyright © 2020 hanmok. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var isDeterminedAnswer = false
    var result : Double?
    var answer : [Double] = [1]
    var index = 0
    var freshNumIndex : [Bool] = [true]
    var muldiOperIndex : [Bool] = [false]
    var calc = CalculatorBasic()
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
        }
        if index >= 1{
            muldiOperIndex.append(false)
             answer.append(1)
        }
        if calc.operationStorage[index] == "x" || calc.operationStorage[index] == "/"{
            muldiOperIndex[index] = true
        }
        print("muldiOperIndex[\(index)] : \(muldiOperIndex[index])")
        calc.processString += calc.operationStorage[index]
        
        
        print("calc.operationStorage[index] : \(calc.operationStorage[index])")
        
       
        freshNumIndex.append(true)
        calc.operationStorage.append("")
        calc.numWordIntStorage.append(0)
        numWordStringStorage.append("")
        calc.processStringArray.append("")
       
        printProcess()
        index += 1
        
        
        
        
    }
    //MARK: - <#func clearPressed
    @IBAction func clearPressed(_ sender: UIButton) {
        index = 0
        calc.numWordIntStorage = [0]
        calc.operationStorage = [""]
        calc.processStringArray = [""]
        numWordStringStorage = [""]
        calc.processString = ""
        
        printProcess()
        processView.text = "0"
        isDeterminedAnswer = false
        
       //////result = 1.0 ???????
        result = 1.0
        answer = [1]
       
        freshNumIndex = [true]
        muldiOperIndex = [false]
        
        
       
        
        
    }
    //MARK: - <#func printProcess
    func printProcess(){
        processView.text = calc.processString
    }
    //MARK: - <#func ansPressed
    @IBAction func ansPressed(_ sender: UIButton) {
        calculateAns()
    }
    
    func calculateAns(){
        for i in 0 ... index-1 {
            print("check1")
            if muldiOperIndex[i]{
                print("check1.5")
                if calc.operationStorage[i] == "x" && (freshNumIndex[i] && freshNumIndex[i+1]){
                    print("check2")
                    answer[i] = Double(calc.numWordIntStorage[i]) * Double(calc.numWordIntStorage[i+1])
                    print("check3")
                    freshNumIndex[i] = false ; freshNumIndex[i+1] = false
                    print("check4")
                }else if calc.operationStorage[i] == "x" && !(freshNumIndex[i]){
                    print("check5")
                     answer[i] = answer[i-1] * Double(calc.numWordIntStorage[i+1])
                    print("check6")
                    freshNumIndex[i] = false ; freshNumIndex[i+1] = false
                    print("check6")
                }
                else if calc.operationStorage[i] == "/" && (freshNumIndex[i] && freshNumIndex[i+1]){
                    print("check7")
                    answer[i] = Double(calc.numWordIntStorage[i]) / Double(calc.numWordIntStorage[i+1])
                    print("check8")
                    freshNumIndex[i] = false ; freshNumIndex[i+1] = false
                }else if calc.operationStorage[i] == "/" && !(freshNumIndex[i]){
                    answer[i] = answer[i-1] / Double(calc.numWordIntStorage[i+1])
                    freshNumIndex[i] = false ; freshNumIndex[i+1] = false
                }
            } else {
                if calc.operationStorage[i] == "+"{
                    
                }else if calc.operationStorage[i] == "-"{
                }
            }
        }
        print(answer[index-1])
//        for i in 0 ... index-1 {
//            if !isDeterminedAnswer {
//            if calc.operationStorage[index-1-i] == "+" || calc.operationStorage[index-1-i] == "-"{
//                result = answer[index-1-i]; isDeterminedAnswer = true
//            }else {
//                result = answer[index-1]; isDeterminedAnswer = true
//                }
//            }
//        }
//        print(answer[index-1])
    }
}
