
import UIKit

class ViewController: UIViewController {
    var saveResult : Double? // if one want operate after press ans button, this value will come up and used.
    var result : Double? // to be printed, one of the answer array.
    var answer : [Double] = [100] // the default value, which helps indicate the error.
    var freshAI : [Int] = [0] // 0 :newly made, 1 : calculated, 2 : used
    var freshDI : [Int] = [0] // 0 : newly made, 1: got UserInput, 2 : used
    
    var index = 0 // increase after pressing operation button.
    var muldiOperIndex : [Bool] = [false] // true if it is x or / .
    
    var tempStorage : Int = 0
    var tempDigits = [""] // save all digits to make a number ( in numberPresed)
    
    var loopBreaker = false
    var loopBreaker2 = false
    var dummyPasser = false
    var isFoundAns = false
    
    var clearAfterAns = false
    var noNumberAfterOperator = false
    
    var process = ""
    var DS = [0.0]
    // a number made by numberStorage[]
    var operationStorage = [""]
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
        //initial settings, empty screen with 0 in the processView.
        processView.isUserInteractionEnabled = false
        resultView.isUserInteractionEnabled = false
        processView.text = "0"
        resultView.text = ""
    }
    //MARK: - <#func numberPressed
    @IBAction func numberPressed(_ sender: UIButton){
        print("clearAfterAns : \(clearAfterAns)")
        print(" process : \( process)")
        
        //clear states after got answer
        if clearAfterAns{
            clear()
            //list for clear function.
            //            index = 0
            //             DS = [0]
            //             operationStorage = [""]
            //            tempDigits = [""]
            //            printProcess()
            //            answer = [300] // for error check.
            //            freshDI = [0]
            //            muldiOperIndex = [false]
            resultView.text = ""
            processView.text = "0"
            process = ""
            clearAfterAns = false
        }
        
        // if made number is not greater than it's limit
        if  DS[index] <= 1e18{
            // set each input digit on the digitInput.
            if let digitInput = sender.currentTitle{
                
                //                tempDigits : temporal Storage for number until user finish set a number
                // ignore double dot on one number input. On usual case, this if statement execute.(usual np-a)
                if !(digitInput == ".") || !(tempDigits[index].contains(".")){
                    
                    //                    tempDigit[index] : user number input immediately before digitInput
                    //if user input 01 02 03 .. 09 , automatically change it to 1, 2, 3, ... 9 (ex)
                    if digitInput != "." && tempDigits[index] == "0"{
                        //var tempDigits = [""]
                        let str1 = tempDigits[index].dropLast()
                        tempDigits[index] = String(str1)
                        
                        let str2 =  process.dropLast()
                        process = String(str2)
//                when dot clicked without any number prior to, it automatically input 0 before dot. (. >> 0.0)(ex)
                    }else if tempDigits[index] == "."{
                        tempDigits[index] = "0."
                        process += String("0.")
                    } else { // usual case
                        process += String(digitInput)
                        tempDigits[index] += digitInput
                    }

                } // np-a
                //                                    tempDigits[index] += String(digitInput)
            }
            //input tempDigits[index] to  DS, with changing freshDI with 1 which means it recived a user input.
            DS[index] = Double(tempDigits[index])!
            freshDI[index] = 1
            
            //            print("tempDigits[\(index)] :\(tempDigits[index])")
            printProcess()
            //            processView.text =  process
        }
    }
    
    
    
    //MARK: - <#func operationPressed
    @IBAction func operationPressed(_ sender: UIButton){
        
        if let operInput = sender.currentTitle{
            // normal case, number input exist before operator input
            if tempDigits[index] != ""{
                
                switch operInput{
                case "+" :  operationStorage[index] = "+"
                case "-" :  operationStorage[index] = "-"
                case "X" :  operationStorage[index] = "x"
                case "/" :  operationStorage[index] = "/"
                default: print("Operation Error!")
                }
                if  operationStorage[index] == "x" ||  operationStorage[index] == "/"{
                    muldiOperIndex[index] = true
                } else if  operationStorage[index] == "+" ||  operationStorage[index] == "-"{
                    muldiOperIndex[index] = false
                }
                
                
                process +=  operationStorage[index]
                
                //abnormal case, no number input before operator input.
            }else if tempDigits[index] == ""{
                if index == 0 {
                    if saveResult != nil {
                        clearAfterAns = false
                        clear()
                        process = String(saveResult!)
                        print(" process = String(saveResult!)")
                        DS[0] = saveResult!
                        freshDI[index] = 1
                        print(" DS[0] asd: \( DS[0])")
                        clearAfterAns = false
                        
                        switch operInput{
                        case "+" :  operationStorage[index] = "+"
                        case "X" :  operationStorage[index] = "x"
                        case "-" :  operationStorage[index] = "-"
                        case "/" :  operationStorage[index] = "/"
                        default: print("Operation Error!")
                        }
                        if  operationStorage[index] == "x" ||  operationStorage[index] == "/"{
                            muldiOperIndex[index] = true
                        } else if  operationStorage[index] == "+" ||  operationStorage[index] == "-"{
                            muldiOperIndex[index] = false
                        }
                        
                        process +=  operationStorage[index]
                    }
                }
                
                if index != 0 {
                    //                if saveResult != nil && index == 0 {
                    //                    tempStorage =
                    //                }
                    switch operInput{
                    case "+" :  operationStorage[index-1] = "+"
                    case "-" :  operationStorage[index-1] = "-"
                    case "X" :  operationStorage[index-1] = "x"
                    case "/" :  operationStorage[index-1] = "/"
                    default: print("Operation Error!")
                        
                    }
                    if  operationStorage[index-1] == "x" ||  operationStorage[index-1] == "/"{
                        muldiOperIndex[index-1] = true
                    } else if  operationStorage[index-1] == "+" ||  operationStorage[index-1] == "-"{
                        muldiOperIndex[index-1] = false}
                    
                    
                    let str =  process.dropLast()
                    process = String(str)
                    process +=  operationStorage[index-1]
                }
            }
            
            
            
        }
        if tempDigits[index] != ""{
            if index >= 1{
                answer.append(200) // for error checking
            }
            indexUpdate()
        }
        printProcess()
    }
    
    //    }
    //MARK: - <#func clearPressed
    @IBAction func clearPressed(_ sender: UIButton) {
        clear()
        resultView.text = ""
        processView.text = "0"
        saveResult = nil
        
    }
    
    //MARK: - <#func ansPressed
    @IBAction func ansPressed(_ sender: UIButton) {
        calculateAns()
    }
    
    func calculateAns(){//{d
        if index != 0 {
            for i in 0 ... index-1 { // first for statement : for Operation == "x" or "/"
                if muldiOperIndex[i]{
                    if  freshDI[i] == 1 && freshDI[i+1] == 1{
                        //곱셈 , D[i]전항과 D[i+1]후항 존재, >> 두개 곱함.
                        if  operationStorage[i] == "x" {
                            answer[i] =  DS[i] *  DS[i+1]
                        }else if  operationStorage[i] == "/"{
                            answer[i] =  DS[i] /  DS[i+1]
                        }
                        freshAI[i] = 1 ; freshDI[i] = 2 ; freshDI[i+1] = 2;
                        result = answer[i]; print("result1 (answer[\(i)]: \(result ?? answer[i])")
                    }else if  freshDI[i] == 2 && freshDI[i+1] == 1{
                        //곱셈, D[i]전항 존재 안할 때 >> A[i-1] * D[i+1]
                        if  operationStorage[i] == "x"{
                            answer[i] = answer[i-1] *  DS[i+1]
                        }else if  operationStorage[i] == "/"{
                            answer[i] = answer[i-1] /  DS[i+1]
                        }
                        freshAI[i] = 1;freshAI[i-1] = 2 ; freshDI[i+1] = 2
                        result = answer[i]; print("result2 (answer[\(i)]: \(result ?? answer[i])")
                    }
                }
            }
            
            
            
            
            for i in 0 ... index-1 {  //  muldiOperIndex == false begins. ( Operator == "+" or "-" // {c
                print("+/- index start : \(i)")
                if !muldiOperIndex[i]{ //{b
                    // + or - 연산
                    if freshDI[i+1] == 1{
                        //+ 연산 >> D[i+1] 존재하는 경우.
                        if freshDI[i] == 1{
                            //+ 연산 >> D[i+1] 존재하는 경우. >> D[i] 존재하는 경우.
                            if  operationStorage[i] == "+"{
                                answer[i] =  DS[i] +  DS[i+1]
                            } else if  operationStorage[i] == "-"{
                                answer[i] =  DS[i] -  DS[i+1]
                            }
                            
                            freshAI[i] = 1 ; freshDI[i] = 2 ; freshDI[i+1] = 2
                            result = answer[i]; print("result5 (answer[\(i)]: \(result ?? answer[i])")
                        } else if freshDI[i] == 2{
                            //+ 연산 >> D[i+1] 존재하는 경우. >> D[i] 존재 ㄴㄴ
                            for k in 1 ... i{
                                //freshAI[i-k] 찾은 경우
                                if (freshAI[i-k] == 1) && !loopBreaker2{
                                    if  operationStorage[i] == "+"{
                                        answer[i] = answer[i-k] +  DS[i+1]
                                    }else if  operationStorage[i] == "-"{
                                        answer[i] = answer[i-k] -  DS[i+1]
                                    }
                                    freshAI[i] = 1;freshAI[i-k] = 2 ; freshDI[i+1] = 2
                                    result = answer[i]; print("result6 : (answer[\(i)]\(result ?? answer[i])")
                                    loopBreaker2 = true
                                }
                            }
                            loopBreaker2 = false
                        }
                    }else if freshDI[i+1] == 2{
                        //  D[i+1] 존재 ㄴㄴ
                        for k in i ... index-1 {
                            print("loopBreaker : \(loopBreaker)")
                            if !loopBreaker{ // prevents several calculations on one operation.
                                print("loopBreaker passed")
                                //if freshAI[k+1] found A[k+1] 존재
                                if freshAI[k+1] == 1 {
                                    dummyPasser = true
                                    print("freshAI[\(i)] = \(freshAI[i])")
                                    //  D[i+1] 존재 ㄴㄴ >>Ans[k+1](k : i, i+1, ... index-1 존재, DI[i] 존재
                                    if freshDI[i] == 1{
                                        print("freshDI[\(i)] passed")
                                        if  operationStorage[i] == "+"{
                                            answer[i] =  DS[i] + answer[k+1]
                                        }else if  operationStorage[i] == "-"{
                                            answer[i] =  DS[i] - answer[k+1]
                                        }
                                        print("Error finding3")
                                        freshAI[i] = 1; freshDI[i] = 2; freshAI[k+1] = 2;
                                        result = answer[i]; print("result7 (answer[\(i)]: \(result ?? answer[i])")
                                        
                                    }else if freshDI[i] == 2{
                                        //+연산 >> D[i+1] 존재 ㄴㄴ >>Ans[k](k : i+1, i+2, ... index-1 존재 >> D[i] 존재 ㄴㄴ
                                        //                                            loopBreaker2 = false
                                        for j in 1 ... i{
                                            if (freshAI[i-j] == 1) && !loopBreaker2{
                                                //+연산 >> D[i+1] 존재 ㄴㄴ >>Ans[k](k>i) 존재 >> D[i] 존재 ㄴㄴ >> A[i-j](i-j < i) 존재
                                                if  operationStorage[i] == "+"{
                                                    answer[i] = answer[i-j] + answer[k+1]
                                                } else if  operationStorage[i] == "-"{
                                                    answer[i] = answer[i-j] - answer[k+1]
                                                }
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
            }
            
            for u in 0 ... index-1
            {
                //                print("freshAI[\(u)] : \(freshAI[u])")
                if freshAI[u] == 1{
                    print("freshDI[\(u+1)] : \(freshDI[u+1])")
                    print(" DS[\(u+1)] : \( DS[u+1])")
                    
                    if freshDI[index] == 0{
                        let str2 =  process.dropLast()
                        //                        let str3 = str2.dropLast()
                        process = String(str2)
                        print("whatthe...")
                        
                    }
                    // if found ans, in case 5+=
                    isFoundAns = true
                    clearAfterAns = true
                    floatingNumberDecider(ans: answer[u])
                }
            }
            // in case of not founding ans, which means only one number and operator were input
            if !isFoundAns{
                clearAfterAns = true
                let str2 =  process.dropLast()
                process = String(str2)
                floatingNumberDecider(ans:  DS[0])
            }
            // 여기까지 index != 0 인 경우 호출되는 함수 영역.
            
            
            //index == 0 인 경우 호출되는 함수 .
        }else {
            //            print("freshDI[1] = \(freshDI[1])")
            clearAfterAns = true
            //        if !isFoundAns{
            floatingNumberDecider(ans:  DS[0])
            saveResult =  DS[0]
            
        }
        //        if freshDI[i] == true{
        
        //        }
        //        }
        printProcess()
        clear()
        
    } // end of function calculateAns
    
    
    //MARK: - <#func clear
    func clear(){
        index = 0
        DS = [0]
        operationStorage = [""]
        tempDigits = [""]
        
        printProcess()
        
        answer = [300] // for error check.
        freshDI = [0]
        muldiOperIndex = [false]
        //        processView.text = "0"
        //         process = ""
        //        saveResult = nil // apply only when pressed clear Button
    }
    //MARK: - <#func indexUpdate
    func indexUpdate(){
        muldiOperIndex.append(true)
        freshDI.append(0)
        freshAI.append(0)
        operationStorage.append("")
        DS.append(0)
        tempDigits.append("")
        index += 1
    }
    //MARK: - <#func printProcess
    func printProcess(){
        processView.text =  process
    }
    //MARK: - <#func floatingNumberDecider
    func floatingNumberDecider(ans : Double){
        var escape = false
        for i in 0 ... 10{
            let decider = Int(ans * pow(10.0, Double(i)))
            if (ans * pow(10.0,Double(i)) - Double(decider) == 0) && !escape {
                escape = true
                saveResult = Double(String(format : "%.\(i)f", ans))
                resultView.text = "\(String(format : "%.\(i)f", ans))"
            }
        }
        // if one decimal point excced 10, it prints till 6th decimal places
        if escape == false{
            resultView.text = "\(String(format : "%.6f", ans))"
        }
    }
    //print up to 6 digits after floating poing depending on the result
    
}



