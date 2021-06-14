import Foundation

public typealias Supply = (weight: Int, value: Int)

public final class Knapsack {
    let maxWeight: Int
    let drinks: [Supply]
    let foods: [Supply]
    var maxKilometers: Int {
        findMaxKilometres()
    }
    
    init(_ maxWeight: Int, _ foods: [Supply], _ drinks: [Supply]) {
        self.maxWeight = maxWeight
        self.drinks = drinks
        self.foods = foods
    }
    
    func findMaxKilometres() -> Int {
        var minim = 0
        let A1 = getA(input: foods)
        let A2 = getA(input: drinks)
        
        //FIXME: Первое решение, не проходит 2500 локально и 1500 на сервере
        //        var dict1 = [Int:[Supply]]()
        
        //        for i in 0...maxWeight{
        //            for j in 0...maxWeight {
        //                if A1.last![i] != 0 && A2.last![j] != 0 && i+j<=maxWeight{
        //                    dict1[i] = [Supply(i,A1.last![i]),Supply(j,A2.last![j])]
        //                }
        //            }
        //        }
        
        //после того как получили максимальную ценность предмета(вода и еда) на каждом кг веса
        //нам надо оптимально их взять с собой, логично представить, что они будут примерно в середине
        //получаем каждый новый минимум между предметам с самым большим весом и самым маленьким.
        for i in 0...maxWeight{
            if minim < min(A1.last![i],A2.last![maxWeight-i]) {
                minim = min(A1.last![i],A2.last![maxWeight-i])
            }
        }
        
        //FIXME: Первое решение, не проходит 2500 локально и 1500 на сервере
        //        dict1.forEach { key, value in
        //            if minim < min(value[0].value,value[1].value){
        //                minim = min(value[0].value,value[1].value)
        //            }
        //        }
        
        
        return minim
    }
    
    private func getA(input: [Supply])-> [[Int]]{
//        MARK: Инфо
//        https://neerc.ifmo.ru/wiki/index.php?title=Задача_о_рюкзаке
//        Горокаем алгоритмы гл.9 стр.206
        
        let n = input.count //всего предметов
        var w = [0] //массив для хранения веса каждого предмета (нулевые элементы приравниваем к нулю)
        var p = [0] //массив для хранения значения предмета(цена, рассояние которое поможет пройти, и тд)
        
        //наполняем массивы для сохранения соответствия
        input.forEach { weight, value in
            p.append(value)
            w.append(weight)
        }
        
        //создаем набор допустимых предметов (A)
        var A = [[Int]](repeating: [Int](repeating: 0, count: maxWeight+1), count: n+1)
        
        //идем по предметам (строки)
        for k in 1...n{
            //идем по весам (столбцы)
            for s in 1...maxWeight{
                //если текущий вмещаемый вес ячейки позволяет вместить предмет
                if s >= w[k] {
                    //то в ячейку вносим
                    //либо ценность предмета который раньше лежал(выше строкой) - если он ценнее - A[k-1][s]
                    //либо складываем ценность прошлого предмета который распологается в ячейке(текуйщий вес на строке выше -  вес нового предмета) - для того, чтобы могло вместиться в текущий вес) + ценность нового предмета A[k-1][s-w[k]]+p[k]
                    A[k][s] = max(A[k-1][s], A[k-1][s-w[k]]+p[k])
                } else {
                    //если не вмещаем вес в ячейку, то оставляем ценность прошлой ячейки, которая выше
                    A[k][s] = A[k-1][s]
                }
            }
        }
        
        return A
        
    }
}
