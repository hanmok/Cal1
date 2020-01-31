//
//  ViewController.swift
//  Cal1
//
//  Created by hanmok on 2020/01/25.
//  Copyright © 2020 hanmok. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var ansFindingIndex : Int?
    var isDeterminedAnswer = false
    var result : Double?
    var answer : [Double] = [1]
    var freshAnsIndex : [Int] = [0] // 0 :newly made, 1 : calculated, 2 : used
    var index = 0
    var freshNumIndex : [Bool] = [true]
    var muldiOperIndex : [Bool] = [false]
    var calc = CalculatorBasic()
    var numWordStringStorage = [""]
    var loopBreaker = false
    var loopBreaker2 = false
    
    
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
        if calc.DoubleStorage[index] <= 1e18{
            //prevents app from crushing of limit of Int number
            let myOptional = sender.currentTitle
            if let safeOptional = myOptional{
                numWordStringStorage[index] += String(safeOptional)
                calc.processString += String(safeOptional)
            }
            calc.DoubleStorage[index] = Double(numWordStringStorage[index])!
            print("numWordStringStorage[\(index)] :\(numWordStringStorage[index])")
            printProcess()
        }
    }
    //MARK: - <#func operationPressed
    @IBAction func operationPressed(_ sender: UIButton){
        //        print(sender.titleLabel!)
        if let operInput = sender.currentTitle{
            switch operInput{//operation String
            case "+" : calc.operationStorage[index] = "+"
            case "-" : calc.operationStorage[index] = "-"
            case "X" : calc.operationStorage[index] = "x"
            case "/" : calc.operationStorage[index] = "/"
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
        
        print("calc.operationStorage[\(index)] : \(calc.operationStorage[index])")
        
        freshNumIndex.append(true)
        freshAnsIndex.append(0)
        calc.operationStorage.append("")
        calc.DoubleStorage.append(0)
        numWordStringStorage.append("")
        calc.processStringArray.append("")
        printProcess()
        index += 1
    }
    
    //MARK: - <#func clearPressed
    @IBAction func clearPressed(_ sender: UIButton) {
        index = 0
        calc.DoubleStorage = [0]
        calc.operationStorage = [""]
        calc.processStringArray = [""]
        numWordStringStorage = [""]
        calc.processString = ""
        
        printProcess()
        processView.text = "0"
        isDeterminedAnswer = false
        
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
    
    func calculateAns(){//{d
        for i in 0 ... index-1 { // first for statement : for Operation == "x" or "/"
            if muldiOperIndex[i]{
                if calc.operationStorage[i] == "x" && (freshNumIndex[i] && freshNumIndex[i+1]){
                    //곱셈 , D[i]전항과 D[i+1]후항 존재, >> 두개 곱함.
                    answer[i] = calc.DoubleStorage[i] * calc.DoubleStorage[i+1]
                    freshAnsIndex[i] = 1;freshNumIndex[i] = false ; freshNumIndex[i+1] = false;
                    result = answer[i]; print("result1 (answer[\(i)]: \(result ?? answer[i])"); print("result1 (answer[\(i)]: \(String(describing: result))")
                }else if calc.operationStorage[i] == "x" && !(freshNumIndex[i]){
                    //곱셈, D[i]전항 존재 안할 때 >> A[i-1] * D[i+1]
                    answer[i] = answer[i-1] * calc.DoubleStorage[i+1]
                    freshAnsIndex[i] = 1;freshAnsIndex[i-1] = 2 ; freshNumIndex[i+1] = false
                    result = answer[i]; print("result2 (answer[\(i)]: \(result ?? answer[i])"); print("result2 : (answer[\(i)] \(String(describing: result))")
                    
                }
                else if calc.operationStorage[i] == "/" && (freshNumIndex[i] && freshNumIndex[i+1]){
                    answer[i] = calc.DoubleStorage[i] / calc.DoubleStorage[i+1]
                    freshAnsIndex[i] = 1;freshNumIndex[i] = false ; freshNumIndex[i+1] = false
                    result = answer[i]; print("result3 (answer[\(i)]: \(result ?? answer[i])"); print("result3 (answer[\(i)]: \(String(describing: result))")
                    
                }else if calc.operationStorage[i] == "/" && !(freshNumIndex[i]){
                    answer[i] = answer[i-1] / calc.DoubleStorage[i+1]
                    freshAnsIndex[i] = 1; freshAnsIndex[i-1] = 2 ; freshNumIndex[i+1] = false
                    result = answer[i]; print("result4 (answer[\(i)]: \(result ?? answer[i])"); print("result4 : (answer[\(i)] \(String(describing: result))")
                    
                }
            }
        }
        
        
        
        
        
        
        
        for i in 0 ... index-1 {  //  muldiOperIndex == false begins. ( Operator == "+" or "-" // {c
            if !muldiOperIndex[i]{ //{b
                // + or - 연산
                if calc.operationStorage[i] == "+"{// + 연산
                    if freshNumIndex[i+1]{
                        //+ 연산 >> D[i+1] 존재하는 경우.
                        if freshNumIndex[i]{
                            //+ 연산 >> D[i+1] 존재하는 경우. >> D[i] 존재하는 경우.
                            answer[i] = calc.DoubleStorage[i] + calc.DoubleStorage[i+1]
                            freshAnsIndex[i] = 1 ; freshNumIndex[i] = false ; freshNumIndex[i+1] = false
                            result = answer[i]; print("result5 (answer[\(i)]: \(result ?? answer[i])"); print("result5 : \(String(describing: result))")
                        } else if !freshNumIndex[i]{
                            //+ 연산 >> D[i+1] 존재하는 경우. >> D[i] 존재 ㄴㄴ
                            for k in 1 ... i{
//                                if k>1 {
                                    if (freshAnsIndex[i-k] == 1) && !loopBreaker2{
                                        answer[i] = answer[i-k] + calc.DoubleStorage[i+1]
                                        freshAnsIndex[i] = 1;freshAnsIndex[i-k] = 2 ; freshNumIndex[i+1] = false
                                        result = answer[i]; print("result6 : (answer[\(i)]\(result ?? answer[i])"); print("result6 (answer[\(i)]: \(String(describing: result))")
                                        
                                        loopBreaker2 = true
                                        
                                    }
//                                }
                            }
                            
                            loopBreaker2 = false
                        }
                    }else if !(freshNumIndex[i+1]){ // a-1
                        //+연산 >> D[i+1] 존재 ㄴㄴ
                        for k in i ... index-1 {
                            if !loopBreaker{ // what is this for? prevents several calculations on one operation.
                                if freshAnsIndex[k+1] == 1 {
                                    //+연산 >> D[i+1] 존재 ㄴㄴ >>Ans[k](k : i+1, i+2, ... index-1 존재
                                    if freshNumIndex[i]{
                                        //+연산 >> D[i+1] 존재 ㄴㄴ >>Ans[k](k : i+1, i+2, ... index-1 존재 >> D[i] 존재
                                        answer[i] = calc.DoubleStorage[i] + answer[k+1]
                                        print("Error finding3")
                                        freshAnsIndex[i] = 1; freshNumIndex[i] = false; freshAnsIndex[k+1] = 2;
                                        result = answer[i]; print("result7 (answer[\(i)]: \(result ?? answer[i])"); print("result7 (answer[\(i)]: \(String(describing: result))")
                                        //여기부터 문제되는 코드. !!
                                    }else if !freshNumIndex[i]{
                                        //+연산 >> D[i+1] 존재 ㄴㄴ >>Ans[k](k : i+1, i+2, ... index-1 존재 >> D[i] 존재 ㄴㄴ
                                        loopBreaker2 = false
                                        for j in 0 ... i{
                                            if (freshAnsIndex[i-j] == 1) && !loopBreaker2{
                                                //+연산 >> D[i+1] 존재 ㄴㄴ >>Ans[k](k>i) 존재 >> D[i] 존재 ㄴㄴ >> A[i-j](i-j < i) 존재
                                                answer[i] = answer[i-j] + answer[k+1]
                                                freshAnsIndex[i] = 1; freshAnsIndex[i-j] = 2; freshAnsIndex[k+1] = 2
                                                result = answer[i]; print("result8 (answer[\(i)]: \(result ?? answer[i])"); print("result8 (answer[\(i)]: \(String(describing: result))")
                                                
                                                loopBreaker2 = true
                                            }
                                        }
                                        loopBreaker2 = false
                                    }
                                }
                                loopBreaker = true
                            }
                            loopBreaker = false
                        }
                    } // a-1
                }
                    
                else if calc.operationStorage[i] == "-"{
                    if freshNumIndex[i+1]{
                        if freshNumIndex[i]{
                            answer[i] = calc.DoubleStorage[i] - calc.DoubleStorage[i+1]
                            result = answer[i]; print("result9 (answer[\(i)]: \(result ?? answer[i])"); print("result9 (answer[\(i)]: \(String(describing: result))")
                            freshNumIndex[i] = false ; freshNumIndex[i+1] = false
                        }else if !freshNumIndex[i] {
                            for k in 1 ... index-1{
                                if (freshAnsIndex[i-k] == 1) && !loopBreaker2{
                                    answer[i] = answer[i-k] - calc.DoubleStorage[i+1]
                                    result = answer[i]; print("result10 (answer[\(i)]: \(result ?? answer[i])"); print("result10 (answer[\(i)]: \(String(describing: result))")
                                    freshAnsIndex[i] = 1;freshAnsIndex[i-k] = 2 ; freshNumIndex[i+1] = false
                                    loopBreaker2 = true
                                }
                            }
                            loopBreaker2 = false
                        }
                    }else if !(freshNumIndex)[i+1]{
                        for k in i+1 ... index-1 {
                            if !loopBreaker{
                                if freshAnsIndex[k] == 1 {
                                    if freshNumIndex[i]{
                                        answer[i] = calc.DoubleStorage[i] - answer[k]
                                        result = answer[i]; print("result11 : \(result ?? answer[i])"); print("result11 : \(String(describing: result))")
                                        freshAnsIndex[i] = 1 ;freshAnsIndex[k] = 2; freshNumIndex[i] = false
                                    }else if !freshNumIndex[i]{
                                        for j in 0 ... index-1{
                                            if (freshAnsIndex[i-j] == 1) && !loopBreaker2{
                                                answer[i] = answer[i-j] + answer[k]
                                                result = answer[i]; print("result12 : \(result ?? answer[i])"); print("result12 : \(String(describing: result))")
                                                freshAnsIndex[i-j] = 2; freshAnsIndex[k] = 2
                                                loopBreaker2 = true
                                            }
                                        }
                                        loopBreaker2 = false
                                        loopBreaker = true
                                    }
                                }
                            }
                            loopBreaker = false
                        }
                    }
                }
            }
        }
    }
}
