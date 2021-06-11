import Foundation

class StockMaximize {

    func countProfit(prices: [Int]) -> Int {
        guard prices.count > 1 else {return 0}
        var curProfit = 0, profit = 0
        
        for i in 0..<prices.count {
            for j in i+1..<prices.count {
                let profit = prices[j] - prices[i]
                if (profit > curProfit) {
                    curProfit = profit
                }
            }
            profit += curProfit
            curProfit = 0
        }
        return profit
    }
}
