import UIKit

class MessageDecryptor: NSObject {
    
    func decryptMessage(_ message: String) -> String {
        
        var resultMessage = ""
        var arrMessage = message.map { String($0)}//разбиваем сообщение в массив, для работы
        
        var indexClose = -1 //для записи индекса закрывающей скобки
        var indexOpen = -1 //для записи индекса открывающей скобки
        var repeatCount = 1 //для записи кол-ва повторений(те что перед скобками)
        var correct = 0 //корректировка индекса для замены в массиве (зависит от числа повторений (кратно: 1,10,100)
        
        
        while arrMessage.contains("]") || arrMessage.contains("["){ //пока в тексте есть скобки делаем операции
            for i in stride(from: arrMessage.count - 1, to: -1, by: -1) { //идем с конца массива к началу (чтобы точно узнать глубину скобок
                let char = arrMessage[i] //получаем текущий символ
                if char.contains("]") {
                    if indexOpen == -1 { //если открывающая скобка не была определена, значит обновляем индекс закрывающей и идем глубже
                        indexClose = i
                    } else { //если открывающая скобка была найдена то нас на данный момент больше не интересует индекс закрывающей
                        continue
                    }
                }
                
                //весь алгоритм рассчитан на получение самого глубокого вхождения скобок, из умножение и замена на тоже место, потом повтор на более высокий уровень и тд.
                if char.contains("[") { //как только находим открывающуюся скобку
                    indexOpen = i //записываем индекс
                    if indexOpen != -1 && i > 0 { //если закрывающая скобка тоже была найдена
                        let number = Int(arrMessage[i - 1]) //проверяем наличие числа повторений рядом со скобкой
                        if number == nil { //если числа нет, то считаем за одно повторение и корректировка не нужна
                            repeatCount = 1
                            correct = 0
                        } else { //если число обнаружено, проверяем глубже может у нас десяток
                            if i > 1 { //если длинна массива позволяет углубиться еще на один знак
                                let number = Int(arrMessage[i - 2] + arrMessage[i-1]) //проверяем наличие еще одного числа, перед предыдущим числом
                                if number == nil { //если глубже не находится число
                                    repeatCount = Int(arrMessage[i - 1])! //то предыдущие считается единственным и записываем его
                                    correct = 1 //корректировка смещения для замены +1 знак
                                } else { //если снова находим число углубляемся еще на один знак
                                    if i > 2 { //если длинна массива позволяет углубиться еще на один знак (по условию максимум трехзначное число 300)
                                        let number = Int(arrMessage[i - 3] + arrMessage[i-2] + arrMessage[i-1])//проверяем наличие еще одного числа, перед предыдущим числом
                                        if number == nil { //если глубже не находится число
                                            repeatCount = Int(arrMessage[i - 2] + arrMessage[i-1])! //то предыдущие считается двойным и записываем его
                                            correct = 2 //корректировка на 2 знака subrange
                                        } else { //если число, то дальше не углубляемся по условию и берем последнее как число повторений
                                            repeatCount = number!
                                            correct = 3 //корректируем на 3 знака замену subrange
                                        }
                                        
                                    }else { //если не можем углубиться по длинне массива, значит берем двойное число
                                        repeatCount = number!
                                        correct = 2
                                    }
                                    
                                }
                            }else { //если не можем углубиться по длинне массива, значит берем простое число
                                repeatCount = Int(arrMessage[i - 1])!
                                correct = 1
                            }
                            
                        }
                    }
                }
                
                //как только определили индексы открывающей и закрывающей скобок + число повторений + смещение
                if indexOpen != -1 && indexClose != -1 {
                    //получаем range содержащий чило + открывающую скобку + сообщение + закрывающую скобку
                    let range = Range(NSRange(location: indexOpen-correct, length: indexClose - indexOpen + correct+1))
                    //получаем сообщение внутри скобок
                    let slice = arrMessage[(indexOpen + 1)...(indexClose-1)]
                    //удаляем из массива range  с числом и скобками
                    arrMessage.removeSubrange(range!)
                    //проверка повторов
                    guard repeatCount > 0 else {return ""}
                    //если есть кол-во повторов, вставляем за место числа и скобок, новое раскрытое из скобок сообщение (без скобок)
                    for _ in 1...repeatCount{
                        arrMessage.insert(contentsOf: slice, at: indexOpen-correct)
                    }
                    //сбрасываем индексы
                    indexClose = -1
                    indexOpen = -1
                    repeatCount = 1
                    correct = 0
                    break
                }
                
            }
        }
        
        
        //составляем результирующую строку из массива
        arrMessage.forEach { char in
            resultMessage += char
        }
        
        return resultMessage
    }
    
    
}
