import Accelerate

public class Tensor {
    var real : [Double] = []
    var imag : [Double] = []

    var shape : [Int] = []

    init(real: [Double], imag: [Double], shape: [Int]) {
        precondition(real.count == imag.count, 
                    "Tensor: Real and imaginary parts are different size")
        precondition(real.count == shape.reduce(1, {x,y in x*y}), 
                    "Tensor: Dimensions don't match input size")

        self.real = real
        self.imag = imag
        self.shape = shape
    }

    init(elements: [cplx], shape: [Int]) {
        precondition(elements.count == shape.reduce(1, {x,y in x*y}), 
                    "Tensor: Dimensions don't match input size")

        self.real = elements.map{$0.real}
        self.imag = elements.map{$0.imag}
        self.shape = shape
    }

    func reshape(_ newShape: [Int]) -> Tensor {
        return tensorReshape(T: self, newShape: newShape)
    }

    func transpose(_ newOrder: [Int]) -> Tensor {
        return tensorTranspose(T: self, newOrder: newOrder)
    }

}

public func tensorReshape(T: Tensor, newShape: [Int]) -> Tensor {
    precondition(newShape.reduce(1, {x,y in x*y}) == T.shape.reduce(1, {x,y in x*y}),
                "Tensor reshape: number of elements don't match")
    return Tensor(real: T.real, imag: T.imag, shape: newShape)
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
    var oldIdx = idx
    var oldIdxArray: [Int] = Array(repeating:0, count: shape.count)

    for ii in stride(from: shape.count-1, to: 0, by: -1) {
        oldIdxArray[ii] = oldIdx % shape[ii]
        oldIdx -= oldIdxArray[ii]
        oldIdx /= shape[ii]
    }
    oldIdxArray[0] = oldIdx

    var tempZip = Array(zip(oldIdxArray, newOrder))
    tempZip = tempZip.sorted(by: { $0.1 < $1.1})
    let newIdxArray = tempZip.map() { $0.0}

    var newIdx: Int = 0
    for ii in 0..<shape.count {
        newIdx *= shape[ii]
        newIdx += newIdxArray[ii]
    }
    return newIdx

}