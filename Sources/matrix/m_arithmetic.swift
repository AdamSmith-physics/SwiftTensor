import Accelerate

public func +(left: Matrix, right: Matrix) -> Matrix {
    return add(left, right)
}

public func -(left: Matrix, right: Matrix) -> Matrix {
    return subtract(left, right)
}


func add(_ left: Matrix, _ right: Matrix) -> Matrix {
    precondition((left.rows == right.rows) && (left.columns == right.columns), "Add: Matrices are not the same size!")
    let real_result = vDSP.add(left.real, right.real)
    let imag_result = vDSP.add(left.imag, right.imag)
    return Matrix(real: real_result, imag: imag_result, rows: left.rows, columns: left.columns)
}

func subtract(_ left: Matrix, _ right: Matrix) -> Matrix{
    precondition((left.rows == right.rows) && (left.columns == right.columns), "Add: Matrices are not the same size!")
    let real_result = vDSP.subtract(left.real, right.real)
    let imag_result = vDSP.subtract(left.imag, right.imag)
    return Matrix(real: real_result, imag: imag_result, rows: left.rows, columns: left.columns)
}