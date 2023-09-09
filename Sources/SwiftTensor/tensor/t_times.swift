import Accelerate

public prefix func -(tensor: Tensor) -> Tensor {
    return -1.0 * tensor
}

infix operator .* : DefaultPrecedence
public func .*(left: Tensor, right: Tensor) -> Tensor {
    precondition(left.shape == right.shape,
                "Element-wise mutliply: Tensor dimensions don't match!")

    let real1 = vDSP.multiply(left.real, right.real)
    let real2 = vDSP.multiply(left.imag, right.imag)
    let imag1 = vDSP.multiply(left.real, right.imag)
    let imag2 = vDSP.multiply(left.imag, right.real)

    return Tensor(  real: vDSP.subtract(real1, real2), 
                    imag: vDSP.add(imag1, imag2), 
                    shape: left.shape)

}

public func *(left: Double, right: Tensor) -> Tensor {
    let realPart = vDSP.multiply(left, right.real)
    let imagPart = vDSP.multiply(left, right.imag)
    return Tensor(real: realPart, imag: imagPart, shape: right.shape)
}

public func *(left: Tensor, right: Double) -> Tensor {
    return right * left
}

public func *(left: cplx, right: Tensor) -> Tensor {
    let realPart = vDSP.subtract(   vDSP.multiply(left.real, right.real),
                                    vDSP.multiply(left.imag, right.imag))
    let imagPart = vDSP.add(vDSP.multiply(left.real, right.imag),
                            vDSP.multiply(left.imag, right.real))
    return Tensor(real: realPart, imag: imagPart, shape: right.shape)
}

public func *(left: Tensor, right: cplx) -> Tensor {
    return right * left
}

public func tensordot(_ A: Tensor, _ B: Tensor, axesA: [Int], axesB: [Int]) -> Tensor {
    precondition(axesA.count == axesB.count,
                "Tensordot: number of contraction axes doesn't match!")
    precondition(axesA.max()! < A.shape.count,
                "Tensordot: axes out of range for tensor A")
    precondition(axesB.max()! < B.shape.count,
                "Tensordot: axes out of range for tensor B")
    for (ii, val) in axesA.enumerated() {
        precondition(A.shape[val] == B.shape[axesB[ii]],
                "Tensordot: length of contraction axes doesn't match!")
    }

    var idxA: [Int] = []
    var dimsA: [Int] = []
    var dimsK: [Int] = []
    
    // can do without for loop!
    for ii in 0..<A.shape.count {
        if !axesA.contains(ii) {
            idxA.append(ii)
            dimsA.append(A.shape[ii])
        }
        else {
            dimsK.append(A.shape[ii])
        }
    }

    var idxB: [Int] = []
    var dimsB: [Int] = []
    for ii in 0..<B.shape.count {
        if !axesB.contains(ii) {
            idxB.append(ii)
            dimsB.append(B.shape[ii])
        }
    }

    let M = dimsA.reduce(1, {x,y in x*y})
    let K = dimsK.reduce(1, {x,y in x*y})
    let N = dimsB.reduce(1, {x,y in x*y})

    var A_t = A.transpose(idxA + axesA)
    var A_mat = Matrix(real: A_t.real, imag: A_t.imag, rows: M, columns: K)
    A_t = Tensor()  // reduce memory usage!

    var B_t = B.transpose(axesB + idxB)
    let B_mat = Matrix(real: B_t.real, imag: B_t.imag, rows: K, columns: N)
    B_t = Tensor()  // reduce memory usage!

    A_mat = A_mat * B_mat  // reuse A_mat

    return Tensor(real: A_mat.real, imag: A_mat.imag, shape: dimsA + dimsB)

}