//MARK: - <#default setup
import UIKit

class ViewController: UIViewController {
    var pi = 0 // index for parenthesis.
    var ni = [0] // increase after pressing operation button.
    
    var tempDigits = [[""]] // save all digits to make a number
    var freshDI = [[0]] // 0 : newly made, 1: got UserInput, 2 : used
    var freshAI = [[0]] // 0 :newly made, 1 : calculated, 2 : used
    var DS = [[0.0]] // Double Numbers Storage
    var answer : [[Double]] = [[100]] // the default value, which helps indicate the error.
    
    var operationStorage = [[""]]
    var muldiOperIndex = [[false]] // true if it is x or / .
    
    var parenthesisStorage = [[Int]]()
    var niStart = [[0]] // remember the indexes to calculate (within parenthesis)
    var niEnd = [[0]]
    var indexPivotHelper = [false]
    var positionOfParenthe = [[Int]]() // remember the position of empty DS
    var clearAfterAns = false
    var negativeSign = false
    var process = ""
    var isParenClosed = false
    var piMax = 0
    
    var saveResult : Double? // if one want operate after press ans button, this value will come up and used.
    var result : Double? // to be printed, one of the answer array.
    
    
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
        print("@IBAction func numberPressed(_ sender: UIButton){")
        //stateTempDigits(pointNumber: 1)
        //stateCheck(pointNumber: 1)
        //clear states after got answer
        if clearAfterAns{//modification needed.
            print(" if clearAfterAns{")
            clear()
            resultView.text = ""
            processView.text = "0"
            process = ""
            clearAfterAns = false
        }// end if clearAfterAns
        
        // if made number is not greater than it's limit
        if DS[pi][ni[pi]] <= 1e18{ // starts DS[pi][ni[pi]] <= 1e18
            print("ni : \(ni)")
            print("if DS[pi][ni[pi]] <= 1e18{")
            // set each input digit on the digitInput.
            if let digitInput = sender.currentTitle{
                print("if let digitInput = sender.currentTitle{")
                //stateTempDigits(pointNumber: 2)
                
                // tempDigits : temporal Storage for number until user finish set a number
                // ignore double dot on one number input. On usual case, this if statement execute.(usual)
                if !(digitInput == ".") || !(tempDigits[pi][ni[pi]].contains(".")){
                    print("if !(digitInput == \".\") || !(tempDigits[pi][ni[pi]].contains(\".\")){")
                    
                    //var tempDigits = [""]
                    // tempDigit[ni[pi]] : user number input just before digitInput
                    // tempDigits[pi][ni[pi]] == 00, 01, 02, ... 09
                    //if user input 00 01 02 03 .. 09 , automatically change it to 0, 1, 2, 3, ... 9 (exceptional)
//                    if digitInput != "." && tempDigits[pi][ni[pi]] == "0" {
//                        print(" if digitInput != \".\" && tempDigits[pi][ni[pi]] == \"0\" {")
//                        let str1 = tempDigits[pi][ni[pi]].dropLast()
//                        tempDigits[pi][ni[pi]] = String(str1)
//                        tempDigits[pi][ni[pi]] += digitInput
//
//                        let str2 = process.dropLast()
//                        process = String(str2)
//                        process += digitInput
                    if (tempDigits[pi][ni[pi]] == "" || tempDigits[pi][ni[pi]] == "-" || tempDigits[pi][ni[pi]] == "0" || tempDigits[pi][ni[pi]] == "00") && (digitInput == "00" || digitInput == "0"){
                        //when dot clicked without any number prior to, it automatically input 0 before dot. (. >> 0.0)(ex)
                        if digitInput == "0"{
                            switch tempDigits[pi][ni[pi]] {
                            case "" : tempDigits[pi][ni[pi]] = "0" ; process += "0"
                            case "-" : tempDigits[pi][ni[pi]] += "0"; process += "0"
                            case "0" : tempDigits[pi][ni[pi]] = "0"
                            default:print("digitInput == 0 ") ; break
                            }
                        }else if digitInput == "00"{
                            switch tempDigits[pi][ni[pi]] {
                            case "" : tempDigits[pi][ni[pi]] = "0" ; process += "0"
                            case "-" : tempDigits[pi][ni[pi]] += "0"; process += "0"
                            case "0" : tempDigits[pi][ni[pi]] = "0"
                            default:print("digitInput == 00 ");break
                        }
                    }
                    }else if (tempDigits[pi][ni[pi]] == "" || tempDigits[pi][ni[pi]] == "-") && digitInput == "."{
                        print("  }else if tempDigits[pi][ni[pi]] == \"\" && digitInput == \".\"{")
                        tempDigits[pi][ni[pi]] += "0."
                        process += String("0.")
                        
                    }else if ((ni[pi]) == 0) && (negativeSign){
//                        tempDigits[pi][ni[pi]] += "-"
                        tempDigits[pi][ni[pi]] += digitInput
                        process += String(digitInput)
                        negativeSign = false
                        printProcess()
                        
                    }else if  tempDigits[pi][ni[pi]] == "parenclosed" && operationStorage[pi][ni[pi]] == ""{
                        operationStorage[pi][ni[pi]] = "x"
                        muldiOperIndex[pi][ni[pi]] = true
                        process += operationStorage[pi][ni[pi]]
                        answer[pi].append(200) // for error checking
                        indexUpdate()
                        tempDigits[pi][ni[pi]] = digitInput
                        process += String(digitInput)
                    }
                    
                    else { // usual case
                        print("}else { // usual case")
                        tempDigits[pi][ni[pi]] += digitInput
                        process += String(digitInput)
                    }
                } // end of Not doubleDot Case
                else if digitInput == "." && tempDigits[pi][ni[pi]].contains("."){
                    print("  else if digitInput == \".\" && tempDigits[pi][ni[pi]].contains(\".\"){")
                }
            } // end if let digitInput = sender.currentTitle{
            
            if tempDigits[pi][ni[pi]] != "0."{
                print(" if tempDigits[pi][ni[pi]] != \"0.\"{")
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
stateTempDigits(pointNumber : 3)
            printProcess()
            //            processView.text =  process
        } // end of DS[pi][ni[pi]] <= 1e18
        //stateTempDigits(pointNumber: 3)

    }
    
    
    //MARK: - <#func operationPressed
    @IBAction func operationPressed(_ sender: UIButton){
        print("@IBAction func operationPressed(_ sender: UIButton){")
        //stateCheck(pointNumber: 2)
        if let operInput = sender.currentTitle{
            print("  if let operInput = sender.currentTitle{")
            
            //              abnormal case, no number input before operator button pressed.
            if tempDigits[pi][ni[pi]] == ""{
                print("tempDigits[pi][ni[pi]] == \"\" ")
                if pi == 0 && ni[0] == 0 && saveResult != nil{
                    print("")
                    
                    clearAfterAns = false//why? to prevent reexcxcute clear function in the numberPressed func.
                    clear()
                    DS[0][0] = saveResult!
                    saveResult = nil
                    freshDI[0][0] = 1 //allocated 1 to freshDI cause it initialized with number not be changed.
                    if (DS[0][0] - Double(Int(DS[0][0])) == 0){ process = String(format : "%.0f", DS[0][0])}
                    else {process = String(DS[0][0])}
                    
                    operinputSetup(tempOperInput: operInput, tempi: ni[0])
                    process += operationStorage[0][0]
                    answer[0].append(200) // for error checking
                    indexUpdate()
                    printProcess()
                } // end if pi == 0 && ni == 0 && saveResult != nil{
                    
//                else if ni[pi] == 0 && (operInput == "-" || operInput == "+"){ // if operation before the first number is "-"
//                    print("  else if ni[pi] == 0 && (operInput == \"-\" || operInput == \"+\"){")
//                    plSign = false
//                    miSign = false
//                    switch operInput {
//                    case "+" : plSign = true
//                    case "-" : miSign = true
//                    default:break
//                    }
//                    if sign{
//                        let str = process.dropLast()
//                        process = String(str)
//                    }
//                    process += operInput
//                    sign = true
//                }// if the other operation comes first before number >> ignore .
                else if ni[pi] == 0 && operInput == "-" && !negativeSign{
                    tempDigits[pi][ni[pi]] += "-"
                    negativeSign = true
                    process += "-"
                }
                else if ni[pi] == 0 && negativeSign && (operInput == "X" || operInput == "/" || operInput == "+"){
                    print(" else if ni[pi] == 0 && (operInput == \"X\" || operInput == \"/\"){")
                    let str = process.dropLast()
                    process = String(str)
                    negativeSign = false
                } // end of pi == 0 && ni[0] == 0 && saveResult != nil { else if .
                // if tempDigits[pi][ni[pi]] == ""{
                //in case no number input before second following operator , replace prior one with new oper input.(Double Operator)(no index and answer update.)
                if ni[pi] != 0 {//여기 걸리면 앙대...
                    print(" if ni[pi] != 0 {//여기 걸리면 앙대...")
                    operinputSetup(tempOperInput: operInput, tempi: ni[pi]-1)
                    let str =  process.dropLast()
                    process = String(str)
                    process += operationStorage[pi][ni[pi]-1]
                }
                // normal case, number input exist before operator input
            } // if tempDitis[pi][ni[pi]] == "" else~ (the other case)
            else if tempDigits[pi][ni[pi]] != ""{
                print("  else if tempDigits[pi][ni[pi]] != \"\"{")
                operinputSetup(tempOperInput: operInput, tempi: ni[pi])
                process += operationStorage[pi][ni[pi]]
                answer[pi].append(200) // for error checking
                indexUpdate()
            } // tempDigigits[ni[pi]] != ""
            printProcess()
        } //  end of if let operInput = sender.currentTitle
    }
    
    
    
    //MARK: - <#func calculation
    func calculateAns(){//{d
        print(" func calculateAns(){//{d")
        while pi > 0{
            niEnd[pi].append(ni[pi])
            pi -= 1
            process += ")"
        }
        
        niStart[0].append(0)
        niEnd[0].append(ni[0])
        checkIndexes(pointNumber: 1)
        pi = piMax
        while pi >= 0 {
            print(" while pi >= 0 {")
            checkIndexes(pointNumber: 2)
            for a in 1 ... niStart[pi].count-1{
                print("  for a in 1 ... niStart[pi].count-1{")
                checkIndexes(pointNumber: 3)
                for i in niStart[pi][a] ..< niEnd[pi][a]{
                    print("for i in niStart[pi][a] ..< niEnd[pi][a]{")
                    checkIndexes(pointNumber: 4)
                    // first for statement : for Operation == "x" or "/"
                    if muldiOperIndex[pi][i]{
                        print("if muldiOperIndex[pi][i]{")
                        if freshDI[pi][i] == 1 && freshDI[pi][i+1] == 1{
                            print("if freshDI[pi][i] == 1 && freshDI[pi][i+1] == 1{")
                            //곱셈 , D[i]전항과 D[i+1]후항 존재, >> 두개 곱함.
                            if operationStorage[pi][i] == "x" {
                                checkIndexes(pointNumber: 7)
                                answer[pi][i] = DS[pi][i] *  DS[pi][i+1]
                            }else if  operationStorage[pi][i] == "/"{
                                answer[pi][i] = DS[pi][i] /  DS[pi][i+1]
                            }
                            freshAI[pi][i] = 1 ; freshDI[pi][i] = 2 ; freshDI[pi][i+1] = 2
                            result = answer[pi][i]
                        }else if  freshDI[pi][i] == 2 && freshDI[pi][i+1] == 1{
                            print("}else if  freshDI[pi][i] == 2 && freshDI[pi][i+1] == 1{")
                            //곱셈, D[i]전항 존재 안할 때 >> A[i-1] * D[i+1]
                            if  operationStorage[pi][i] == "x"{
                                answer[pi][i] = answer[pi][i-1] *  DS[pi][i+1]
                            }else if  operationStorage[pi][i] == "/"{
                                answer[pi][i] = answer[pi][i-1] /  DS[pi][i+1]
                            }
                            freshAI[pi][i] = 1;freshAI[pi][i-1] = 2 ; freshDI[pi][i+1] = 2
                            result = answer[pi][i];
                        }
                    }
                } // end for i inniStart[pi][a] ...niEnd[pi][a]{
                checkIndexes(pointNumber: 11)
                for i in niStart[pi][a] ..< niEnd[pi][a]{
                    print("for i in niStart[pi][a] ..< niEnd[pi][a]{")
                    checkIndexes(pointNumber: 12)
                    if !muldiOperIndex[pi][i]{ //{b
                        print("if !muldiOperIndex[pi][i]{ //{b")
                        if freshDI[pi][i+1] == 1{
                            print("if freshDI[pi][i+1] == 1{")
                            //+ 연산 >> D[i+1] 존재
                            if freshDI[pi][i] == 1{
                                print("if freshDI[pi][i] == 1{")
                                //+ 연산 >> D[i+1] 존재하는 >> D[i] 존재
                                if  operationStorage[pi][i] == "+"{
                                    answer[pi][i] =  DS[pi][i] +  DS[pi][i+1]
                                } else if  operationStorage[pi][i] == "-"{
                                    answer[pi][i] =  DS[pi][i] -  DS[pi][i+1]
                                }
                                freshAI[pi][i] = 1 ; freshDI[pi][i] = 2 ; freshDI[pi][i+1] = 2
                                result = answer[pi][i]
                            } else if freshDI[pi][i] == 2{
                                print("} else if freshDI[pi][i] == 2{")
                                //+ 연산 >> D[i+1] 존재 >> D[i] 존재 ㄴㄴ
                                for k in 1 ... i{
                                    print("for k in 1 ... i{")
                                    //freshAI[i-k] 찾음
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
                            print("}else if freshDI[pi][i+1] == 2{")
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
                                        print("}else if freshDI[pi][i] == 2{")
                                        for j in 0 ... i{ // 에러발생지.
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
                } // end of all calculations. (for i in niStart[pi][a] ..< niEnd[pi][a])
                
                checkIndexes(pointNumber: 18)
            // for a in 1 ...niStart[pi].count-1{
                for i in niStart[pi][a] ..< niEnd[pi][a]{
                    print("for i in niStart[pi][a] ..< niEnd[pi][a]{")
                    if freshAI[pi][i] == 1{ // 답을 못찾는 경우도 구해야함. .. 괄호 안에 항이 하나이거나 전체 항이 하나. 연산 없이.
                        print("if freshAI[pi][i] == 1{")
                        clearAfterAns = true
                        result = answer[pi][i]
                        print("result = answer[pi][i]")
                        checkIndexes(pointNumber: 19.5)
                        break
                    }
                    print("is it here?")
                    if i == niEnd[pi][a]-1 {
                        print("if i == niEnd[pi][a]-1 {")
                        result = DS[pi][0]
                    }
                }
                //special case.
                if niStart[pi][a] == niEnd[pi][a]{ // only one number is in parenthesis
                    result = DS[pi][0]
                }
                
                checkIndexes(pointNumber: 19)
                if pi > 0{
                    print("if pi > 0{")
                    print("DS : \(DS)")
                    print("freshDI : \(freshDI)")
                    print("pi : \(pi), a : \(a)")
                    print("positionOfParenthe : \(positionOfParenthe)")
                    print("result : \(String(describing: result))")
                    checkIndexes(pointNumber: 20.1)
                    DS[pi-1][positionOfParenthe[pi-1][a]] = result!
                    freshDI[pi-1][positionOfParenthe[pi-1][a]] = 1
                    print("pass it ? ")
                }
            } // end of for a in 1 ...niStart[pi].count-1{
            checkIndexes(pointNumber: 20)
            if pi == 0 {
                print("if pi == 0 {")
                floatingNumberDecider(ans: result!)
                break
            }else {
                print("}else {")
                pi -= 1
                continue
            }
        } // end pi >= 0
        clear()
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
    }
    
    //MARK: - <#func setups
    func clear(){
        piMax = 0
        indexPivotHelper = [false]
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
        positionOfParenthe = [[Int]]()
        niStart = [[0]]
        niEnd = [[0]]
        negativeSign = false
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
                break
            }
            if i == 6{
                resultView.text = "\(String(format : "%.6f", ans))"
                saveResult = ans
            }
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
                if operationStorage[pi][ni[pi]] == "" && tempDigits[pi][ni[pi]] != ""{
                    operationStorage[pi][ni[pi]] = "x"
                    muldiOperIndex[pi][ni[pi]] = true
                    
                    process += operationStorage[pi][ni[pi]]
                    answer[pi].append(200) // for error checking
                    indexUpdate()
            }
                
                process += parenthe
                printProcess()
                ni.append(0)
                //for index range .
                tempDigits.append([""])
                DS.append([0])
                freshDI.append([0])
                operationStorage.append([""])
                muldiOperIndex.append([false])
                answer.append([150])
                freshAI.append([0])
                
                indexPivotHelper.append(false)
                niStart.append([0])
                positionOfParenthe.append([0])
                positionOfParenthe[pi].append(ni[pi])
                DS[pi].append(0)
                freshDI[pi].append(0)
                tempDigits[pi][ni[pi]] = "paren"
                
                print("indexPivotHelper : \(indexPivotHelper)")
                print("ni : \(ni)")
                pi += 1
                if pi > piMax{
                    piMax = pi
                }
                if indexPivotHelper[pi]{
                    ni[pi] += 1
                }
                tempDigits[pi].append("")
                DS[pi].append(0)
                freshDI[pi].append(0)
                operationStorage.append([""])
                muldiOperIndex.append([false])
                operationStorage[pi].append("")
                muldiOperIndex[pi].append(false)
                
                niStart[pi].append(ni[pi])
                niEnd.append([0])
                
                indexPivotHelper[pi] = true
                print("indexPivotHelper : \(indexPivotHelper)")
                               print("ni : \(ni)")
                
            }else if (pi != 0) && parenthe == ")"{
                stateParenthesis(pointNumber : 1)
                niEnd[pi].append(ni[pi]) // this
                pi -= 1
                print("parenthe : \(parenthe)")
                process += parenthe
                tempDigits[pi][ni[pi]] += "closed"
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
        print("ni : \(ni)")
        print("pi : \(pi)")
        print("tempDigits : \(tempDigits)")
        print("DS : \(DS)")
        print("freshDI : \(freshDI)")
    }
    
    func stateParenthesis(pointNumber : Double){
        print("stateParenthesisPointNumber : \(pointNumber)")
        print("niEndStorage : \(niEnd)")
        print("operationStorage : \(operationStorage)")
        print("muldiOperIndex : \(muldiOperIndex)")
        print("indexPivotHelper : \(indexPivotHelper)")
        print("tempDigits : \(tempDigits)")
    }
    
    func checkIndexes(pointNumber : Double){
        print("pointNumber : \(pointNumber)")
        print("answer : \(answer)")
        print("freshDI : \(freshDI)")
        print("freshAI : \(freshAI)")
        print("DS : \(DS)")
        print("operationStorage : \(operationStorage)")
        print("muldiOperIndex : \(muldiOperIndex)")
        print("ni : \(ni)")
        print("pi : \(pi)")
        print("niStartStorage : \(niStart)")
        print("niEndStorage : \(niEnd)")
        print("indexPivotHelper : \(indexPivotHelper)")
        print("positionOfParenthe : \(positionOfParenthe)")
        print("tempDigits : \(tempDigits)")
        print("pointNumber : \(pointNumber) end")
    }
}
