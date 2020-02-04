
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
            if let digitInput = sender.currentTitle{
                if !(digitInput == ".") ||  !(tempDigits[index].contains(".")){
                    if digitInput != "." && tempDigits[index] == "0"{
                        let str1 = tempDigits[index].dropLast()
                        tempDigits[index] = String(str1)
                        
                        let str2 = calc.process.dropLast()
                        calc.process = String(str2)
                    }
                    tempDigits[index] += String(digitInput)
                    if tempDigits[index] == "."{
                        tempDigits[index] = "0."
                        calc.process += String("0.")
                    } else {
                        calc.process += String(digitInput)
                    }
                }
            }
            calc.DS[index] = Double(tempDigits[index])!
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
                if calc.operationStorage[index] == "x" || calc.operationStorage[index] == "/"{
                    muldiOperIndex[index] = true}
                else if calc.operationStorage[index] == "+" || calc.operationStorage[index] == "-"{
                    muldiOperIndex[index] = false}
                
                calc.process += calc.operationStorage[index]
                
            }else if tempDigits[index] == ""{
                switch operInput{
                case "+" : calc.operationStorage[index-1] = "+"
                case "-" : calc.operationStorage[index-1] = "-"
                case "X" : calc.operationStorage[index-1] = "x"
                case "/" : calc.operationStorage[index-1] = "/"
                default: print("Operation Error!")}
                if calc.operationStorage[index-1] == "x" || calc.operationStorage[index-1] == "/"{
                    muldiOperIndex[index-1] = true}
                else if calc.operationStorage[index-1] == "+" || calc.operationStorage[index-1] == "-"{
                    muldiOperIndex[index-1] = false}
                
                let str = calc.process.dropLast()
                calc.process = String(str)
                calc.process += calc.operationStorage[index-1]
            }
        }
        if tempDigits[index] != ""{
            if index >= 1{
                answer.append(1)
            }
            indexUpdate()
        }
        printProcess()
    }
    //MARK: - <#func clearPressed
    @IBAction func clearPressed(_ sender: UIButton) {
        clear()
        resultView.text = ""
    }
    
    //MARK: - <#func ansPressed
    @IBAction func ansPressed(_ sender: UIButton) {
        calculateAns()
    }
    
    func calculateAns(){//{d
        if index != 0 {
            for i in 0 ... index-1 {
                if muldiOperIndex[i]{
                    if  freshDI[i]{
                        if calc.operationStorage[i] == "x" {answer[i] = calc.DS[i] * calc.DS[i+1]}
                        else if calc.operationStorage[i] == "/"{answer[i] = calc.DS[i] / calc.DS[i+1]}
                        freshAI[i] = 1 ; freshDI[i] = false ; freshDI[i+1] = false;
                        result = answer[i]
                    }else if  !freshDI[i]{
                        if calc.operationStorage[i] == "x"{answer[i] = answer[i-1] * calc.DS[i+1]}
                        else if calc.operationStorage[i] == "/"{answer[i] = answer[i-1] / calc.DS[i+1]}
                        freshAI[i] = 1;freshAI[i-1] = 2 ; freshDI[i+1] = false
                        result = answer[i]
                    }
                }
            }
            for i in 0 ... index-1 {
                if !muldiOperIndex[i]{
                    if freshDI[i+1]{
                        if freshDI[i]{
                            if calc.operationStorage[i] == "+"{answer[i] = calc.DS[i] + calc.DS[i+1]}
                            else if calc.operationStorage[i] == "-"{answer[i] = calc.DS[i] - calc.DS[i+1]}
                            
                            freshAI[i] = 1 ; freshDI[i] = false ; freshDI[i+1] = false
                            result = answer[i]
                        } else if !freshDI[i]{
                            for k in 1 ... i{
                                if (freshAI[i-k] == 1) && !loopBreaker2{
                                    if calc.operationStorage[i] == "+"{answer[i] = answer[i-k] + calc.DS[i+1]}
                                    else if calc.operationStorage[i] == "-"{answer[i] = answer[i-k] - calc.DS[i+1]}
                                    
                                    freshAI[i] = 1;freshAI[i-k] = 2 ; freshDI[i+1] = false
                                    result = answer[i]
                                    loopBreaker2 = true
                                }
                            }
                            loopBreaker2 = false
                        }
                    }else if !(freshDI[i+1]){
                        for k in i ... index-1 {
                            if !loopBreaker{
                                if freshAI[k+1] == 1 {
                                    dummyPasser = true
                                    if freshDI[i]{
                                        if calc.operationStorage[i] == "+"{answer[i] = calc.DS[i] + answer[k+1]}
                                        else if calc.operationStorage[i] == "-"{answer[i] = calc.DS[i] - answer[k+1]}
                                        freshAI[i] = 1; freshDI[i] = false; freshAI[k+1] = 2;
                                        result = answer[i]
                                    }else if !freshDI[i]{
                                        for j in 1 ... i{
                                            if (freshAI[i-j] == 1) && !loopBreaker2{
                                                if calc.operationStorage[i] == "+"{
                                                    answer[i] = answer[i-j] + answer[k+1]
                                                } else if calc.operationStorage[i] == "-"{
                                                    answer[i] = answer[i-j] - answer[k+1]
                                                }
                                                freshAI[i] = 1; freshAI[i-j] = 2; freshAI[k+1] = 2
                                                result = answer[i]
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
                if freshAI[u] == 1{
                    clearAfterAns = true
                    floatingNumberDecider(ans: answer[u])
                }
            }
        }else {
            clearAfterAns = true
            floatingNumberDecider(ans: calc.DS[0])
        }
    }
    //MARK: - <#func clear
    func clear(){
        index = 0
        calc.DS = [0]
        calc.operationStorage = [""]
        tempDigits = [""]
        calc.process = ""
        printProcess()
        processView.text = "0"
        answer = [1]
        freshDI = [true]
        muldiOperIndex = [false]
    }
    //MARK: - <#func indexUpdate
    func indexUpdate(){
        muldiOperIndex.append(true)
        freshDI.append(true)
        freshAI.append(0)
        calc.operationStorage.append("")
        calc.DS.append(0)
        tempDigits.append("")
        index += 1
    }
    //MARK: - <#func printProcess
    func printProcess(){
        processView.text = calc.process
    }
    //MARK: - <#func floatingNumberDecider
    func floatingNumberDecider(ans : Double){
        var escape = false
        for i in 0 ... 6{
            let decider = Int(ans * pow(10.0, Double(i)))
            if (ans * pow(10.0,Double(i)) - Double(decider) == 0) && !escape {
                resultView.text = "\(String(format : "%.\(i)f", ans))"
                escape = true
            }
        }
        if escape == false{
            resultView.text = "\(String(format : "%.6f", ans))"
        }
    }
    
}



