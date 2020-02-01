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
    var freshAI : [Int] = [0] // 0 :newly made, 1 : calculated, 2 : used
    var index = 0
    var freshDI : [Bool] = [true]
    var muldiOperIndex : [Bool] = [false]
    var calc = CalculatorBasic()
    var numWordStringStorage = [""]
    var loopBreaker = false
    var loopBreaker2 = false
    var dummyPasser = false
    var dummyPasser2 = false


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
        if calc.DS[index] <= 1e18{
            //prevents app from crushing of limit of Int number
            let myOptional = sender.currentTitle
            if let safeOptional = myOptional{
                numWordStringStorage[index] += String(safeOptional)
                calc.processString += String(safeOptional)
            }
            calc.DS[index] = Double(numWordStringStorage[index])!
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
        
        freshDI.append(true)
        freshAI.append(0)
        calc.operationStorage.append("")
        calc.DS.append(0)
        numWordStringStorage.append("")
        calc.processStringArray.append("")
        printProcess()
        index += 1
    }
    //MARK: - <#func clearPressed
    @IBAction func clearPressed(_ sender: UIButton) {
        index = 0
        calc.DS = [0]
        calc.operationStorage = [""]
        calc.processStringArray = [""]
        numWordStringStorage = [""]
        calc.processString = ""
        
        printProcess()
        processView.text = "0"
        isDeterminedAnswer = false
        
        answer = [1]
        
        freshDI = [true]
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
                if calc.operationStorage[i] == "x" && (freshDI[i] && freshDI[i+1]){
                    //곱셈 , D[i]전항과 D[i+1]후항 존재, >> 두개 곱함.
                    answer[i] = calc.DS[i] * calc.DS[i+1]
                    freshAI[i] = 1 ; freshDI[i] = false ; freshDI[i+1] = false;
                    result = answer[i]; print("result1 (answer[\(i)]: \(result ?? answer[i])"); print("result1 (answer[\(i)]: \(String(describing: result))")
                }else if calc.operationStorage[i] == "x" && !(freshDI[i]){
                    //곱셈, D[i]전항 존재 안할 때 >> A[i-1] * D[i+1]
                    answer[i] = answer[i-1] * calc.DS[i+1]
                    freshAI[i] = 1;freshAI[i-1] = 2 ; freshDI[i+1] = false
                    result = answer[i]; print("result2 (answer[\(i)]: \(result ?? answer[i])"); print("result2 : (answer[\(i)] \(String(describing: result))")
                }
                else if calc.operationStorage[i] == "/" && (freshDI[i] && freshDI[i+1]){
                    answer[i] = calc.DS[i] / calc.DS[i+1]
                    freshAI[i] = 1;freshDI[i] = false ; freshDI[i+1] = false
                    result = answer[i]; print("result3 (answer[\(i)]: \(result ?? answer[i])"); print("result3 (answer[\(i)]: \(String(describing: result))")
                    
                }else if calc.operationStorage[i] == "/" && !(freshDI[i]){
                    answer[i] = answer[i-1] / calc.DS[i+1]
                    freshAI[i] = 1; freshAI[i-1] = 2 ; freshDI[i+1] = false
                    result = answer[i]; print("result4 (answer[\(i)]: \(result ?? answer[i])"); print("result4 : (answer[\(i)] \(String(describing: result))")
                }
            }
        }
        
        
        
        for i in 0 ... index-1 {  //  muldiOperIndex == false begins. ( Operator == "+" or "-" // {c
            print("+/- index start : \(i)")
            if !muldiOperIndex[i]{ //{b
                // + or - 연산
                if calc.operationStorage[i] == "+"{// + 연산
                    if freshDI[i+1]{
                        //+ 연산 >> D[i+1] 존재하는 경우.
                        if freshDI[i]{
                            //+ 연산 >> D[i+1] 존재하는 경우. >> D[i] 존재하는 경우.
                            answer[i] = calc.DS[i] + calc.DS[i+1]
                            freshAI[i] = 1 ; freshDI[i] = false ; freshDI[i+1] = false
                            result = answer[i]; print("result5 (answer[\(i)]: \(result ?? answer[i])"); print("result5 : \(String(describing: result))")
                        } else if !freshDI[i]{
                            //+ 연산 >> D[i+1] 존재하는 경우. >> D[i] 존재 ㄴㄴ
                            for k in 1 ... i{
//                                if k>1 {
                                    if (freshAI[i-k] == 1) && !loopBreaker2{
                                        answer[i] = answer[i-k] + calc.DS[i+1]
                                        freshAI[i] = 1;freshAI[i-k] = 2 ; freshDI[i+1] = false
                                        result = answer[i]; print("result6 : (answer[\(i)]\(result ?? answer[i])"); print("result6 (answer[\(i)]: \(String(describing: result))")
                                        loopBreaker2 = true
                                    }
                            }
                            loopBreaker2 = false
                        }
                    }else if !(freshDI[i+1]){ // a-1
                        //+연산 >> D[i+1] 존재 ㄴㄴ
                        for k in i ... index-1 {
                            print("loopBreaker : \(loopBreaker)")
                            if !loopBreaker{ // what is this for? prevents several calculations on one operation.
                                //freshAI[k+1] 값 하나 찾았으면 그만 돌려라 . 근데 지금 하나도 못찾고 날라가는중..
                                print("loopBreaker passed")
                                if freshAI[k+1] == 1 {
                                    dummyPasser = true
                                    print("freshAI[\(i)] = \(freshAI[k+1])")
                                    //+연산 >> D[i+1] 존재 ㄴㄴ >>Ans[k](k : i+1, i+2, ... index-1 존재
                                    if freshDI[i]{
                                        print("freshDI[\(i)] passed")
                                        //+연산 >> D[i+1] 존재 ㄴㄴ >>Ans[k](k : i+1, i+2, ... index-1 존재 >> D[i] 존재
                                        answer[i] = calc.DS[i] + answer[k+1]
                                        print("Error finding3")
                                        freshAI[i] = 1; freshDI[i] = false; freshAI[k+1] = 2;
                                        result = answer[i]; print("result7 (answer[\(i)]: \(result ?? answer[i])"); print("result7 (answer[\(i)]: \(String(describing: result))")
                                        //여기부터 문제되는 코드. !!
                                    }else if !freshDI[i]{
                                        //+연산 >> D[i+1] 존재 ㄴㄴ >>Ans[k](k : i+1, i+2, ... index-1 존재 >> D[i] 존재 ㄴㄴ
                                        loopBreaker2 = false
                                        for j in 0 ... i{
                                            if (freshAI[i-j] == 1) && !loopBreaker2{
                                                //+연산 >> D[i+1] 존재 ㄴㄴ >>Ans[k](k>i) 존재 >> D[i] 존재 ㄴㄴ >> A[i-j](i-j < i) 존재
                                                answer[i] = answer[i-j] + answer[k+1]
                                                freshAI[i] = 1; freshAI[i-j] = 2; freshAI[k+1] = 2
                                                result = answer[i]; print("result8 (answer[\(i)]: \(result ?? answer[i])"); print("result8 (answer[\(i)]: \(String(describing: result))")
                                                loopBreaker2 = true
                                            }
                                        }
                                        loopBreaker2 = false
                                    }
                                }
                                if dummyPasser {loopBreaker = true}
                            }
                        }
                        dummyPasser = false
                        loopBreaker = false
                    } // a-1
                }
                    
                else if calc.operationStorage[i] == "-"{
                    if freshDI[i+1]{
                        //뒤 D[i+1] 존재
                        if freshDI[i]{
                            //뒤 D[i+1] 존재 >> 앞 D[i] 존재
                            answer[i] = calc.DS[i] - calc.DS[i+1]
                            freshAI[i] = 1 ; freshDI[i] = false ; freshDI[i+1] = false
                            result = answer[i]; print("result9 (answer[\(i)]: \(result ?? answer[i])"); print("result9 (answer[\(i)]: \(String(describing: result))")
                        }else if !freshDI[i] {
                            //뒤 D[i+1] 존재 >> 앞 D[i] 존재 ㄴㄴ
                            for k in 1 ... i{
                                if (freshAI[i-k] == 1) && !loopBreaker2{
                                    answer[i] = answer[i-k] - calc.DS[i+1]
                                    freshAI[i] = 1;freshAI[i-k] = 2 ; freshDI[i+1] = false
                                    result = answer[i]; print("result10 (answer[\(i)]: \(result ?? answer[i])"); print("result10 (answer[\(i)]: \(String(describing: result))")
                    
                                    loopBreaker2 = true
                                }
                            }
                            loopBreaker2 = false
                        }
                    }else if !(freshDI[i+1]){
                        // 뒤 D[i+1] 존재 ㄴㄴ
                        for k in i ... index-1 {
                            if !loopBreaker{
                                if freshAI[k+1] == 1 {
                                    // 뒤 A[k+1] 찾음.
                                    dummyPasser2 = true
                                    if freshDI[i]{
                                        //뒤 D[i+1] 존재 ㄴㄴ >> 뒤 A[k+1] >> 앞 D[i] 존재
                                        answer[i] = calc.DS[i] - answer[k+1]
                                        freshAI[i] = 1 ;freshDI[i] = false ; freshAI[k+1] = 2
                                        result = answer[i]; print("result11 : \(result ?? answer[i])"); print("result11 : \(String(describing: result))")
                                       
                                    }else if !freshDI[i]{
                                        // 뒤 D[i+1] 존재 ㄴㄴ >> 뒤 A[k+1] >> 앞 D[i] 존재 ㄴㄴ
                                        loopBreaker2 = false
                                        for j in 0 ... i{
                                            if (freshAI[i-j] == 1) && !loopBreaker2{
                                                answer[i] = answer[i-j] - answer[k+1]
                                                freshAI[i] = 1; freshAI[i-j] = 2; freshAI[k+1] = 2
                                                result = answer[i]; print("result12 : \(result ?? answer[i])"); print("result12 : \(String(describing: result))")
                                                
                                                loopBreaker2 = true
                                            }
                                        }
                                        loopBreaker2 = false
                                    }
                                }
                                if dummyPasser2{loopBreaker = true}
                            }
                        }
                        loopBreaker = false
                        dummyPasser2 = false
                    }
                }
            }
        }
    }
}
