import Foundation  // for maths

public class Gate {

    var gate: Tensor = Tensor()
    var qubits: [Int] = []

    init() {}

    init(real: [Double], imag: [Double], qubits: [Int]){
        precondition((2**(2*qubits.count) == real.count) && (2**(2*qubits.count) == imag.count),
                    "Gate: Matrix size doesn't match number of qubits")

        self.gate = Tensor(real: real, imag: imag, shape: Array(repeating: 2, count: 2*qubits.count))
        self.qubits = qubits
    }

    init(elements: [cplx], qubits: [Int]){
        precondition(2**(2*qubits.count) == elements.count,
                    "Gate: Matrix size doesn't match number of qubits")

        self.gate = Tensor(elements: elements, shape: Array(repeating: 2, count: 2*qubits.count))
        self.qubits = qubits
    }

    init(matrix: [[cplx]], qubits: [Int]){

        let newMatrix = matrix.flatMap{$0}

        precondition(2**(2*qubits.count) == newMatrix.count,
                    "Gate: Matrix size doesn't match number of qubits")

        self.gate = Tensor(elements: newMatrix, shape: Array(repeating: 2, count: 2*qubits.count))
        self.qubits = qubits
    }

    func sort() {
        let argSort = argsort(self.qubits)
        let argSort_plus_N = argSort.map{$0+self.qubits.count}
        self.qubits = argSort.map{self.qubits[$0]}
        self.gate = self.gate.transpose(argSort + argSort_plus_N)
    }

    public func apply(_ state: QuantumState) -> QuantumState {
        // This needs testing!!!!!!
        let N = state.N
        let M = self.qubits.count
        for qubit in self.qubits {
            precondition(qubit < N,
                        "Gate apply: Gate acts on qubit out of range for the state!")
        }

        self.sort()
        let acted = self.qubits
        var notActed = Array(0..<N)
        notActed.removeAll(where: {acted.contains($0)})

        var newState = state.state //state.state.transpose(notActed + acted)
        newState = tensordot(newState, self.gate, axesA: acted, axesB: Array(M..<2*M))

        var newAxes = Array(repeating: 0, count: N)
        for (ii, val) in notActed.enumerated() {
            newAxes[val] = ii
        }
        for (ii, val) in acted.enumerated() {
            newAxes[val] = ii + notActed.count
        }

        newState = newState.transpose(newAxes)

        return QuantumState(state: newState)

    }

}

precedencegroup GatePrecedence {
    associativity: right
    higherThan: MultiplicationPrecedence
}

infix operator >< : GatePrecedence
public func ><(left: Gate, right: QuantumState) -> QuantumState {
    return left.apply(right)
}
