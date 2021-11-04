
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