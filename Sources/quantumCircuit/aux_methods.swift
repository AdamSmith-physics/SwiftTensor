
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