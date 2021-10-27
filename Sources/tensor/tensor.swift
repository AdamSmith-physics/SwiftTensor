import Accelerate

public class Tensor {
    var real : [Double] = []
    var imag : [Double] = []

    var shape : [Int] = []

    init(real: [Double], imag: [Double], shape: [Int]) {
        precondition(real.count == imag.count, "Tensor: Real and imaginary parts are different size")
        precondition(real.count == shape.reduce(1, {xy, in x*y}), "Tensor: Dimensions don't match input size")

        self.real = real
        self.imag = imag
        self.shape = shape
    }
}