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
        //stateTempDigits(pointNumber: 1)
        //stateCheck(pointNumber: 1)
        //clear states after got answer
        if clearAfterAns{
            clear()
            resultView.text = ""
            processView.text = "0"
            process = ""
            clearAfterAns = false
        }// end if clearAfterAns
        
        // if made number is not greater than it's limit
        print("Here?")
        if DS[pi][ni[pi]] <= 1e18{ // starts DS[pi][ni[pi]] <= 1e18
            print("여기인가?")
            // set each input digit on the digitInput.
            if let digitInput = sender.currentTitle{
                //stateTempDigits(pointNumber: 2)
                
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
                //stateTempDigits(pointNumber: 3)
                if let safeDigits = Double(tempDigits[pi][ni[pi]]){
                    //stateTempDigits(pointNumber: 4)
                    DS[pi][ni[pi]] = safeDigits
                    //stateTempDigits(pointNumber: 5)
                    freshDI[pi][ni[pi]] = 1
                    //stateTempDigits(pointNumber: 6)
                }
            }
            //input tempDigits[pi][ni[pi]] to  DS, with changing freshDI with 1 which means it recived a user input.
            printProcess()
            //            processView.text =  process
        } // end of DS[pi][ni[pi]] <= 1e18
        //stateTempDigits(pointNumber: 3)
    }
    
    
    //MARK: - <#func operationPressed
    @IBAction func operationPressed(_ sender: UIButton){
        //stateCheck(pointNumber: 2)
        if let operInput = sender.currentTitle{
            
            //              abnormal case, no number input before operator button pressed.
            if tempDigits[pi][ni[pi]] == ""{
                if pi == 0 && ni[0] == 0 && saveResult != nil{
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
                    negativeSign = true
                    process += "-"
                }// if the other operation comes first before number >> ignore .
                else if ni[pi] == 0 && (operInput == "+" || operInput == "X" || operInput == "/"){
                    process += ""
                } // end of pi == 0 && ni[0] == 0 && saveResult != nil { else if .
                // if tempDigits[pi][ni[pi]] == ""{
                //in case no number input before second following operator , replace prior one with new oper input.(Double Operator)(no index and answer update.)
                if ni[pi] != 0 {//여기 걸리면 앙대...
                    operinputSetup(tempOperInput: operInput, tempi: ni[pi]-1)
                    let str =  process.dropLast()
                    process = String(str)
                    process += operationStorage[pi][ni[pi]-1]
                }
                // normal case, number input exist before operator input
            } // if tempDitis[pi][ni[pi]] == "" else~ (the other case)
            else if tempDigits[pi][ni[pi]] != ""{
                print("check!!")
                print("ni : \(ni)")
                print("tempDigits : \(tempDigits)")
                print("operationStorage : \(operationStorage)")
                operinputSetup(tempOperInput: operInput, tempi: ni[pi])
                 print("operationStorage : \(operationStorage)")
                process += operationStorage[pi][ni[pi]]
                answer[pi].append(200) // for error checking
                indexUpdate()
            } // tempDigigits[ni[pi]] != ""
            printProcess()
        } //  end of if let operInput = sender.currentTitle
    }
    
    
    
    //MARK: - <#func calculation
    func calculateAns(){//{d
        //stateCheck(pointNumber: 3)
        niStartStorage[0].append(0)
        niEndStorage[0].append(ni[0])
        pi = piMax
        print("path1")
        while pi >= 0 {
                    print("path2")
            for a in 1 ... niStartStorage[pi].count-1{
                
                for i in niStartStorage[pi][a] ..< niEndStorage[pi][a]{
                 // first for statement : for Operation == "x" or "/"
                    if muldiOperIndex[pi][i]{
                        if  freshDI[pi][i] == 1 && freshDI[pi][i+1] == 1{
                            //곱셈 , D[i]전항과 D[i+1]후항 존재, >> 두개 곱함.
                            if  operationStorage[pi][i] == "x" {
                                answer[pi][i] =  DS[pi][i] *  DS[pi][i+1]
                            }else if  operationStorage[pi][i] == "/"{
                                answer[pi][i] =  DS[pi][i] /  DS[pi][i+1]
                            }
                            freshAI[pi][i] = 1 ; freshDI[pi][i] = 2 ; freshDI[pi][i+1] = 2;print("p 8")
                            result = answer[pi][i]
//                            print("result1 (answer[[\(i)]]: \(result ?? answer[pi][i])")
                        }else if  freshDI[pi][i] == 2 && freshDI[pi][i+1] == 1{
                            //곱셈, D[i]전항 존재 안할 때 >> A[i-1] * D[i+1]
                            if  operationStorage[pi][i] == "x"{
                                answer[pi][i] = answer[pi][i-1] *  DS[pi][i+1]
                            }else if  operationStorage[pi][i] == "/"{
                                answer[pi][i] = answer[pi][i-1] /  DS[pi][i+1]
                            }
                            freshAI[pi][i] = 1;freshAI[pi][i-1] = 2 ; freshDI[pi][i+1] = 2
                            result = answer[pi][i];
//                            print("result2 (answer[[\(i)]]: \(result ?? answer[pi][i])")
                        }
                    }
                } // end for i in niStartStorage[pi][a] ... niEndStorage[pi][a]{
                        print("path7")
                print("freshDI : \(freshDI)")
                print("niStartStorage : \(niStartStorage)")
                print("niEndStorage : \(niEndStorage)")
                print("muldiOperIndex : \(muldiOperIndex)")
                for i in niStartStorage[pi][a] ..< niEndStorage[pi][a]{  //  muldiOperIndex == false begins. ( Operator == "+" or "-" // {c
                    if !muldiOperIndex[pi][i]{ //{b
                        // + or - 연산
                        print("p1")
                        print("freshDI : \(freshDI)")
                        if freshDI[pi][i+1] == 1{
                            print("p2")
                            //+ 연산 >> D[i+1] 존재하는 경우.
                            if freshDI[pi][i] == 1{
                                print("p3")
                                //+ 연산 >> D[i+1] 존재하는 경우. >> D[i] 존재하는 경우.
                                if  operationStorage[pi][i] == "+"{
                                    answer[pi][i] =  DS[pi][i] +  DS[pi][i+1]
                                } else if  operationStorage[pi][i] == "-"{
                                    answer[pi][i] =  DS[pi][i] -  DS[pi][i+1]
                                }
                                freshAI[pi][i] = 1 ; freshDI[pi][i] = 2 ; freshDI[pi][i+1] = 2
                                //                            print("freshAI[\(i)] : \(freshAI[pi][i]), freshDI[\(i)] : \(freshDI[pi][i]), freshDI[\(i+1)] : \(freshDI[i+1])") 여기 라인 이상해 !!
                                print("point 1")
                                result = answer[pi][i]; print("result5 (answer[[\(i)]]: \(result ?? answer[pi][i])")
                                print("point 2")
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
                        print("path9")
                for i in niStartStorage[pi][a] ..< niEndStorage[pi][a]{
                            print("path10")
                    if freshAI[pi][i] == 1{ // 답을 못찾는 경우도 구해야함. .. 괄호 안에 항이 하나이거나 전체 항이 하나. 연산 없이.
                                print("path11")
                        clearAfterAns = true
                        result = answer[pi][i]
                                print("path12")
                        break
                    }
                            print("path13")
                    if i == niEndStorage[pi][a]-1 {
                                print("path14")
                        result = DS[pi][0]
                    }
                }
                        print("path15")
                if pi > 0{
                            print("path16")
                    print("a : \(a)")
                     print("pi : \(pi)")
                    print("DS : \(DS)")
                   
                    DS[pi-1][positionOfParenthe[pi-1][a]] = result!
                    freshDI[pi-1][positionOfParenthe[pi-1][a]] = 1
                            print("path17")
                }
            } // end of for a in 1 ... niStartStorage[pi].count-1{
                    print("path18")
            if pi == 0 {
                        print("path19")
                floatingNumberDecider(ans: result!)
                print("DS : \(DS)")
                print("answer : \(answer)")
                        print("path20")
                break
            }else {
                pi -= 1
                continue
            }
        } // end pi >= 0
    } // end of function calculateAns
    

    //MARK: - <#func clearPressed
    @IBAction func clearPressed(_ sender: UIButton) {
        clear()
        resultView.text = ""
        processView.text = "0"
        saveResult = nil
        process = ""
        negativeSign = false
        clearAfterAns = false
//        ni = [0]
//        pi = 0
//        DS = [[0.0]]
//        tempDigits = [[""]]
//        printProcess()
//        answer = [[300]] // for error check.
//        freshDI = [[0]]
//        freshAI = [[0]]
//        operationStorage = [[""]]
//        muldiOperIndex = [[false]]
//        result = 0
//        parenthesisStorage = [[0]]
        indexPivotHelper = [false]
        positionOfParenthe = [[Int]]()
        
        niStartStorage = [[0]]
        niEndStorage = [[0]]
        piMax = 0
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
        result = nil
        parenthesisStorage = [[Int]]()
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
        //stateCheck(pointNumber: 6)
        if let parenthe = sender.currentTitle{
            if parenthe == "("{
                process += parenthe
                printProcess()
                ni.append(0)
                //for index range .
                DS.append([0])
                freshDI.append([0])
                tempDigits.append([""])
                operationStorage.append([""])
                muldiOperIndex.append([false])
                answer.append([150])
                freshAI.append([0])
                indexPivotHelper.append(false)
                niStartStorage.append([0])
                positionOfParenthe.append([0])
                positionOfParenthe[pi].append(ni[pi])
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
                DS[pi].append(0)
                niStartStorage[pi].append(ni[pi])
                freshDI[pi].append(0)
                niEndStorage.append([0])
                operationStorage.append([""])
                muldiOperIndex.append([false])
                operationStorage[pi].append("") // this
                muldiOperIndex[pi].append(false) // this.
                indexPivotHelper[pi] = true // this.
                tempDigits[pi].append("")
                
            }else if (pi != 0) && parenthe == ")"{
                stateParenthesis(pointNumber : 1)
                niEndStorage[pi].append(ni[pi]) // this
                pi -= 1
                print("parenthe : \(parenthe)")
                process += parenthe
            }
            printProcess()
        }
    }
    
    func stateCheck(pointNumber : Double){
        print("point : \(pointNumber)")
        print("ni : \(ni)")
        print("DS : \(DS)")
        print("operationStorage : \(operationStorage)")
        print("ans : \(answer)")
    }
    
    func stateTempDigits(pointNumber : Double){
        print("point : \(pointNumber)")
        print("tempDigits : \(tempDigits)")
        print("DS : \(DS)")
        print("freshDI : \(freshDI)")
        
    }
    func stateParenthesis(pointNumber : Double){
        print("stateParenthesisPointNumber : \(pointNumber)")
        print("niEndStorage : \(niEndStorage)")
        print("operationStorage : \(operationStorage)")
        print("muldiOperIndex : \(muldiOperIndex)")
        print("indexPivotHelper : \(indexPivotHelper)")
        print("tempDigits : \(tempDigits)")
    }
}
