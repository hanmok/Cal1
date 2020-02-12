//MARK: - <#default setup
import UIKit

class ViewController: UIViewController {
    var saveResult : Double? // if one want operate after press ans button, this value will come up and used.
    var result : Double? // to be printed, one of the answer array.
    var answer : [[Double]] = [[100]] // the default value, which helps indicate the error.
    var freshAI = [[0]] // 0 :newly made, 1 : calculated, 2 : used
    var freshDI = [[0]] // 0 : newly made, 1: got UserInput, 2 : used
    var DS = [[0.0]] // Double Numbers Storage
    var operationStorage = [[""]]
    var parenthesisStorage = [[Int]]()
    var pi = 0 // index for parenthesis.
    var ni = [0] // increase after pressing operation button.
    var niStartStorage = [[0]] // remember the indexes to calculate (within parenthesis)
    var niEndStorage = [[0]]
    var muldiOperIndex = [[false]] // true if it is x or / .
    var indexPivotHelper = [false]
    var positionOfParenthe = [[Int]]() // remember the position of empty DS
    var tempDigits = [[""]] // save all digits to make a number
    var clearAfterAns = false
    var negativeSign = false
    var process = ""
    var isParenClosed = false
    var piMax = 0
    
    
    @IBOutlet weak var leftParenthesis: UIButton!
    @IBOutlet weak var rightParenthesis: UIButton!
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
        //        print("clearAfterAns : \(clearAfterAns)")
        //        ni[pi] = ni[pi] + DSindexPivot[pi]
        
        //clear states after got answer
        if clearAfterAns{
            clear()
            resultView.text = ""
            processView.text = "0"
            process = ""
            clearAfterAns = false
        }// end if clearAfterAns
        
        // if made number is not greater than it's limit
        if DS[pi][ni[pi]] <= 1e18{ // starts DS[pi][ni[pi]] <= 1e18
            
            // set each input digit on the digitInput.
            if let digitInput = sender.currentTitle{
                
                // tempDigits : temporal Storage for number until user finish set a number
                // ignore double dot on one number input. On usual case, this if statement execute.(usual)
                if !(digitInput == ".") || !(tempDigits[pi][ni[pi]].contains(".")){
                    
                    //var tempDigits = [""]
                    // tempDigit[ni[pi]] : user number input just before digitInput
                    // tempDigits[pi][ni[pi]] == 00, 01, 02, ... 09
                    //if user input 01 02 03 .. 09 , automatically change it to 1, 2, 3, ... 9 (exceptional)
                    if digitInput != "." && tempDigits[pi][ni[pi]] == "0" {
                        let str1 = tempDigits[pi][ni[pi]].dropLast()
                        tempDigits[pi][ni[pi]] = String(str1)
                        tempDigits[pi][ni[pi]] += digitInput
                        
                        let str2 = process.dropLast()
                        process = String(str2)
                        process += digitInput
                        
                        //when dot clicked without any number prior to, it automatically input 0 before dot. (. >> 0.0)(ex)
                    }else if tempDigits[pi][ni[pi]] == "" && digitInput == "."{
                        tempDigits[pi][ni[pi]] = "0."
                        process += String("0.")
                    }else if ((ni[pi]) == 0) && negativeSign{
                        tempDigits[pi][ni[pi]] += "-"
                        tempDigits[pi][ni[pi]] += digitInput
                        process = "-"
                        process += String(digitInput)
                        negativeSign = false
                    }else { // usual case
                        tempDigits[pi][ni[pi]] += digitInput
                        process += String(digitInput)
                    }
                } // end of Not doubleDot Case
                else if digitInput == "." && tempDigits[pi][ni[pi]].contains("."){
                }
            } // end if let digitInput = sender.currentTitle{
            
            if tempDigits[pi][ni[pi]] != "0."{
                if let safeDigits = Double(tempDigits[pi][ni[pi]]){
                    DS[pi][ni[pi]] = safeDigits
                    freshDI[pi][ni[pi]] = 1
                }
            }
            //input tempDigits[pi][ni[pi]] to  DS, with changing freshDI with 1 which means it recived a user input.
            printProcess()
            //            processView.text =  process
        } // end of DS[pi][ni[pi]] <= 1e18
    }
    
    //MARK: - <#func operationPressed
    @IBAction func operationPressed(_ sender: UIButton){
        if let operInput = sender.currentTitle{
            //              abnormal case, no number input before operator button pressed.
            print("path1")
            if tempDigits[pi][ni[pi]] == ""{
                print("path2")
                if pi == 0 && ni[0] == 0 && saveResult != nil{
                    
                    print("path3")
                    clearAfterAns = false//why? to prevent reexcxcuteclear function in the numberPressed func.
                    clear()
                    
                    DS[0][0] = saveResult!
                    saveResult = nil
                    freshDI[0][0] = 1 //allocated 1 to freshDI cause it initialized with number not be changed.
                    if (DS[0][0] - Double(Int(DS[0][0])) == 0){ process = String(format : "%.0f", DS[0][0])}
                    else {process = String(DS[0][0])}
                    // edition needed to print it without decimal pojnt in case of this value is integer
                    
                    operinputSetup(tempOperInput: operInput, tempi: ni[0])
                    process += operationStorage[0][0]
                    answer[0].append(200) // for error checking
                    indexUpdate()
                    printProcess()
                } // end if pi == 0 && ni == 0 && saveResult != nil{
                else if ni[pi] == 0 && operInput == "-"{ // if operation before the first number is "-"
                    print("path4")
                    negativeSign = true
                    process += "-"
                }// if the other operation comes first before number >> ignore .
                else if ni[pi] == 0 && (operInput == "+" || operInput == "X" || operInput == "/"){
                    print("path5")
                    process += ""
                } // end of pi == 0 && ni[0] == 0 && saveResult != nil { else if .
                
                // if tempDigits[pi][ni[pi]] == ""{
                //in case no number input before second following operator , replace prior one with new oper input.(Double Operator)(no index and answer update.)
                print("tempDigits : \(tempDigits)")
                if ni[pi] != 0 && !isParenClosed{//여기 걸리면 앙대...
                    print("tempDigits[pi][ni[pi]] : \(tempDigits[pi][ni[pi]])")
                    print("path6")
                    operinputSetup(tempOperInput: operInput, tempi: ni[pi]-1)
                    print("path7")
                    let str =  process.dropLast()
                    process = String(str)
                    process += operationStorage[pi][ni[pi]-1]
                    print("path8")
                }
                // normal case, number input exist before operator input
            } // if tempDitis[pi][ni[pi]] == "" else~ (the other case)
            else if tempDigits[pi][ni[pi]] != ""{
                print("path9")
                operinputSetup(tempOperInput: operInput, tempi: ni[pi])
                print("path10")
                process += operationStorage[pi][ni[pi]]
                print("path11")
                print(answer)
                answer[pi].append(200) // for error checking
                print("path12")
                //                print("\(ni)")
                //                print("\(tempDigits)")
                //                print("\(DS)")
                print("\(freshDI)")
                print("\(freshAI)")
                print("\(muldiOperIndex)")
                print("\(operationStorage)")
                indexUpdate()
                print("path13")
            } // tempDigigits[ni[pi]] != ""
            print("path14")
            printProcess()
            
            
            
            print("path15")
        } //  end of if let operInput = sender.currentTitle
        print("path16")
        isParenClosed = false
    }
    
    
    
    //MARK: - <#func calculation
    func calculateAns(){//{d
        niStartStorage[0].append(0)
        niEndStorage[0].append(ni[0])
        pi = piMax
        while pi >= 0 {
            for a in 1 ... niStartStorage[pi].count-1{
                for i in niStartStorage[pi][a] ... niEndStorage[pi][a]{

                 // first for statement : for Operation == "x" or "/"
                    if muldiOperIndex[pi][i]{
                        if  freshDI[pi][i] == 1 && freshDI[pi][i+1] == 1{
                            //곱셈 , D[i]전항과 D[i+1]후항 존재, >> 두개 곱함.
                            if  operationStorage[pi][i] == "x" {
                                answer[pi][i] =  DS[pi][i] *  DS[pi][i+1]
                            }else if  operationStorage[pi][i] == "/"{
                                answer[pi][i] =  DS[pi][i] /  DS[pi][i+1]
                            }
                            freshAI[pi][i] = 1 ; freshDI[pi][i] = 2 ; freshDI[pi][i+1] = 2;
                            result = answer[pi][i]; print("result1 (answer[[\(i)]]: \(result ?? answer[pi][i])")
                        }else if  freshDI[pi][i] == 2 && freshDI[pi][i+1] == 1{
                            //곱셈, D[i]전항 존재 안할 때 >> A[i-1] * D[i+1]
                            if  operationStorage[pi][i] == "x"{
                                answer[pi][i] = answer[pi][i-1] *  DS[pi][i+1]
                            }else if  operationStorage[pi][i] == "/"{
                                answer[pi][i] = answer[pi][i-1] /  DS[pi][i+1]
                            }
                            freshAI[pi][i] = 1;freshAI[pi][i-1] = 2 ; freshDI[pi][i+1] = 2
                            result = answer[pi][i]; print("result2 (answer[[\(i)]]: \(result ?? answer[pi][i])")
                        }
                    }
                } // end for i in 0 ... ni-1
                
                for i in niStartStorage[pi][a] ... niEndStorage[pi][a]{  //  muldiOperIndex == false begins. ( Operator == "+" or "-" // {c
                    print("for i in 0 ... ni[pi]-1 {")
                    if !muldiOperIndex[pi][i]{ //{b
                        print(" if !muldiOperIndex[pi][i]{")
                        // + or - 연산
                        if freshDI[pi][i+1] == 1{
                            print("if freshDI[pi][i+1] == 1{")
                            //+ 연산 >> D[i+1] 존재하는 경우.
                            if freshDI[pi][i] == 1{
                                print("  if freshDI[pi][i] == 1{")
                                //+ 연산 >> D[i+1] 존재하는 경우. >> D[i] 존재하는 경우.
                                
                                if  operationStorage[pi][i] == "+"{
                                    print(" if  operationStorage[pi][i] == "+"{")
                                    print("answer[[\(i)]] =  DS[[\(i)]] +  DS[[\(i+1)]] : \(answer[pi][i]) =  \(DS[pi][i]) +  \(DS[pi][i+1])")
                                    
                                    answer[pi][i] =  DS[pi][i] +  DS[pi][i+1]
                                    print("answer[pi][i] =  DS[pi][i] +  DS[pi][i+1]")
                                } else if  operationStorage[pi][i] == "-"{
                                    answer[pi][i] =  DS[pi][i] -  DS[pi][i+1]
                                }
                                freshAI[pi][i] = 1 ; freshDI[pi][i] = 2 ; freshDI[pi][i+1] = 2
                                //                            print("freshAI[\(i)] : \(freshAI[pi][i]), freshDI[\(i)] : \(freshDI[pi][i]), freshDI[\(i+1)] : \(freshDI[i+1])") 여기 라인 이상해 !!
                                result = answer[pi][i]; print("result5 (answer[[\(i)]]: \(result ?? answer[pi][i])")
                            } else if freshDI[pi][i] == 2{
                                //+ 연산 >> D[i+1] 존재하는 경우. >> D[i] 존재 ㄴㄴ
                                for k in 1 ... i{
                                    //freshAI[i-k] 찾은 경우
                                    if (freshAI[pi][i-k] == 1){
                                        if  operationStorage[pi][i] == "+"{
                                            answer[pi][i] = answer[pi][i-k] +  DS[pi][i+1]
                                        }else if  operationStorage[pi][i] == "-"{
                                            answer[pi][i] = answer[pi][i-k] -  DS[pi][i+1]
                                        }
                                        freshAI[pi][i] = 1;freshAI[pi][i-k] = 2 ; freshDI[pi][i+1] = 2
                                        result = answer[pi][i]; print("result6 : (answer[[\(i)]]\(result ?? answer[pi][i])")
                                    }
                                }
                            }
                        }else if freshDI[pi][i+1] == 2{
                            //  D[i+1] 존재 ㄴㄴ
                            noLatterNum : for k in i ... ni[pi]-1 {
                                //if freshAI[k+1] found
                                if freshAI[pi][k+1] == 1 {
                                    //  D[i+1] 존재 ㄴㄴ >>Ans[k](k :  i+1, ... ni) 존재 >>  DI[i] 존재
                                    if freshDI[pi][i] == 1{
                                        if  operationStorage[pi][i] == "+"{
                                            answer[pi][i] =  DS[pi][i] + answer[pi][k+1]}
                                        else if  operationStorage[pi][i] == "-"{
                                            answer[pi][i] =  DS[pi][i] - answer[pi][k+1]}
                                        freshAI[pi][i] = 1; freshDI[pi][i] = 2; freshAI[pi][k+1] = 2;
                                        break noLatterNum
                                        //+연산 >> D[i+1] 존재 ㄴㄴ >>Ans[k](k : i+1, i+2, ... ni-1 존재 >> D[i] 존재 ㄴㄴ
                                    }else if freshDI[pi][i] == 2{
                                        foundPriorAns : for j in 1 ... i{
                                            if (freshAI[pi][i-j] == 1){
                                                //+연산 >> D[i+1] 존재 ㄴㄴ >>Ans[k](k>i) 존재 >> D[i] 존재 ㄴㄴ >> A[i-j](i-j < i) 존재
                                                if  operationStorage[pi][i] == "+"{
                                                    answer[pi][i] = answer[pi][i-j] + answer[pi][k+1]
                                                } else if  operationStorage[pi][i] == "-"{
                                                    answer[pi][i] = answer[pi][i-j] - answer[pi][k+1]
                                                }
                                                freshAI[pi][i] = 1; freshAI[pi][i-j] = 2; freshAI[pi][k+1] = 2
                                                result = answer[pi][i]; print("result8 (answer[[\(i)]]: \(result ?? answer[pi][i])")
                                                break noLatterNum
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                } // end of all calculations.
                for i in niStartStorage[pi][a] ..< niEndStorage[pi][a]{
                    if freshAI[pi][i] == 1{ // 답을 못찾는 경우도 구해야함. .. 괄호 안에 항이 하나이거나 전체 항이 하나. 연산 없이.
                        clearAfterAns = true
                        result = answer[pi][i]
                        break
                    }
                    if i == niEndStorage[pi][a]-1 {
                        result = DS[pi][0]
                    }
                }
                if pi > 0{
                    DS[pi-1][positionOfParenthe[pi][a]] = result!
                }
            } // end of for a in 1 ... niStartStorage[pi].count-1{
            
            
            if pi == 0 {
                floatingNumberDecider(ans: result!)
                break
            }else {
                pi -= 1
                continue
            }
        } // end pi >= 0
    } // end of function calculateAns
    
    
//        }
//        //let's find Answer !
//        for u in 0 ... ni[pi]
//        {
//            if freshAI[pi][u] == 1{
//                floatingNumberDecider(ans: answer[pi][u])
//                break
//                //                    floatingNumberDecider(ans: result!)
//            }
//            // in case of not finding ans, which means only one number and operator were input
//            if u == ni[pi]{
//                let str2 =  process.dropLast()
//                process = String(str2)
//                floatingNumberDecider(ans: DS[pi][0])
//            }
//        }
//        clearAfterAns = true
//        printProcess()
//        clear()
//    }// end of function calculateAns
    
    //            if pi >= 0{
    //                print("pi : \(pi)")
    //                pi -= 1
    //                print("pi : \(pi)")
    //                continue
    //            }
    
    //MARK: - <#func clearPressed
    @IBAction func clearPressed(_ sender: UIButton) {
        clear()
        resultView.text = ""
        processView.text = "0"
        saveResult = nil
        process = ""
        negativeSign = false
        clearAfterAns = false
    }
    
    //MARK: - <#func setups
    func clear(){
        ni = [0]
        pi = 0
        DS = [[0.0]]
        tempDigits = [[""]]
        printProcess()
        answer = [[300]] // for error check.
        freshDI = [[0]]
        freshAI = [[0]]
        operationStorage = [[""]]
        muldiOperIndex = [[false]]
        result = 0
        parenthesisStorage = [[0]]
        //        DSindexPivot = [0]
        //        processView.text = "0"
        //         process = ""
        //        saveResult = nil // apply only when pressed clear Button
    }
    
    func indexUpdate(){
        ni[pi] += 1
        tempDigits[pi].append("")
        DS[pi].append(0)
        freshDI[pi].append(0)
        freshAI[pi].append(0)
        muldiOperIndex[pi].append(true)
        operationStorage[pi].append("")
    }
    
    func printProcess(){
        processView.text = process
    }
    
    //print up to 6 floating places
    func floatingNumberDecider(ans : Double){
        var escape = false
        for i in 0 ... 6{
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
    
    
    @IBAction func ansPressed(_ sender: UIButton) {
        calculateAns()
    }
    
    func operinputSetup(tempOperInput : String, tempi : Int){
        switch tempOperInput{
        case "+" :  operationStorage[pi][tempi] = "+"
        case "X" :  operationStorage[pi][tempi] = "x"
        case "-" :  operationStorage[pi][tempi] = "-"
        case "/" :  operationStorage[pi][tempi] = "/"
        default: print("operationStorage[\(tempi)] :\(operationStorage[pi][tempi]) ")
        }
        if  operationStorage[pi][tempi] == "x" ||  operationStorage[pi][tempi] == "/"{
            muldiOperIndex[pi][tempi] = true}
        else if operationStorage[pi][tempi] == "+" ||  operationStorage[pi][tempi] == "-"{
            muldiOperIndex[pi][tempi] = false}
    }
    
    @IBAction func parenthesisPressed(_ sender: UIButton) {
        if let parenthe = sender.currentTitle{
            if parenthe == "("{
                process += parenthe
                printProcess()
                
                ni.append(0)
                
                //for index range .
                DS.append([0])
                freshDI.append([0])
                tempDigits.append(["a"])
                operationStorage.append([""])
                muldiOperIndex.append([false])
                answer.append([150])
                freshAI.append([0])
                
                indexPivotHelper.append(false)
                niStartStorage.append([0])
                
                positionOfParenthe.append([0])
                positionOfParenthe[pi].append(ni[pi]+1)
                
                // for space for answer
                DS[pi].append(0)
                freshDI[pi].append(0)
                
                tempDigits[pi][ni[pi]] = "paren"
                pi += 1
                if pi > piMax{
                    piMax = pi
                }
                if indexPivotHelper[pi]{
                    ni[pi] += 1
                }
                niStartStorage[pi].append(ni[pi])
            }else if (pi != 0) && parenthe == ")"{
                niEndStorage.append([0])
                niEndStorage[pi].append(ni[pi])
                operationStorage.append([""])
                operationStorage[pi].append("")
                muldiOperIndex.append([false])
                muldiOperIndex[pi].append(false)
                isParenClosed = true
                indexPivotHelper[pi] = true
                tempDigits[pi].append("c")
                
                pi -= 1
                print("parenthe : \(parenthe)")
                process += parenthe
            }
            printProcess()
        }
    }
}
