import Accelerate

public class Tensor: Codable {
    var real : [Double] = []
    var imag : [Double] = []

    var shape : [Int] = []

    subscript(_ indices: [Int]) -> cplx {
        get {
            precondition(indices.count == shape.count,
                        "Tensor: invalid indicies")
            for (ii, idx) in indices.enumerated() {
                precondition(idx < shape[ii],
                        "Tensor: invalid indicies")  // make more descriptive!
            }
            let idx = array_to_idx(idxArray: indices, shape: self.shape)
            return cplx(real[idx], imag[idx])
        }
        set(newValue) {
            precondition(indices.count == shape.count,
                        "Tensor: invalid indicies")
            for (ii, idx) in indices.enumerated() {
                precondition(idx < shape[ii],
                        "Tensor: invalid indicies")  // make more descriptive!
            }
            let idx = array_to_idx(idxArray: indices, shape: self.shape)
            real[idx] = newValue.real
            imag[idx] = newValue.imag
        }
    }

    init(){}

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
    
    static func == (lhs: Tensor, rhs: Tensor) -> Bool {
        return
            lhs.real == rhs.real &&
            lhs.imag == rhs.imag &&
            lhs.shape == rhs.shape
    }

    func reshape(_ newShape: [Int]) -> Tensor {
        return tensorReshape(T: self, newShape: newShape)
    }

}

public func tensorReshape(T: Tensor, newShape: [Int]) -> Tensor {
    precondition(newShape.reduce(1, {x,y in x*y}) == T.shape.reduce(1, {x,y in x*y}),
                "Tensor reshape: number of elements don't match")
    return Tensor(real: T.real, imag: T.imag, shape: newShape)
}

