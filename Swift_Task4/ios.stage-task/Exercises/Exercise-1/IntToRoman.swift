import Foundation

public extension Int {
    
    var roman: String? {
        guard self > 0 && self < 4000 else {    return nil  }
        var n = self
        var romanString = ""
        while n > 0 {
            switch n {
            case 1000...:
                romanString.append("M")
                n -= 1000
            case 900..<1000:
                romanString.append("CM")
                n -= 900
            case 500..<900:
                romanString.append("D")
                n -= 500
            case 400..<500:
                romanString.append("CD")
                n -= 400
            case 100..<400:
                romanString.append("C")
                n -= 100
            case 90..<100:
                romanString.append("XC")
                n -= 90
            case 50..<90:
                romanString.append("L")
                n -= 50
            case 40..<50:
                romanString.append("XL")
                n -= 40
            case 10..<40:
                romanString.append("X")
                n -= 10
            case 9:
                romanString.append("IX")
                n -= 9
            case 5..<9:
                romanString.append("V")
                n -= 5
            case 4:
                romanString.append("IV")
                n -= 4
            case 1..<4:
                romanString.append("I")
                n -= 1
            default:
                break
            }
        }
        return romanString
    }
}
