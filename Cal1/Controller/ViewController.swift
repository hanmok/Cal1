//MARK: - <#default setup
import UIKit

class ViewController: UIViewController {
    
    
    let numbers : [Character] = ["0","1","2","3","4","5","6","7","8","9","."]
    let operators : [Character] = ["+","-","x","/"]
    let parenthesis : [Character] = ["(",")"]
    var isDeletePressed = false
    var isAnsPressed = false
    var pi = 0 // index for parenthesis.
    var copypi = 0
    var ni = [0] // increase after pressing operation button.
    var parentheNumber = [0] // indicate the number of Parenthesis overlapped. 
    var tempDigits = [[""]] // save all digits to make a number
    var freshDI = [[0]] // 0 : newly made, 1: got UserInput, 2 : used
    var freshAI = [[0]] // 0 :newly made, 1 : calculated, 2 : used
    var copyfreshDI = [[0]]
    var copyfreshAI = [[0]]
    var DS = [[0.0]] // Double Numbers Storage
    var copyDS = [[0.0]]
    var answer : [[Double]] = [[100]] // the default value, which helps indicate the error.
    var copyAnswer : [[Double]] = [[100]]
    var whichParentheAreWe = [true]
    var copyni = [0]
    
    var operationStorage = [[""]]
    var muldiOperIndex = [[false]] // true if it is x or / .
    
    var niStart = [[0]] // remember the indexes to calculate (within parenthesis)
    var niEnd = [[0]]
    var copyniStart = [[0]]
    var copyniEnd = [[0]]
    var indexPivotHelper = [false]
    var indexPivotHelperIndicator = [0]
    var positionOfParenthe = [[Int]]() // remember the position of empty DS
    
    var process = ""
    var isParenClosed = false
    var piMax = 0
    var recordProcess = [String]()
    var recordAnswers = [Double]()
    
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
        if isAnsPressed && !isDeletePressed{
            clear()
            processView.text = "0"
            process = ""
        }
        
        // if made number is not greater than it's limit
        if DS[pi][ni[pi]] <= 1e18{
            if let digitInput = sender.currentTitle{
                
                if (digitInput == "0" || digitInput == "00") && (tempDigits[pi][ni[pi]] == "0" || tempDigits[pi][ni[pi]] == "-0" || tempDigits[pi][ni[pi]] == "" || tempDigits[pi][ni[pi]] == "-"){
                    switch tempDigits[pi][ni[pi]] {
                    case ""  :
                        tempDigits[pi][ni[pi]] += "0"
                        process += "0"
                    case "-":
                        tempDigits[pi][ni[pi]] += "0"
                        process += "0"
                    case "0" : print("do nothing"); break
                    case "-0": print("do nothing2"); break
                    default : break
                    }
                    
                }else if (digitInput == ".") && (tempDigits[pi][ni[pi]] == "" || tempDigits[pi][ni[pi]] == "-" || tempDigits[pi][ni[pi]].contains(".")){
                    switch tempDigits[pi][ni[pi]] {
                    case ""  :
                        tempDigits[pi][ni[pi]]  += "0."
                        process += "0."
                    case "-" :
                        tempDigits[pi][ni[pi]] += "0."
                        process += "0."
                    default : break
                    }
                }
                    
                else if (digitInput != "0" && digitInput != "00" && digitInput != ".") && (tempDigits[pi][ni[pi]] == "0" || tempDigits[pi][ni[pi]] == "-0"){
                    tempDigits[pi][ni[pi]] = removeLastChar(sentence: tempDigits[pi][ni[pi]])
                    tempDigits[pi][ni[pi]] += digitInput
                    
                    process = removeLastChar(sentence: process)
                    process += digitInput
                }
                    
                else if tempDigits[pi][ni[pi]] == "parenclosed" && operationStorage[pi][ni[pi]] == ""{
                    operationStorage[pi][ni[pi]] = "x"
                    muldiOperIndex[pi][ni[pi]] = true
                    process += operationStorage[pi][ni[pi]]
                    answer[pi].append(200) // for error checking
                    indexUpdate()
                    tempDigits[pi][ni[pi]] = digitInput
                    process += String(digitInput)
                }
                    
                else { // usual case
                    tempDigits[pi][ni[pi]] += digitInput
                    process += String(digitInput)
                }
                
                if tempDigits[pi][ni[pi]] != "-" || tempDigits[pi][ni[pi]] != ""{
                    if let safeDigits = Double(tempDigits[pi][ni[pi]]){
                        DS[pi][ni[pi]] = safeDigits
                        freshDI[pi][ni[pi]] = 1
                    }
                }
            }
        } // end if DS[pi][ni[pi]] <= 1e18{
        printProcess()
    } // @IBAction func numberPressed(_ sender: UIButton){
    
    
    
    //MARK: - <#func operationPressed
    @IBAction func operationPressed(_ sender: UIButton){
        if let operInput = sender.currentTitle{
            
            if isAnsPressed && !isDeletePressed{
                clear()
            }
            
            if ni[pi] == 0{
                if pi == 0 && saveResult != nil{
                    isAnsPressed = false//why? to prevent reexcxcute clear function in the numberPressed func.
                    //                    clear()
                    DS[0][0] = saveResult!
                    saveResult = nil
                    freshDI[0][0] = 1
                    if (DS[0][0] - Double(Int(DS[0][0])) == 0){ process = String(format : "%.0f", DS[0][0])}
                    else {process = String(DS[0][0])}
                    
                    operinputSetup(tempOperInput: operInput, tempi: ni[0])
                    process += operationStorage[0][0]
                    answer[0].append(200) // for error checking
                    indexUpdate()
                    printProcess()
                } // end if pi == 0 && ni == 0 && saveResult != nil{
                else if tempDigits[pi][ni[pi]] == ""{
                    if operInput != "-"{
                    }
                    else if operInput == "-"{
                        tempDigits[pi][ni[pi]] += "-"
                        process += "-"
                    }
                }
                else if tempDigits[pi][ni[pi]] == "-"{
                    if operInput != "-"{
                        tempDigits[pi][ni[pi]] = removeLastChar(sentence: tempDigits[pi][ni[pi]])
                        process = removeLastChar(sentence: process)
                    }else if operInput == "-"{
                    }
                }
                else {
                    operinputSetup(tempOperInput: operInput, tempi: ni[pi])
                    process += operationStorage[pi][ni[pi]]
                    answer[pi].append(200)
                    freshAI[pi].append(0)
                    indexUpdate()
                }
            }// end if ni[pi] == 0
            else if ni[pi] != 0{
                if tempDigits[pi][ni[pi]] == ""{
                    operinputSetup(tempOperInput: operInput, tempi: ni[pi]-1)
                    process = removeLastChar(sentence: process)
                    process += operationStorage[pi][ni[pi]-1]
                }
                else if tempDigits[pi][ni[pi]] != ""{
                    operinputSetup(tempOperInput: operInput, tempi: ni[pi])
                    process += operationStorage[pi][ni[pi]]
                    answer[pi].append(150)
                    freshAI[pi].append(0)
                    indexUpdate()
                }
            }
            printProcess()
        } //  end of if let operInput = sender.currentTitle
        isAnsPressed = false
        isDeletePressed = false
    }
    
    //MARK: - <#func calculation
    func calculateAns(){//{d
        checkIndexes(saySomething: "calculateAnsPressed!!")
        isAnsPressed = true // because of break keyword are in the code, locateded it at the beginning.
        isDeletePressed = false
        copyfreshDI = freshDI
        copyfreshAI = freshAI
        copyDS = DS
        copypi = pi
        copyAnswer = answer
        copyniStart = niStart
        copyniEnd = niEnd
        copyni = ni
        while pi > 0{
            print("looking for error 1")
//            niEnd[pi].append(ni[pi])
            niEnd[pi].append(0)
            print("looking for error 2")
            
            niEnd[pi][parentheNumber[pi]] = ni[pi]// wrong index niEnd[pi][ ??? ] = ni[pi]
            print("looking for error 3")
            //
            pi -= 1
            process += ")"
        }
        
        niStart[0].append(0)
        niEnd[0].append(0)
        niEnd[0][1] = ni[pi]
        pi = piMax
        
        checkIndexes(saySomething: "calculate piLoop Start")
//        checkIndexes(saySomething: <#T##String#>)
        piLoop : while pi >= 0 {
            for a in 1 ... niStart[pi].count-1{
                for i in niStart[pi][a] ..< niEnd[pi][a]{
                    // first for statement : for Operation == "x" or "/"
                    if muldiOperIndex[pi][i]{
                        if freshDI[pi][i] == 1 && freshDI[pi][i+1] == 1{
                            //곱셈 , D[i]전항과 D[i+1]후항 존재, >> 두개 곱함.
                            if operationStorage[pi][i] == "x" {
                                answer[pi][i] = DS[pi][i] *  DS[pi][i+1]
                            }else if  operationStorage[pi][i] == "/"{
                                answer[pi][i] = DS[pi][i] /  DS[pi][i+1]
                            }
                            freshAI[pi][i] = 1 ; freshDI[pi][i] = 2 ; freshDI[pi][i+1] = 2
                            result = answer[pi][i]
                        }else if  freshDI[pi][i] == 2 && freshDI[pi][i+1] == 1{
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
                checkIndexes(saySomething: "multiply end")
                for i in niStart[pi][a] ..< niEnd[pi][a]{
                    if !muldiOperIndex[pi][i]{ //{b
                        if freshDI[pi][i+1] == 1{
                            //+ 연산 >> D[i+1] 존재
                            if freshDI[pi][i] == 1{
                                //+ 연산 >> D[i+1] 존재하는 >> D[i] 존재
                                if  operationStorage[pi][i] == "+"{
                                    answer[pi][i] =  DS[pi][i] +  DS[pi][i+1]
                                } else if  operationStorage[pi][i] == "-"{
                                    answer[pi][i] =  DS[pi][i] -  DS[pi][i+1]
                                }
                                freshAI[pi][i] = 1 ; freshDI[pi][i] = 2 ; freshDI[pi][i+1] = 2
                                result = answer[pi][i]
                            } else if freshDI[pi][i] == 2{
                                //+ 연산 >> D[i+1] 존재 >> D[i] 존재 ㄴㄴ
                                for k in 1 ... i{
                                    //freshAI[i-k] 찾음
                                    if (freshAI[pi][i-k] == 1){
                                        if  operationStorage[pi][i] == "+"{
                                            answer[pi][i] = answer[pi][i-k] +  DS[pi][i+1]
                                        }else if  operationStorage[pi][i] == "-"{
                                            answer[pi][i] = answer[pi][i-k] -  DS[pi][i+1]
                                        }
                                        freshAI[pi][i] = 1;freshAI[pi][i-k] = 2 ; freshDI[pi][i+1] = 2
                                        result = answer[pi][i]
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
                                        for j in 0 ... i{
                                            if (freshAI[pi][i-j] == 1){
                                                //+연산 >> D[i+1] 존재 ㄴㄴ >>Ans[k](k>i) 존재 >> D[i] 존재 ㄴㄴ >> A[i-j](i-j < i) 존재
                                                if  operationStorage[pi][i] == "+"{
                                                    answer[pi][i] = answer[pi][i-j] + answer[pi][k+1]
                                                } else if  operationStorage[pi][i] == "-"{
                                                    answer[pi][i] = answer[pi][i-j] - answer[pi][k+1]
                                                }
                                                freshAI[pi][i] = 1; freshAI[pi][i-j] = 2; freshAI[pi][k+1] = 2
                                                result = answer[pi][i]
                                                break noLatterNum
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                } // end of all calculations. (for i in niStart[pi][a] ..< niEnd[pi][a])
                checkIndexes(saySomething: "start obtain answer ")
                if pi>0{
                    for i in niStart[pi][a] ... niEnd[pi][a]{
                        if niStart[pi][a] != niEnd[pi][a]{
                            if freshAI[pi][i] == 1{
                                DS[pi-1][positionOfParenthe[pi-1][a]] = answer[pi][i]
                                freshDI[pi-1][positionOfParenthe[pi-1][a]] = 1
                            }
                        }else if niStart[pi][a] == niEnd[pi][a]{
                            DS[pi-1][positionOfParenthe[pi-1][a]] = DS[pi][i]
                            freshDI[pi-1][positionOfParenthe[pi-1][a]] = 1
                        }
                    }
                }
                else if pi == 0{
                    near : for i in niStart[0][1] ... niEnd[0][1]{
                        if freshAI[0][i] == 1{
                            result = answer[0][i]
                            recordAnswers.append(answer[0][i])
                            recordProcess.append(process)
                            break near
                        }
                        if i == niEnd[0][1]{
                            result = DS[0][niStart[0][1]]
                            recordAnswers.append(answer[0][i])
                            recordProcess.append(process)
                        }
                    }
                    printProcess()
                    floatingNumberDecider(ans: result!)
                    filterProcess()
                    checkIndexes(saySomething: "end of piLoop")
                    break piLoop
                }
            } // end for a in 1 ... niStart[pi].count-1{
            pi -= 1
        } //end piLoop : while pi >= 0 {
    } // end func calculateAns()
    
    @IBAction func parenthesisPressed(_ sender: UIButton) {
            if let parenthe = sender.currentTitle{
                if parenthe == "("{
                    if operationStorage[pi][ni[pi]] == "" && tempDigits[pi][ni[pi]] != ""{
                        if tempDigits[pi][ni[pi]] == "0." || tempDigits[pi][ni[pi]] == "-0."{
                            tempDigits[pi][ni[pi]] += "0"
                            process += "0"
                        }
                        operationStorage[pi][ni[pi]] = "x"
                        muldiOperIndex[pi][ni[pi]] = true
                        
                        process += operationStorage[pi][ni[pi]]
                        answer[pi].append(200) // for error checking
                        indexUpdate()
                    }
                    
                    process += parenthe
                    printProcess()
                    
                    indexIncreaseInParenthesisBefore(pi : pi)
                    
                    indexPivotHelper.append(false)
                    positionOfParenthe.append([0])
                    positionOfParenthe[pi].append(ni[pi])
                    tempDigits[pi][ni[pi]] = "paren"
                    
                    pi += 1
                    indexPivotHelperIndicator[pi] += 1
                    parentheNumber.append(0)
                    parentheNumber[pi] += 1
                    whichParentheAreWe[pi] = true
                    
                    if pi > piMax{
                        piMax = pi
                        niStart.append([0])
                        niEnd.append([0])
                    }
                    if indexPivotHelper[pi]{
                        ni[pi] += 1
                        
                    }
                    
                    indexIncreaseInParenthesisAfter(pi: pi)
                    niStart[pi].append(ni[pi])
                    indexPivotHelper[pi] = true
                    
                }else if (pi != 0) && parenthe == ")"{
                    whichParentheAreWe[pi] = false
    //                niEnd[pi].append(ni[pi])
                    niEnd[pi].append(0)
                    niEnd[pi][parentheNumber[pi]] = ni[pi] // wrong index niEnd[pi][ ??? ] = ni[pi]

                    pi -= 1
                    process += parenthe
                    tempDigits[pi][ni[pi]] += "closed"
                }
                printProcess()
            }
        }
    
    func indexIncreaseInParenthesisBefore(pi : Int){
        whichParentheAreWe.append(false)
        indexPivotHelperIndicator.append(0)
        ni.append(0)
        tempDigits.append([""])
        DS.append([0])
        freshDI.append([0])
        operationStorage.append([""])
        muldiOperIndex.append([false])
        answer.append([150])
        freshAI.append([0])
        DS[pi].append(0)
        freshDI[pi].append(0)
    }
    
    func indexIncreaseInParenthesisAfter(pi : Int){
        tempDigits[pi].append("")
        DS[pi].append(0)
        freshDI[pi].append(0)
        operationStorage.append([""])
        muldiOperIndex.append([false])
        operationStorage[pi].append("")
        muldiOperIndex[pi].append(false)
    }
    
    @IBAction func deletePressed(_ sender: UIButton) {
        checkIndexes(saySomething: "deleted Pressed!")
        caseframe : if process != ""{
            print("isDeletedPressed :\(isDeletePressed), isAnsPressed : \(isAnsPressed) ")
            if !isDeletePressed && isAnsPressed{
                freshDI = copyfreshDI
                freshAI = copyfreshAI
                DS = copyDS
                pi = copypi
                answer = copyAnswer
                niEnd = copyniEnd
                niStart = copyniStart
                niStart[0].removeLast()
                ni = copyni
                checkIndexes(saySomething: "must check here! ")
//                niEnd[0].removeLast()
            }
            
//            print(process[process.index(before:process.endIndex)]) // the very last ..don't know why.
            // if number deleted.
            case1_Number : for i in numbers{
                if process[process.index(before:process.endIndex)] == i{
                    //when last digit is deleted
                    if process.count <= 1{
                        tempDigits[pi][ni[pi]] = "0"
                        DS[pi][ni[pi]] = Double(tempDigits[pi][ni[pi]])!
                        freshDI[pi][ni[pi]] = 1
                        process = "0"
                        printProcess()
                        break caseframe
                        
                    } // usual case.
                    else if process.count > 1{
                        process = removeLastChar(sentence: process)
                        tempDigits[pi][ni[pi]] = removeLastChar(sentence: tempDigits[pi][ni[pi]])
                        if let safeDigits = Double(tempDigits[pi][ni[pi]]){
                            DS[pi][ni[pi]] = safeDigits
                            freshDI[pi][ni[pi]] = 1
                        }
                        
                        printProcess()
                        for k in numbers{
                            if process[process.index(before:process.endIndex)] == k{
                                break caseframe // more numbers left, break loop. tempDigits도 수정해야함...
                            }
                        }
                        // if cannot find number leftover
                        freshDI[pi][ni[pi]] = 0
                        break caseframe
                    }
                }
            }// end number case.
            
            //if operation deleted.
            case2_Operator : for i in operators{
                if process[process.index(before:process.endIndex)] == i{
                    process = removeLastChar(sentence: process)
                    ni[pi] -= 1
                    printProcess()
                    break caseframe
                }
            }
            
            case3_OpenParenthesis : if process[process.index(before:process.endIndex)] == "("{
                process = removeLastChar(sentence: process)
//                niStart[pi].removeLast()
                
                if indexPivotHelperIndicator[pi] > 1 {
                    ni[pi] -= 1
                }else if indexPivotHelperIndicator[pi] <= 1{
                    indexPivotHelper[pi] = false
                }
                indexPivotHelperIndicator[pi] -= 1
                
                pi -= 1
                positionOfParenthe[pi].removeLast()
                indexPivotHelper.removeLast()
                printProcess()
                break caseframe
            }
            
            case4_ClosingParenthesis : if process[process.index(before:process.endIndex)] == ")"{
                checkIndexes(saySomething: "Closing Parenthesis ")
               

                process = removeLastChar(sentence: process)
                pi += 1
                //여기가 문제.
                for i in 0 ... indexPivotHelperIndicator.count-1{
                    if indexPivotHelperIndicator[i] != 0{
                        piMax = i
                    }
                }
                
                checkIndexes(saySomething: "end of ClosingParenthesis")
                printProcess()
                break caseframe
            }
        } // end of caseframe
//        else if process == ""{ do nothing.
//        }
        checkIndexes(saySomething: "end of deletePressed")
        isDeletePressed = true
    }
    
    
    //MARK: - <#func clearPressed
    @IBAction func clearPressed(_ sender: UIButton) {
        clear()
        resultView.text = ""
        processView.text = "0"
        saveResult = nil
        process = ""
    }
    
    //MARK: - <#func setups
    func clear(){
        print("clear !")
        parentheNumber = [0]
        whichParentheAreWe = [true]
        indexPivotHelperIndicator = [0]
        isAnsPressed = false
        isDeletePressed = false
        
        piMax = 0
        indexPivotHelper = [false]
        ni = [0]
        copyni = [0]
        pi = 0
        DS = [[0.0]]
        copyAnswer = [[300]]
        copyDS = [[0.0]]
        copyfreshDI = [[0]]
        copypi = 0
        copyfreshAI = [[0]]
        copyniStart = [[0]]
        copyniEnd = [[0]]
        tempDigits = [[""]]
        printProcess()
        answer = [[300]] // for error check.
        freshDI = [[0]]
        freshAI = [[0]]
        operationStorage = [[""]]
        muldiOperIndex = [[false]]
        result = nil
        positionOfParenthe = [[Int]]()
        niStart = [[0]]
        niEnd = [[0]]
        print("clear!")
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
    
    func filterProcess(){
        notEmpty : if process != ""{
            if process[process.index(before:process.endIndex)] == "+" || process[process.index(before:process.endIndex)] == "-" || process[process.index(before:process.endIndex)] == "x" || process[process.index(before:process.endIndex)] == "/"{
                print("the last one is operation \(process[process.index(before:process.endIndex)])")
                process = removeLastChar(sentence: process)
                ni[pi] -= 1
                printProcess()
                break notEmpty
            }
            else if process[process.index(before:process.endIndex)] == "."{
                process = removeLastChar(sentence: process)
                tempDigits[pi][ni[pi]] = removeLastChar(sentence: tempDigits[pi][ni[pi]])
                
                if let safeDigits = Double(tempDigits[pi][ni[pi]]){
                    DS[pi][ni[pi]] = safeDigits
                    freshDI[pi][ni[pi]] = 1
                }
                printProcess()
                break notEmpty
            }
        }
    }
    
    func removeLastChar(sentence : String) -> String{
        let str = sentence.dropLast()
        let modifiedSentence = String(str)
        return modifiedSentence
    }
    
    func operinputSetup(tempOperInput : String, tempi : Int){
        switch tempOperInput{
        case "+" :  operationStorage[pi][tempi] = "+"
        case "X" :  operationStorage[pi][tempi] = "x"
        case "-" :  operationStorage[pi][tempi] = "-"
        case "/" :  operationStorage[pi][tempi] = "/"
        default: break
        }
        if  operationStorage[pi][tempi] == "x" ||  operationStorage[pi][tempi] == "/"{
            muldiOperIndex[pi][tempi] = true}
        else if operationStorage[pi][tempi] == "+" ||  operationStorage[pi][tempi] == "-"{
            muldiOperIndex[pi][tempi] = false}
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
    
    func printProcess(){
        processView.text = process
    }
    
    func checkIndexes(saySomething : String){
        print(" \(saySomething)")
        print("answer : \(answer)")
        print("freshDI : \(freshDI)")
        print("freshAI : \(freshAI)")
        print("DS : \(DS)")
        print("operationStorage : \(operationStorage)")
        print("muldiOperIndex : \(muldiOperIndex)")
        print("ni : \(ni)")
        print("pi : \(pi)")
        print("piMax : \(piMax)")
        print("niStartStorage : \(niStart)")
        print("niEndStorage : \(niEnd)")
        print("indexPivotHelper : \(indexPivotHelper)")
        print("positionOfParenthe : \(positionOfParenthe)")
        print("tempDigits : \(tempDigits)")
        print("process : \(process)")
        print(" \(saySomething) end")
    }
}


