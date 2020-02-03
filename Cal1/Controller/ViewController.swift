
import UIKit

class ViewController: UIViewController {
    
    var result : Double?
    var answer : [Double] = [1]
    var freshAI : [Int] = [0] // 0 :newly made, 1 : calculated, 2 : used
    var freshDI : [Bool] = [true]
    
    var index = 0
    var muldiOperIndex : [Bool] = [false]
    
    var tempDigits = [""]
    var loopBreaker = false
    var loopBreaker2 = false
    var dummyPasser = false
    var isFoundAns = false
    var clearAfterAns = false
    
    var calc = CalculatorBasic()
    
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
        resultView.text = ""
    }
    //MARK: - <#func numberPressed
    @IBAction func numberPressed(_ sender: UIButton){
        
        if clearAfterAns{
            clear()
            clearAfterAns = false
        }
        
        if calc.DS[index] <= 1e18{
//            let myOptional = sender.currentTitle
            if let safeOptional = sender.currentTitle{
                if !(safeOptional == ".") ||  !(tempDigits[index].contains(".")){
                    // double dots >> ignore the first dot.
                    
                    //if
                    if safeOptional != "." && tempDigits[index] == "0"{
                            let str1 = tempDigits[index].dropLast()
                            tempDigits[index] = String(str1)
                            
                            let str2 = calc.process.dropLast()
                            calc.process = String(str2)
                    }
                    tempDigits[index] += String(safeOptional)
                    // when dot clicked without any number prior to, it automatically input 0 before dot
                    //if input == . >> input = 0.
                    if tempDigits[index] == "."{
                        tempDigits[index] = "0."
                        calc.process += String("0.")
                    } else {
                        calc.process += String(safeOptional)
                    }
                }
            }
            calc.DS[index] = Double(tempDigits[index])!
            print("tempDigits[\(index)] :\(tempDigits[index])")
            printProcess()
        }
    }
    //MARK: - <#func operationPressed
    @IBAction func operationPressed(_ sender: UIButton){
        
        if let operInput = sender.currentTitle{
            if tempDigits[index] != ""{
                
                switch operInput{
                case "+" : calc.operationStorage[index] = "+"
                case "-" : calc.operationStorage[index] = "-"
                case "X" : calc.operationStorage[index] = "x"
                case "/" : calc.operationStorage[index] = "/"
                default: print("Operation Error!")
                }
            }else if tempDigits[index] == ""{
                
                switch operInput{
                case "+" : calc.operationStorage[index-1] = "+"
                case "-" : calc.operationStorage[index-1] = "-"
                case "X" : calc.operationStorage[index-1] = "x"
                case "/" : calc.operationStorage[index-1] = "/"
                default: print("Operation Error!")
                    
                }
            }
        }
        
        if tempDigits[index] != ""{
            if calc.operationStorage[index] == "x" || calc.operationStorage[index] == "/"{
                muldiOperIndex[index] = true
            } else if calc.operationStorage[index] == "+" || calc.operationStorage[index] == "-"{
                muldiOperIndex[index] = false
            }
        }else if tempDigits[index] == ""{
            if calc.operationStorage[index-1] == "x" || calc.operationStorage[index-1] == "/"{
                muldiOperIndex[index-1] = true
            } else if calc.operationStorage[index-1] == "+" || calc.operationStorage[index-1] == "-"{
                muldiOperIndex[index-1] = false}
            print("muldiOperIndex[\(index-1)] : \(muldiOperIndex[index-1])")
        }
        if tempDigits[index] != ""{
            calc.process += calc.operationStorage[index]
            print("calc.operationStorage[\(index)] : \(calc.operationStorage[index])")
        }else if tempDigits[index] == ""{
            let str = calc.process.dropLast()
            calc.process = String(str)
            calc.process += calc.operationStorage[index-1]
        }
        if tempDigits[index] != ""{
            if index >= 1{
                answer.append(1)
            }
            
            muldiOperIndex.append(false)
            freshDI.append(true)
            freshAI.append(0)
            calc.operationStorage.append("")
            calc.DS.append(0)
            tempDigits.append("")
            
            
            index += 1
        }
        printProcess()
    }
    
    //    }
    //MARK: - <#func clearPressed
    @IBAction func clearPressed(_ sender: UIButton) {
        clear()
        resultView.text = ""
        
    }
    //MARK: - <#func printProcess
    func printProcess(){
        processView.text = calc.process
    }
    //MARK: - <#func ansPressed
    @IBAction func ansPressed(_ sender: UIButton) {
        calculateAns()
    }
    
    func calculateAns(){//{d
        if index != 0 {
            for i in 0 ... index-1 { // first for statement : for Operation == "x" or "/"
                if muldiOperIndex[i]{
                    if calc.operationStorage[i] == "x" && (freshDI[i] && freshDI[i+1]){
                        //곱셈 , D[i]전항과 D[i+1]후항 존재, >> 두개 곱함.
                        answer[i] = calc.DS[i] * calc.DS[i+1]
                        freshAI[i] = 1 ; freshDI[i] = false ; freshDI[i+1] = false;
                        result = answer[i]; print("result1 (answer[\(i)]: \(result ?? answer[i])")
                    }else if calc.operationStorage[i] == "x" && !(freshDI[i]){
                        //곱셈, D[i]전항 존재 안할 때 >> A[i-1] * D[i+1]
                        answer[i] = answer[i-1] * calc.DS[i+1]
                        freshAI[i] = 1;freshAI[i-1] = 2 ; freshDI[i+1] = false
                        result = answer[i]; print("result2 (answer[\(i)]: \(result ?? answer[i])")
                    }
                    else if calc.operationStorage[i] == "/" && (freshDI[i] && freshDI[i+1]){
                        answer[i] = calc.DS[i] / calc.DS[i+1]
                        freshAI[i] = 1;freshDI[i] = false ; freshDI[i+1] = false
                        result = answer[i]; print("result3 (answer[\(i)]: \(result ?? answer[i])")
                    }else if calc.operationStorage[i] == "/" && !(freshDI[i]){
                        answer[i] = answer[i-1] / calc.DS[i+1]
                        freshAI[i] = 1; freshAI[i-1] = 2 ; freshDI[i+1] = false
                        result = answer[i]; print("result4 (answer[\(i)]: \(result ?? answer[i])");
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
                                result = answer[i]; print("result5 (answer[\(i)]: \(result ?? answer[i])")
                            } else if !freshDI[i]{
                                //+ 연산 >> D[i+1] 존재하는 경우. >> D[i] 존재 ㄴㄴ
                                for k in 1 ... i{
                                    if (freshAI[i-k] == 1) && !loopBreaker2{
                                        answer[i] = answer[i-k] + calc.DS[i+1]
                                        freshAI[i] = 1;freshAI[i-k] = 2 ; freshDI[i+1] = false
                                        result = answer[i]; print("result6 : (answer[\(i)]\(result ?? answer[i])")
                                        loopBreaker2 = true
                                    }
                                }
                                loopBreaker2 = false
                            }
                        }else if !(freshDI[i+1]){
                            //+연산 >> D[i+1] 존재 ㄴㄴ
                            for k in i ... index-1 {
                                print("loopBreaker : \(loopBreaker)")
                                if !loopBreaker{ // what is this for? prevents several calculations on one operation.
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
                                            result = answer[i]; print("result7 (answer[\(i)]: \(result ?? answer[i])")
                                            
                                        }else if !freshDI[i]{
                                            //+연산 >> D[i+1] 존재 ㄴㄴ >>Ans[k](k : i+1, i+2, ... index-1 존재 >> D[i] 존재 ㄴㄴ
                                            loopBreaker2 = false
                                            for j in 0 ... i{
                                                if (freshAI[i-j] == 1) && !loopBreaker2{
                                                    //+연산 >> D[i+1] 존재 ㄴㄴ >>Ans[k](k>i) 존재 >> D[i] 존재 ㄴㄴ >> A[i-j](i-j < i) 존재
                                                    answer[i] = answer[i-j] + answer[k+1]
                                                    freshAI[i] = 1; freshAI[i-j] = 2; freshAI[k+1] = 2
                                                    result = answer[i]; print("result8 (answer[\(i)]: \(result ?? answer[i])")
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
                        }
                    }
                    else if calc.operationStorage[i] == "-"{
                        if freshDI[i+1]{
                            //뒤 D[i+1] 존재
                            if freshDI[i]{
                                //뒤 D[i+1] 존재 >> 앞 D[i] 존재
                                answer[i] = calc.DS[i] - calc.DS[i+1]
                                freshAI[i] = 1 ; freshDI[i] = false ; freshDI[i+1] = false
                                result = answer[i]; print("result9 (answer[\(i)]: \(result ?? answer[i])")
                            }else if !freshDI[i] {
                                //뒤 D[i+1] 존재 >> 앞 D[i] 존재 ㄴㄴ
                                for k in 1 ... i{
                                    if (freshAI[i-k] == 1) && !loopBreaker2{
                                        answer[i] = answer[i-k] - calc.DS[i+1]
                                        freshAI[i] = 1;freshAI[i-k] = 2 ; freshDI[i+1] = false
                                        result = answer[i]; print("result10 (answer[\(i)]: \(result ?? answer[i])")
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
                                            result = answer[i]; print("result11 : \(result ?? answer[i])")
                                            
                                        }else if !freshDI[i]{
                                            // 뒤 D[i+1] 존재 ㄴㄴ >> 뒤 A[k+1] >> 앞 D[i] 존재 ㄴㄴ
                                            loopBreaker2 = false
                                            for j in 0 ... i{
                                                if (freshAI[i-j] == 1) && !loopBreaker2{
                                                    answer[i] = answer[i-j] - answer[k+1]
                                                    freshAI[i] = 1; freshAI[i-j] = 2; freshAI[k+1] = 2
                                                    result = answer[i]; print("result12 : \(result ?? answer[i])")
                                                    
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
                    clearAfterAns = true
                    //                    isFoundAns = true
                    let intDecider = Int(answer[u])
                    if answer[u] - Double(intDecider) == 0 {
                        resultView.text = String(Int(answer[u]))
                    }else {
                        resultView.text = String(format : "%.1f", answer[u])
                    }
                }
                
            }
            
            
            // index != 0 인 경우 호출되는 함수 영역.
            //index == 0 인 경우 호출되는 함수 .
        }else {
            clearAfterAns = true
            //        if !isFoundAns{
            
            let intDecider = Int(calc.DS[0])
            if (calc.DS[0] - Double(intDecider)) == 0 {
                resultView.text = String(Int(calc.DS[0]))
            } else {
                resultView.text = String(format : "%.1f", calc.DS[0])
            }
        }
        //        }
    } // end of function calculateAns
    
    func clear(){
        index = 0
        calc.DS = [0]
        calc.operationStorage = [""]
        
        tempDigits = [""]
        calc.process = ""
        
        printProcess()
        processView.text = "0"
        //        resultView.text = ""
        
        
        answer = [1]
        
        freshDI = [true]
        muldiOperIndex = [false]
    }
}


