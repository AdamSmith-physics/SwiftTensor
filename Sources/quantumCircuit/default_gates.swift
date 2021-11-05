import Foundation


extension Gate {

    static func x(_ qubit: Int) -> Gate{
        let matrix_real: [Double] = [0, 1,
                                     1, 0]
        let matrix_imag = Array(repeating: 0.0, count: 4)
        return Gate(real: matrix_real, imag: matrix_imag, qubits: [qubit])
    }

    static func h(_ qubit: Int) -> Gate{
        let a = 1/sqrt(2)
        let matrix_real = [ a, a,
                            a, -a]
        let matrix_imag = Array(repeating: 0.0, count: 4)
        return Gate(real: matrix_real, imag: matrix_imag, qubits: [qubit])
    }

    static func cnot(_ control: Int, _ target: Int) -> Gate{
        let matrix_real: [Double]= [1, 0, 0, 0,
                                    0, 1, 0, 0,
                                    0, 0, 0, 1,
                                    0, 0, 1, 0 ]
        let matrix_imag = Array(repeating: 0.0, count: 16)
        return Gate(real: matrix_real, imag: matrix_imag, qubits: [control, target])
    }

}