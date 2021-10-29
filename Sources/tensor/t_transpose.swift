import Accelerate

extension Tensor {
    var conj : Tensor {
        get{
            return conjugate(self)
        }
    }

    func transpose(_ newOrder: [Int]) -> Tensor {
        return tensorTranspose(T: self, newOrder: newOrder)
    }
}

func conjugate(_ T: Tensor) -> Tensor {
    return Tensor(  real: T.real, 
                    imag: vDSP.multiply(-1,T.imag), 
                    shape: T.shape)
}


public func tensorTranspose(T: Tensor, newOrder: [Int]) -> Tensor {
    var checkOrder = newOrder
    checkOrder.sort()
    var orderIsValid = true
    for (ii, val) in checkOrder.enumerated(){
        if ii != val { 
            orderIsValid=false 
            break 
        }
    }
    precondition(orderIsValid, "Tensor transpose: new order is not valid!")

    var newReal: [Double] = Array(repeating: 0.0, count: T.real.count)
    var newImag: [Double] = Array(repeating: 0.0, count: T.imag.count)

    for idx in 0..<T.real.count {
        let newIdx = newIndexValue(idx: idx, shape: T.shape, newOrder: newOrder)
        newReal[idx] = T.real[newIdx]
        newImag[idx] = T.imag[newIdx]
    }

    var tempZip = Array(zip(T.shape, newOrder))
    tempZip = tempZip.sorted(by: { $0.1 < $1.1})
    let newShape = tempZip.map() { $0.0}

    return Tensor(real: newReal, imag: newImag, shape: newShape)

}

func newIndexValue(idx: Int, shape: [Int], newOrder: [Int]) -> Int {
    
    let oldIdxArray = idx_to_array(idx: idx, shape: shape)

    var tempZip = Array(zip(oldIdxArray, newOrder))
    tempZip = tempZip.sorted(by: { $0.1 < $1.1})
    let newIdxArray = tempZip.map() { $0.0}

    let newIdx = array_to_idx(idxArray: newIdxArray, shape: shape)

    return newIdx

}

func idx_to_array(idx: Int, shape: [Int]) -> [Int]{
    var oldIdx = idx
    var idxArray: [Int] = Array(repeating:0, count: shape.count)

    for ii in stride(from: shape.count-1, to: 0, by: -1) {
        idxArray[ii] = oldIdx % shape[ii]
        oldIdx -= idxArray[ii]
        oldIdx /= shape[ii]
    }
    idxArray[0] = oldIdx
    return idxArray
}

func array_to_idx(idxArray: [Int], shape: [Int]) -> Int {
    var idx: Int = 0
    for ii in 0..<shape.count {
        idx *= shape[ii]
        idx += idxArray[ii]
    }
    return idx
}