import Foundation

class StockMaximize {

    func countProfit(prices: [Int]) -> Int {
        guard prices.count > 1 else {return 0}
        var curProfit = 0, profit = 0
        
        //проходим по массиву с акциями и проверяем цену сегодняшнюю со следующей
        for i in 0..<prices.count {
            for j in i+1..<prices.count {
                //если есть прибыль от продажи, то считаем ее как текущую прибыль на участке
                let profit = prices[j] - prices[i]
                //если он больше текущей прибыли, то обновляем текущую прибыль (значит продаем в другой день)
                if (profit > curProfit) {
                    curProfit = profit
                }
            }
            //складываем текущую прибыль в одну глобальную сумму на всем этапе
            profit += curProfit
            //текущую сумму на участке обнуляем
            curProfit = 0
        }
        return profit
    }
}
