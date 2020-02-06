//MARK: - <#default setup
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
            print("index : \(index)")
            print("1")
            // set each input digit on the digitInput.
            if let digitInput = sender.currentTitle{
                print("2")
                //                tempDigits : temporal Storage for number until user finish set a number
                // ignore double dot on one number input. On usual case, this if statement execute.(usual np-a)
                if !(digitInput == ".") || !(tempDigits[index].contains(".")){
                    print("3")
                    //                    tempDigit[index] : user number input just before digitInput
                    //if user input 01 02 03 .. 09 , automatically change it to 1, 2, 3, ... 9 (ex)
                    if digitInput != "." && tempDigits[index] == "0" { // tempDigits[index] == 00, 01, 02, ... 09
                        print(4)
                        //var tempDigits = [""]
                        
                        let str1 = tempDigits[index].dropLast()
                        tempDigits[index] = String(str1)
                        tempDigits[index] += digitInput
                        
                        let str2 = process.dropLast()
                        process = String(str2)
                        process += digitInput
                      
                        //                when dot clicked without any number prior to, it automatically input 0 before dot. (. >> 0.0)(ex)
                    }else if tempDigits[index] == "" && digitInput == "."{
                        print(5)
                        tempDigits[index] = "0."
                        process += String("0.")
                    } else { // usual case
                        print(6)
                        tempDigits[index] += digitInput
                        process += String(digitInput)
                    }
                    
                }else if digitInput == "." && tempDigits[index].contains("."){
                    print(7)
                }
                //                                    tempDigits[index] += String(digitInput)
            }
            if tempDigits[index] != "0."{
                print(8)
                if let safeDigits = Double(tempDigits[index]){
                    print(9)
                DS[index] = safeDigits
                 freshDI[index] = 1
                }
            }
            //input tempDigits[index] to  DS, with changing freshDI with 1 which means it recived a user input.
            printProcess()
            //            processView.text =  process
        }
    }
    
    
    
    //MARK: - <#func operationPressed
    @IBAction func operationPressed(_ sender: UIButton){
        if let operInput = sender.currentTitle{
            //              abnormal case, no number input before operator button pressed.
            //            print("index in operationPressed : \(index)")
            print("path 1, DS[0] : \(DS[0])")
            if tempDigits[index] == ""{
                print("path 2 DS[0] : \(DS[0])")
                if index == 0 && saveResult != nil{
                    print("path 3 DS[0] : \(DS[0])")
                    clearAfterAns = false//why? to prevent reexcxcuteclear function in the numberPressed func.
                    clear()
                    DS[0] = saveResult!
                    freshDI[index] = 1 //allocated 1 to freshDI cause it initialized with number not be changed.
                    if (DS[0] - Double(Int(DS[0])) == 0){ process = String(format : "%.0f", DS[0])
                    }else {process = String(DS[0])}
                     // edition needed to print it without decimal pojnt in case of this value is integer
                    
                    operinputSetup(tempOperInput: operInput, tempIndex: index)
                    process +=  operationStorage[index]
                    answer.append(200) // for error checking
                    indexUpdate()
                    //in case no number input before operator input, replace prior one with new input.(Double Operator)(no index and answer update.)
                }
                print("path 4 DS[0] : \(DS[0])")
                if index != 0 {
                    print("path 5 DS[0] : \(DS[0])")
//                    operinputSetup(tempOperInput: operInput, tempIndex: index-1)
                    switch operInput{
                    case "+" :  operationStorage[index-1] = "+"
                    case "X" :  operationStorage[index-1] = "x"
                    case "-" :  operationStorage[index-1] = "-"
                    case "/" :  operationStorage[index-1] = "/"
                    default: print("operationStorage[\(index-1)] :\(operationStorage[index-1]) ")
                    }
                    print("operationStorage[\(index-1)] : \(operationStorage[index-1])")
                    if  operationStorage[index-1] == "x" ||  operationStorage[index-1] == "/"{
                        muldiOperIndex[index-1] = true
                    } else if  operationStorage[index-1] == "+" ||  operationStorage[index-1] == "-"{
                        muldiOperIndex[index-1] = false
                    }
                    print("muldiOperIndex[\(index-1)] :  \(muldiOperIndex[index-1])")
                    
                    let str =  process.dropLast()
                    process = String(str)
                    process += operationStorage[index-1]
                }
                // normal case, number input exist before operator input
            } else if tempDigits[index] != ""{
                print("path 6 DS[0] : \(DS[0])")
                operinputSetup(tempOperInput: operInput, tempIndex: index)
                process +=  operationStorage[index]
                answer.append(200) // for error checking
                indexUpdate()
            }
            print("path 7 DS[0] : \(DS[0]) ")
            printProcess()
        } //  if let operInput = sender.currentTitle ends.
    }
    //list of indexUpdate()
    //    muldiOperIndex.append(true)
    //    freshDI.append(0)
    //    freshAI.append(0)
    //    operationStorage.append("")
    //    DS.append(0)
    //    tempDigits.append("")
    //    index += 1
    
    //    }
    
    func calculateAns(){//{d
        if index != 0 {
            for i in 0 ... index-1 { // first for statement : for Operation == "x" or "/"
                print("DS[\(index)] : \(DS[index])")
                print("OperationStorage[\(index)] : \(operationStorage[index])")
                print("어디냐1")
                if muldiOperIndex[i]{
                    print("muldiOperIndex[\(i)] : \(muldiOperIndex[i])")
                    print("어디냐2")
                    if  freshDI[i] == 1 && freshDI[i+1] == 1{
                        print("어디냐3")
                        //곱셈 , D[i]전항과 D[i+1]후항 존재, >> 두개 곱함.
                        if  operationStorage[i] == "x" {
                            print("어디냐4")
                            answer[i] =  DS[i] *  DS[i+1]
                        }else if  operationStorage[i] == "/"{
                            print("어디냐5")
                            answer[i] =  DS[i] /  DS[i+1]
                        }
                        print("어디냐6")
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
                print("어디냐7")
                if !muldiOperIndex[i]{ //{b
                    print("어디냐8")
                    // + or - 연산
                    if freshDI[i+1] == 1{
                        print("어디냐9")
                        //+ 연산 >> D[i+1] 존재하는 경우.
                        if freshDI[i] == 1{
                            //+ 연산 >> D[i+1] 존재하는 경우. >> D[i] 존재하는 경우.
                            if  operationStorage[i] == "+"{
                                print("answer[\(i)] =  DS[\(i)] +  DS[\(i+1)] : \(answer[i]) =  \(DS[i]) +  \(DS[i+1])")
                                answer[i] =  DS[i] +  DS[i+1]
                               
                            } else if  operationStorage[i] == "-"{
                                answer[i] =  DS[i] -  DS[i+1]
                            }
                            
                            freshAI[i] = 1 ; freshDI[i] = 2 ; freshDI[i+1] = 2
                            print("freshAI[\(i)] : \(freshAI[i]), freshDI[\(i)] : \(freshDI[i]), freshDI[\(i+1)] : \(freshDI[i+1])")
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
                print("answer[\(u)] :\(answer[u]) ")
                print("freshAI[\(u)] :\(freshAI[u]) ")
                //                print("freshAI[\(u)] : \(freshAI[u])")
                if freshAI[u] == 1{
                    print("freshDI[\(u+1)] : \(freshDI[u+1])")
                    print(" DS[\(u+1)] : \( DS[u+1])")
                    
                    if freshDI[index] == 0{
                        let str2 =  process.dropLast()
                        process = String(str2)
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
            floatingNumberDecider(ans:  DS[0])
        }
        printProcess()
        clear()
        
    } // end of function calculateAns
    
    
    //MARK: - <#func clearPressed
    @IBAction func clearPressed(_ sender: UIButton) {
        clear()
        //        index = 0
        //        DS = [0]
        //        operationStorage = [""]
        //        tempDigits = [""]
        //        printProcess()
        //        answer = [300] // for error check.
        //        freshDI = [0]
        //        muldiOperIndex = [false]
        resultView.text = ""
        processView.text = "0"
        saveResult = nil
        process = ""
        
    }
    
   //MARK: - <#func setups
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
    
    func indexUpdate(){
        muldiOperIndex.append(true)
        freshDI.append(0)
        freshAI.append(0)
        operationStorage.append("")
        DS.append(0)
        tempDigits.append("")
        index += 1
    }
    
    func printProcess(){
        processView.text = process
    }
   
    func floatingNumberDecider(ans : Double){
        var escape = false
        for i in 0 ... 10{
            let decider = Int(ans * pow(10.0, Double(i)))
            if (ans * pow(10.0,Double(i)) - Double(decider) == 0) && !escape {
                escape = true
                saveResult = ans
                resultView.text = "\(String(format : "%.\(i)f", ans))"
                print("ans : \(ans)")
            }
        }
        // if one decimal point excced 10, it prints till 6th decimal places
        if escape == false{
            resultView.text = "\(String(format : "%.6f", ans))"
            saveResult = ans
        }
    }
    //print up to 6 digits after floating poing depending on the result
    
    
    @IBAction func ansPressed(_ sender: UIButton) {
        calculateAns()
    }
    
    func operinputSetup(tempOperInput : String, tempIndex : Int){
        switch tempOperInput{
        case "+" :  operationStorage[tempIndex] = "+"
        case "X" :  operationStorage[tempIndex] = "x"
        case "-" :  operationStorage[tempIndex] = "-"
        case "/" :  operationStorage[tempIndex] = "/"
        default: print("operationStorage[\(tempIndex)] :\(operationStorage[tempIndex]) ")
        }
        if  operationStorage[tempIndex] == "x" ||  operationStorage[tempIndex] == "/"{
            muldiOperIndex[tempIndex] = true
        } else if  operationStorage[index] == "+" ||  operationStorage[tempIndex] == "-"{
            muldiOperIndex[tempIndex] = false
        }
    }
}
