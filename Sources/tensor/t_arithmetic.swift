import Accelerate

public func +(left: Tensor, right: Tensor) -> Tensor {
    return add(left, right)
}

public func -(left: Tensor, right: Tensor) -> Tensor {
    return subtract(left, right)
}


func add(_ left: Tensor, _ right: Tensor) -> Tensor {
    precondition((left.shape == right.shape), "Add: Matrices are not the same size!")
    let real_result = vDSP.add(left.real, right.real)
    let imag_result = vDSP.add(left.imag, right.imag)
    return Tensor(real: real_result, imag: imag_result, shape: left.shape)
}

func subtract(_ left: Tensor, _ right: Tensor) -> Tensor{
    precondition((left.shape == right.shape), "Add: Matrices are not the same size!")
    let real_result = vDSP.subtract(left.real, right.real)
    let imag_result = vDSP.subtract(left.imag, right.imag)
    return Tensor(real: real_result, imag: imag_result, shape: left.shape)
}