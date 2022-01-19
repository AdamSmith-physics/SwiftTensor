

class QuantumCircuit {

    var gates: [Gate] = []
    var N: Int = 0
    var initialState: QuantumState = QuantumState()

    init(_ N: Int) {
        self.N = N
        self.initialState = QuantumState(N)
    }

    func run() -> QuantumState {
        var finalState = initialState
        for gate in gates {
            finalState = gate.apply(finalState)
        }
        return finalState
    }

    //
    // Single qubit gates
    //

    func x(_ qubit: Int) {
        gates.append(Gate.x(qubit))
    }

    func y(_ qubit: Int) {
        gates.append(Gate.y(qubit))
    }

    func z(_ qubit: Int) {
        gates.append(Gate.z(qubit))
    }

    func h(_ qubit: Int) {
        gates.append(Gate.h(qubit))
    }

    func s(_ qubit: Int) {
        gates.append(Gate.s(qubit))
    }

    func sdg(_ qubit: Int) {
        gates.append(Gate.sdg(qubit))
    }

    func t(_ qubit: Int) {
        gates.append(Gate.t(qubit))
    }

    func tdg(_ qubit: Int) {
        gates.append(Gate.tdg(qubit))
    }

    func sqrt_x(_ qubit: Int) {
        gates.append(Gate.sqrt_x(qubit))
    }
    
    func sqrt_x_dg(_ qubit: Int) {
        gates.append(Gate.sqrt_x_dg(qubit))
    }

    func p(_ theta: Double, _ qubit: Int) {
        gates.append(Gate.p(theta, qubit))
    }

    func rx(_ theta: Double, _ qubit: Int) {
        gates.append(Gate.rx(theta, qubit))
    }

    func ry(_ theta: Double, _ qubit: Int) {
        gates.append(Gate.ry(theta, qubit))
    }

    func rz(_ theta: Double, _ qubit: Int) {
        gates.append(Gate.rz(theta, qubit))
    }

    func u(_ theta: Double, _ phi: Double, _ lam: Double, _ qubit: Int) {
        gates.append(Gate.u(theta, phi, lam, qubit))
    }

    //
    // Two qubit gates
    //

    func cnot(_ control: Int, _ target: Int) {
        gates.append(Gate.cnot(control, target))
    }

    func cx(_ control: Int, _ target: Int) {
        gates.append(Gate.cx(control, target))
    }

    func swap(_ control: Int, _ target: Int) {
        gates.append(Gate.swap(control, target))
    }

    func cz(_ control: Int, _ target: Int) {
        gates.append(Gate.cz(control, target))
    }

    //
    // Three qubit gates
    //

    func toffoli(_ control1: Int, _ control2: Int, _ target: Int) {
        gates.append(Gate.toffoli(control1, control2, target))
    }

    func ccx(_ control1: Int, _ control2: Int, _ target: Int) {
        gates.append(Gate.ccx(control1, control2, target))
    }

}
