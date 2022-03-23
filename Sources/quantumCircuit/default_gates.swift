import Foundation

let pi = Double.pi

extension Gate {

    //
    // Single qubit gates
    //

    /// Pauli X
    static func x(_ qubit: Int) -> Gate{
        let matrix_real: [Double] = [0, 1,
                                     1, 0]
        let matrix_imag = Array(repeating: 0.0, count: 4)
        return Gate(real: matrix_real, imag: matrix_imag, qubits: [qubit])
    }

    /// Pauli Y
    static func y(_ qubit: Int) -> Gate{
        let matrix_real = Array(repeating: 0.0, count: 4)
        let matrix_imag: [Double] = [0, -1,
                                     1, 0]
        return Gate(real: matrix_real, imag: matrix_imag, qubits: [qubit])
    }

    /// Pauli Z
    static func z(_ qubit: Int) -> Gate{
        let matrix_real: [Double] = [1, 0,
                                     0, -1]
        let matrix_imag = Array(repeating: 0.0, count: 4)
        return Gate(real: matrix_real, imag: matrix_imag, qubits: [qubit])
    }

    /// Hadamard
    static func h(_ qubit: Int) -> Gate{
        let a = 1/sqrt(2)
        let matrix_real = [ a, a,
                            a, -a]
        let matrix_imag = Array(repeating: 0.0, count: 4)
        return Gate(real: matrix_real, imag: matrix_imag, qubits: [qubit])
    }

    /// S gate = P(pi/2)
    static func s(_ qubit: Int) -> Gate{
        let matrix_real: [Double] = [1, 0,
                                     0, 0]
        let matrix_imag: [Double] = [0, 0,
                                     0, 1]
        return Gate(real: matrix_real, imag: matrix_imag, qubits: [qubit])
    }

    /// S dagger gate
    static func sdg(_ qubit: Int) -> Gate{
        let matrix_real: [Double] = [1, 0,
                                     0, 0]
        let matrix_imag: [Double] = [0, 0,
                                     0, -1]
        return Gate(real: matrix_real, imag: matrix_imag, qubits: [qubit])
    }

    /// T gate = P(pi/4)
    static func t(_ qubit: Int) -> Gate{
        let matrix_real: [Double] = [1, 0,
                                     0, cos(pi/4)]
        let matrix_imag: [Double] = [0, 0,
                                     0, sin(pi/4)]
        return Gate(real: matrix_real, imag: matrix_imag, qubits: [qubit])
    }

    /// T dagger gate
    static func tdg(_ qubit: Int) -> Gate{
        let matrix_real: [Double] = [1, 0,
                                     0, cos(pi/4)]
        let matrix_imag: [Double] = [0, 0,
                                     0, -sin(pi/4)]
        return Gate(real: matrix_real, imag: matrix_imag, qubits: [qubit])
    }

    /// Square root X gate
    static func sqrt_x(_ qubit: Int) -> Gate{
        let matrix_real: [Double] = [1/2, 1/2,
                                     1/2, 1/2]
        let matrix_imag: [Double] = [1/2, -1/2,
                                     -1/2, 1/2]
        return Gate(real: matrix_real, imag: matrix_imag, qubits: [qubit])
    }

    /// Square root X dagger gate
    static func sqrt_x_dg(_ qubit: Int) -> Gate{
        let matrix_real: [Double] = [1/2, 1/2,
                                     1/2, 1/2]
        let matrix_imag: [Double] = [-1/2, 1/2,
                                     1/2, -1/2]
        return Gate(real: matrix_real, imag: matrix_imag, qubits: [qubit])
    }

    /// Phase gate exp(-i Z theta / 2)
    static func p(_ theta: Double, _ qubit: Int) -> Gate{
        return Gate.rz(theta, qubit)
    }

    /// X rotation gate exp(-i X theta / 2)
    static func rx(_ theta: Double, _ qubit: Int) -> Gate{
        let matrix_real: [Double] = [cos(theta/2), 0,
                                     0,            cos(theta/2)]
        let matrix_imag: [Double] = [0,             -sin(theta/2),
                                     -sin(theta/2),  0           ]
        return Gate(real: matrix_real, imag: matrix_imag, qubits: [qubit])
    }

    /// Y rotation gate exp(-i Y theta / 2)
    static func ry(_ theta: Double, _ qubit: Int) -> Gate{
        let matrix_real: [Double] = [cos(theta/2), -sin(theta/2),
                                     sin(theta/2),  cos(theta/2)]
        let matrix_imag: [Double] = [0, 0,
                                     0, 0]
        return Gate(real: matrix_real, imag: matrix_imag, qubits: [qubit])
    }

    /// Z rotation gate exp(-i Z theta / 2)
    static func rz(_ theta: Double, _ qubit: Int) -> Gate{
        let matrix_real: [Double] = [cos(theta/2), 0,
                                     0,            cos(theta/2)]
        let matrix_imag: [Double] = [-sin(theta/2), 0,
                                     0,             sin(theta/2)]
        return Gate(real: matrix_real, imag: matrix_imag, qubits: [qubit])
    }

    /// General singlue qubit rotation
    static func u(_ theta: Double, _ phi: Double, _ lam: Double, _ qubit: Int) -> Gate{
        let matrix_real: [Double] = [cos(theta/2),           -cos(lam)*sin(theta/2),
                                     cos(phi)*sin(theta/2),   cos(phi+lam)*cos(theta/2)]
        let matrix_imag: [Double] = [0,                      -sin(lam)*sin(theta/2),
                                     sin(phi)*sin(theta/2),   sin(phi+lam)*cos(theta/2)]
        return Gate(real: matrix_real, imag: matrix_imag, qubits: [qubit])
    }

    //
    // Two qubit gates
    //

    /// CNOT gates (controlled-X)
    static func cnot(_ control: Int, _ target: Int) -> Gate{
        let matrix_real: [Double] = [1, 0, 0, 0,
                                     0, 1, 0, 0,
                                     0, 0, 0, 1,
                                     0, 0, 1, 0 ]
        let matrix_imag = Array(repeating: 0.0, count: 16)
        return Gate(real: matrix_real, imag: matrix_imag, qubits: [control, target])
    }

    /// alternative notation for CNOT gates (controlled-X)
    static func cx(_ control: Int, _ target: Int) -> Gate{
        return Gate.cnot(control, target)
    }

    /// SWAP gate
    static func swap(_ control: Int, _ target: Int) -> Gate{
        let matrix_real: [Double] = [1, 0, 0, 0,
                                     0, 0, 1, 0,
                                     0, 1, 0, 0,
                                     0, 0, 0, 1 ]
        let matrix_imag = Array(repeating: 0.0, count: 16)
        return Gate(real: matrix_real, imag: matrix_imag, qubits: [control, target])
    }

    /// Controlled phase gate
    static func cz(_ control: Int, _ target: Int) -> Gate{
        let matrix_real: [Double] = [1, 0, 0, 0,
                                     0, 1, 0, 0,
                                     0, 0, 1, 0,
                                     0, 0, 0, -1 ]
        let matrix_imag = Array(repeating: 0.0, count: 16)
        return Gate(real: matrix_real, imag: matrix_imag, qubits: [control, target])
    }
    
    /// Controlled u gate
    static func cu(_ control: Int, _ target: Int,_ theta: Double, _ phi: Double, _ lam: Double) -> Gate{
        let matrix_real: [Double] = [1, 0, 0,                       0,
                                     0, 1, 0,                       0,
                                     0, 0, cos(theta/2),           -cos(lam)*sin(theta/2),
                                     0, 0, cos(phi)*sin(theta/2),   cos(phi+lam)*cos(theta/2)]
        let matrix_imag: [Double] = [0, 0, 0,                       0,
                                     0, 0, 0,                       0,
                                     0, 0, 0,                      -sin(lam)*sin(theta/2),
                                     0, 0, sin(phi)*sin(theta/2),   sin(phi+lam)*cos(theta/2)]
        return Gate(real: matrix_real, imag: matrix_imag, qubits: [control, target])
    }


    //
    // Three qubit gates
    //

    /// Toffoli gate
    static func toffoli(_ control1: Int, _ control2: Int, _ target: Int) -> Gate{
        let matrix_real: [Double] = [1, 0, 0, 0, 0, 0, 0, 0,
                                     0, 1, 0, 0, 0, 0, 0, 0,
                                     0, 0, 1, 0, 0, 0, 0, 0,
                                     0, 0, 0, 1, 0, 0, 0, 0,
                                     0, 0, 0, 0, 1, 0, 0, 0,
                                     0, 0, 0, 0, 0, 1, 0, 0,
                                     0, 0, 0, 0, 0, 0, 0, 1,
                                     0, 0, 0, 0, 0, 0, 1, 0 ]
        let matrix_imag = Array(repeating: 0.0, count: 8*8)
        return Gate(real: matrix_real, imag: matrix_imag, qubits: [control1, control2, target])
    }

    /// Alternative notation for Toffoli gate
    static func ccx(_ control1: Int, _ control2: Int, _ target: Int) -> Gate{
        return Gate.toffoli(control1, control2, target)
    }

}
