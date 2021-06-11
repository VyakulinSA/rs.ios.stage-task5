import UIKit

class MessageDecryptor: NSObject {
    
    func decryptMessage(_ message: String) -> String {
        
        var resultMessage = ""
        var arrMessage = message.map { String($0)}
        
        var indexClose = -1
        var indexOpen = -1
        var repeatCount = 1
        var correct = 0
        
        
        while arrMessage.contains("]") || arrMessage.contains("["){
            for i in stride(from: arrMessage.count - 1, to: -1, by: -1) {
                let char = arrMessage[i]
                if char.contains("]") {
                    if indexOpen == -1 {
                        indexClose = i
                    } else {
                        continue
                    }
                }
                if char.contains("[") {
                    indexOpen = i
                    if indexOpen != -1 && i > 0 {
                        let number = Int(arrMessage[i - 1])
                        if number == nil {
                            repeatCount = 1
                            correct = 0
                        } else {
                            if i > 1 {
                                let number = Int(arrMessage[i - 2] + arrMessage[i-1])
                                if number == nil {
                                    repeatCount = Int(arrMessage[i - 1])!
                                    correct = 1
                                } else {
                                    if i > 2 {
                                        let number = Int(arrMessage[i - 3] + arrMessage[i-2] + arrMessage[i-1])
                                        if number == nil {
                                            repeatCount = Int(arrMessage[i - 2] + arrMessage[i-1])!
                                            correct = 2
                                        } else {
                                            repeatCount = number!
                                            correct = 3
                                        }
                                        
                                    }else {
                                        repeatCount = number!
                                        correct = 2
                                    }
                                    
                                }
                            }else {
                                repeatCount = Int(arrMessage[i - 1])!
                                correct = 1
                            }
                            
                        }
                    }
                }
                
                if indexOpen != -1 && indexClose != -1 {
                    let range = Range(NSRange(location: indexOpen-correct, length: indexClose - indexOpen + correct+1))
                    let slice = arrMessage[(indexOpen + 1)...(indexClose-1)]
                    arrMessage.removeSubrange(range!)
                    guard repeatCount > 0 else {return ""}
                    for _ in 1...repeatCount{
                        arrMessage.insert(contentsOf: slice, at: indexOpen-correct)
                    }
                    indexClose = -1
                    indexOpen = -1
                    repeatCount = 1
                    correct = 0
                    break
                }
                
            }
        }
        
        
        
        arrMessage.map { char in
            resultMessage += char
        }
        
        return resultMessage
    }
    
    
}
