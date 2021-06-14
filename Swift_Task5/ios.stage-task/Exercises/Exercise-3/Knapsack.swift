import Foundation

public typealias Supply = (weight: Int, value: Int)

public final class Knapsack {
    var maxWeight: Int
    var drinks: [Supply]
    var foods: [Supply]
    var maxKilometers: Int {
        findMaxKilometres()
    }
    
    init(_ maxWeight: Int, _ foods: [Supply], _ drinks: [Supply]) {
        self.maxWeight = maxWeight
        self.drinks = drinks
        self.foods = foods
    }
    
    func findMaxKilometres() -> Int {
        
        let A1 = getA(input: foods)
        let A2 = getA(input: drinks)
        
        var dict1 = [Int:[Supply]]()
        
        for i in 0...maxWeight{
            for j in 0...maxWeight {
                if A1.last![i] != 0 && A2.last![j] != 0 && i+j<=maxWeight{
                    dict1[i] = [Supply(i,A1.last![i]),Supply(j,A2.last![j])]
                }
            }
            
            
        }

        var minim = 0
        
        dict1.forEach { key, value in
            if minim < min(value[0].value,value[1].value){
                minim = min(value[0].value,value[1].value)
            }
        }
        
        return minim
    }
    
    private func getA(input: [Supply])-> [[Int]]{
        
        let n = input.count
        var w = [0]
        var p = [0]

        input.forEach { weight, value in
            p.append(value)
            w.append(weight)
        }
        
        
        var A = [[Int]](repeating: [Int](repeating: 0, count: maxWeight+1), count: n+1)
        
        for k in 1...n{
            for s in 1...maxWeight{
                if s >= w[k] {
                    A[k][s] = max(A[k-1][s], A[k-1][s-w[k]]+p[k])
                } else {
                    A[k][s] = A[k-1][s]
                }
            }
        }
        
        return A
        
    }
}
