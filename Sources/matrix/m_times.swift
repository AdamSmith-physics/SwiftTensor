import Accelerate


public func *(left: Matrix, right: Matrix) -> Matrix {
    return mtimes(left, right)
}

infix operator .* : DefaultPrecedence
public func .*(left: Matrix, right: Matrix) -> Matrix {
    precondition((left.rows == right.rows) && (left.columns == right.columns),
                "Element-wise mutliply: Matrix dimensions don't match!")

    let real1 = vDSP.multiply(left.real, right.real)
    let real2 = vDSP.multiply(-1, vDSP.multiply(left.imag, right.imag))
    let imag1 = vDSP.multiply(left.real, right.imag)
    let imag2 = vDSP.multiply(left.imag, right.real)

    return Matrix(  real: vDSP.add(real1, real2), 
                    imag: vDSP.add(imag1, imag2), 
                    rows: left.rows, 
                    columns: right.columns)

}

public func mtimes(_ left: Matrix, _ right: Matrix) -> Matrix {
    precondition((left.columns == right.rows),
                "Matrix mutliply: Matrix dimensions don't match!")

    let M = left.rows
    let K = left.columns
    let N = right.columns

    let real1 = mtimesD(left.real, right.real, M, K, N)
    let real2 = vDSP.multiply(-1, mtimesD(left.imag, right.imag, M, K, N))
    let imag1 = mtimesD(left.real, right.imag, M, K, N)
    let imag2 = mtimesD(left.imag, right.real, M, K, N)

    return Matrix(  real: vDSP.add(real1, real2), 
                    imag: vDSP.add(imag1, imag2), 
                    rows: M, 
                    columns: N)
}

public func mtimesD(_ left: [Double], _ right: [Double], _ M: Int, _ K: Int, _ N: Int) -> [Double] {
    precondition((left.count == M*K) && (right.count == K*N),
                "Double Array mutliply: Arrays are wrong size!")

    let aStride = vDSP_Stride(1)
    let bStride = vDSP_Stride(1)
    let cStride = vDSP_Stride(1)

    var C : [Double] = Array(repeating: 0.0, count: N*M)

    vDSP_mmulD(
        left, aStride,
        right, bStride,
        &C, cStride,
        vDSP_Length(M),
        vDSP_Length(N),
        vDSP_Length(K)
    )

    return C
}