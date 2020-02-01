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
    
    var numChecker = false
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
        print("index : \(index)")
        //        if numWordStringStorage[index] != ""{
        //        print(sender.titleLabel!)
        
        if let operInput = sender.currentTitle{
            if numWordStringStorage[index] != ""{
                //정상적인 경우
                switch operInput{//operation String
                case "+" : calc.operationStorage[index] = "+"
                case "-" : calc.operationStorage[index] = "-"
                case "X" : calc.operationStorage[index] = "x"
                case "/" : calc.operationStorage[index] = "/"
                default: print("other buttons pressed")
                calc.operationStorage[index] = "operation button error"
                }
            }else if numWordStringStorage[index] == ""{
                //비정상적인 경우.
                switch operInput{//operation String
                case "+" : calc.operationStorage[index-1] = "+"
                case "-" : calc.operationStorage[index-1] = "-"
                case "X" : calc.operationStorage[index-1] = "x"
                case "/" : calc.operationStorage[index-1] = "/"
                default: print("other buttons pressed")
                calc.operationStorage[index-1] = "operation button error"
                }
            }
        }
        //calc.operationStorage[index-1] = "opearation "
        
        
        print("pass 1")
        if numWordStringStorage[index] != ""{
            //정상적인 경우
            
            print("정상적인 경우, numWordStringStorage[\(index)]  : \(numWordStringStorage[index]) ")
            if calc.operationStorage[index] == "x" || calc.operationStorage[index] == "/"{
                print("p 1.3")
                muldiOperIndex[index] = true
                print("p 1.5")
            } else if calc.operationStorage[index] == "+" || calc.operationStorage[index] == "-"{
                print("p 1.7")
                muldiOperIndex[index] = false
            }
            print("muldiOperIndex[\(index)] : \(muldiOperIndex[index])")
        }else if numWordStringStorage[index] == ""{
            print("비정상적인 경우, numWordStringStorage[\(index-1)] : \(numWordStringStorage[index-1])")
            //비정상적인 경우.
            if calc.operationStorage[index-1] == "x" || calc.operationStorage[index-1] == "/"{
                muldiOperIndex[index-1] = true
            } else if calc.operationStorage[index-1] == "+" || calc.operationStorage[index-1] == "-"{
                muldiOperIndex[index-1] = false}
            print("muldiOperIndex[\(index-1)] : \(muldiOperIndex[index-1])")
        }
        print("pass2")
        
        if numWordStringStorage[index] != ""{
            //정상적인 경우.
            calc.processString += calc.operationStorage[index]
            print("calc.operationStorage[\(index)] : \(calc.operationStorage[index])")
            print("pass 3")
        }else if numWordStringStorage[index] == ""{
            //비정상적인 경우.
            let str = calc.processString.dropLast()
            //            print(str)
            calc.processString = String(str)
            //전에 입력받은 수식을 걷어냄.
            calc.processString += calc.operationStorage[index-1]
            //            print(myString)
            //            calc.processString
            //            calc.processString += calc.operationStorage[index-1]
        }
        print("pass 4")
        
        
        
        
        if numWordStringStorage[index] != ""{
            //전 넘버가 공백이 아닐 때에만 실행. 정상인 경우에만 실행!
            //실행하지 말것.
            if index >= 1{
//                muldiOperIndex.append(false)
                answer.append(1)
            }
            muldiOperIndex.append(false)
            
            
            
            //실행하지 말것.
            freshDI.append(true)
            freshAI.append(0)
            calc.operationStorage.append("")
            calc.DS.append(0)
            numWordStringStorage.append("")
            calc.processStringArray.append("")
            
            index += 1
        }
        printProcess()
    }
    
    //    }
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
                                    dummyPasser = true
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
                                if dummyPasser{loopBreaker = true}
                            }
                        }
                        loopBreaker = false
                        dummyPasser = false
                    }
                }
            }
        }
        for u in 0 ... index-1
        {
            if freshAI[u] == 1{
                let intDecider = Int(answer[u])
                if answer[u] - Double(intDecider) == 0 {
                    resultView.text = String(Int(answer[u]))
                }else {
                    resultView.text = String(format : "%.2f", answer[u])
                }
            }
            
        } // end of function
    }
}
