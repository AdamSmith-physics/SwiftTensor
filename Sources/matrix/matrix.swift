import Accelerate

public struct cplx : CustomStringConvertible {
    var real : Double
    var imag : Double

    init(_ real: Double, _ imag: Double) {
        self.real = real
        self.imag = imag
    }

    public var description: String {
        if imag.sign == .plus {
            return "\(self.real) + \(self.imag)i"
        }
        else if imag.sign == .minus {
            return "\(self.real) - \(-self.imag)i"
        }
        else {
            precondition(false, "Error printing cplx!")
        }
    }

    static func +(left: cplx, right: cplx) -> cplx{
        return cplx(left.real + right.real, left.imag + right.imag)
    }
}

public func +(left: [cplx], right: [cplx]) -> [cplx]{
    var cplx_list: [cplx] = []
    for (ii, val) in left.enumerated(){
        cplx_list.append(val + right[ii])
    }
    return cplx_list
}

public class Matrix : CustomStringConvertible {
    var real : [Double] = []
    var imag : [Double] = []

    //var matrix : DSPDoubleSplitComplex = DSPDoubleSplitComplex(realp: &[0.0], imagp: &[0.0])
    var rows : Int = 0
    var columns : Int = 0

    public var description: String {
        let real_as_cplx : [cplx] = self.real.map{cplx($0,0)}
        let imag_as_cplx : [cplx] = self.imag.map{cplx(0,$0)}
        let cplx_list = real_as_cplx + imag_as_cplx
        let cplx_list_unflat = unflatten(matrix: cplx_list, rows: rows, columns: columns)
        var print_string: String = "["
        for (ii, temp_list) in cplx_list_unflat.enumerated() {
            if ii > 0 { print_string += "\n " }
            print_string += "\(temp_list)"
        }
        print_string += "]"
        return print_string
    }

    subscript(_ row: Int, _ column: Int) -> cplx {
        get {
            return cplx(real[row*columns + column], imag[row*columns + column])
        }
        set(newValue) {
            real[row*columns + column] = newValue.real
            imag[row*columns + column] = newValue.imag
        }
    }

    init(real: [Double], imag: [Double], rows: Int, columns: Int) {
        precondition(real.count == imag.count, "Real and imaginary parts are different size")
        precondition(real.count == rows*columns, "Matrix dimensions don't match input size")

        self.real = real
        self.imag = imag
        self.rows = rows
        self.columns = columns
    }

    init(elements: [cplx], rows: Int, columns: Int) {
        precondition(elements.count == rows*columns, "Matrix dimensions don't match input size")

        self.real = elements.map{$0.real}
        self.imag = elements.map{$0.imag}
        self.rows = rows
        self.columns = columns
    }

    init(real: [[Double]], imag: [[Double]]) {
        let flat_real = real.flatMap{$0}
        let flat_imag = imag.flatMap{$0}
        
        rows = real.count
        columns = real[0].count

        precondition(flat_real.count == flat_imag.count, "Real and imaginary parts are different size")
        precondition(flat_real.count == rows*columns, "Matrix dimensions don't match input size")

        self.real = flat_real
        self.imag = flat_imag
    }

    init(_ elements: [[cplx]]) {
        let flat_real = elements.flatMap{$0.map{$0.real}}
        let flat_imag = elements.flatMap{$0.map{$0.imag}}
        
        rows = elements.count
        columns = elements[0].count

        precondition(flat_real.count == rows*columns, "Matrix dimensions don't match input size")

        self.real = flat_real
        self.imag = flat_imag
    }

    

}

func unflatten<type>(matrix: [type], rows: Int, columns: Int) -> [[type]] {
    let arrayShape = Array(repeating: Array(repeating: 0.0, count: columns), count: rows)
    var iter = matrix.makeIterator()
    return arrayShape.map { $0.compactMap { _ in iter.next() } }
}
