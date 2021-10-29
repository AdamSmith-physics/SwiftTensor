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