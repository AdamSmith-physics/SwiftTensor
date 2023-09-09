
infix operator **: MultiplicationPrecedence
func **(base: Int, exponent: Int) -> Int {
    return power(base, exponent)
}

public func power(_ base: Int, _ exponent: Int) -> Int {
    if base == 2 {
        return 2 << (exponent - 1)
    }
    else {
        var result = 1
        for _ in 0..<exponent {
            result *= base
        }
        return result
    }
}

public func argsort<T:Comparable>( _ a : [T] ) -> [Int] {
    //sorted ascending!
    var r = Array(a.indices)
    r.sort(by: {a[$0] < a[$1]})
    return r
}

public func sum(_ array: [Double]) -> Double {
    return array.reduce(0){ $0 + $1 }
}

public func cumsum(_ array: [Double]) -> [Double] {
    let indices = [Int](0..<array.count)
    return indices.map{ array[0...$0].reduce(0){ $0 + $1 } }
}

func num2bin(num : Int, toSize: Int) -> String {
    let string = String(num, radix: 2)
    var padded = string
    for _ in 0..<(toSize - string.count) {
        padded = "0" + padded
    }
    return padded
}


extension String {

    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}
