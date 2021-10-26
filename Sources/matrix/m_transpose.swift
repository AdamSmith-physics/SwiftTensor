import Accelerate

extension Matrix {
    var T : Matrix {
        get{
            return transpose(self)
        }
    }

    var conj : Matrix {
        get{
            return conjugate(self)
        }
    }

    var dag : Matrix {
        get{
            return adjoint(self)
        }
    }
}

func transpose(_ matrix: Matrix) -> Matrix {

    let aStride = vDSP_Stride(1)
    let cStride = vDSP_Stride(1)
    let M = vDSP_Length(matrix.columns)
    let N = vDSP_Length(matrix.rows)

    let real_array = matrix.real
    var new_real : [Double] = Array(repeating: 0.0, count: matrix.rows * matrix.columns)
    vDSP_mtransD(real_array, aStride, &new_real, cStride, M, N)

    let imag_array = matrix.imag
    var new_imag : [Double] = Array(repeating: 0.0, count: matrix.rows * matrix.columns)
    vDSP_mtransD(imag_array, aStride, &new_imag, cStride, M, N)

    let newMatrix = Matrix( real: new_real, 
                            imag: new_imag, 
                            rows: matrix.columns, columns: matrix.rows)

    return newMatrix
}

func conjugate(_ matrix: Matrix) -> Matrix {
    return Matrix(  real: matrix.real, 
                    imag: vDSP.multiply(-1,matrix.imag), 
                    rows: matrix.rows, columns: matrix.columns)
}

func adjoint(_ matrix: Matrix) -> Matrix {
    return matrix.conj.T
}