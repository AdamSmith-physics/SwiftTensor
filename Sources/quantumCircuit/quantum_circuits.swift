

class QuantumCircuit {

    var gates: [Gate] = []
    var N: Int = 0
    var initialState: QuantumState = QuantumState()
    var measureQubits: [Int] = []

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
    
    func run(shots: Int) -> [String : Int] {
        var finalState = initialState
        for gate in gates {
            finalState = gate.apply(finalState)
        }
        return finalState.measure(shots: shots, qubits: measureQubits)
    }

    //
    // Measurement gate
    //
    
    func measure(_ qubit: Int) {
        if measureQubits.contains(qubit) {
            print("qubit already measured!")
        } else {
            if qubit >= 0 && qubit < N {
                measureQubits = measureQubits + [qubit]
            } else {
                print("qubit out of range!!")
                // Add proper error handling.
            }
        }
    }
    
    func measure(_ qubits: [Int]) {
        for qubit in qubits {
            self.measure(qubit)
        }
    }
    
    func isQubitMeasured(_ qubit: Int) -> Bool {
        return measureQubits.contains(qubit)
    }
    
    //
    // Single qubit gates
    //

    func x(_ qubit: Int) {
        if isQubitMeasured(qubit) { print("Gate applied after measurement. Not currently implemented!") }
        gates.append(Gate.x(qubit))
    }

    func y(_ qubit: Int) {
        if isQubitMeasured(qubit) { print("Gate applied after measurement. Not currently implemented!") }
        gates.append(Gate.y(qubit))
    }

    func z(_ qubit: Int) {
        if isQubitMeasured(qubit) { print("Gate applied after measurement. Not currently implemented!") }
        gates.append(Gate.z(qubit))
    }

    func h(_ qubit: Int) {
        if isQubitMeasured(qubit) { print("Gate applied after measurement. Not currently implemented!") }
        gates.append(Gate.h(qubit))
    }

    func s(_ qubit: Int) {
        if isQubitMeasured(qubit) { print("Gate applied after measurement. Not currently implemented!") }
        gates.append(Gate.s(qubit))
    }

    func sdg(_ qubit: Int) {
        if isQubitMeasured(qubit) { print("Gate applied after measurement. Not currently implemented!") }
        gates.append(Gate.sdg(qubit))
    }

    func t(_ qubit: Int) {
        if isQubitMeasured(qubit) { print("Gate applied after measurement. Not currently implemented!") }
        gates.append(Gate.t(qubit))
    }

    func tdg(_ qubit: Int) {
        if isQubitMeasured(qubit) { print("Gate applied after measurement. Not currently implemented!") }
        gates.append(Gate.tdg(qubit))
    }

    func sqrt_x(_ qubit: Int) {
        if isQubitMeasured(qubit) { print("Gate applied after measurement. Not currently implemented!") }
        gates.append(Gate.sqrt_x(qubit))
    }
    
    func sqrt_x_dg(_ qubit: Int) {
        if isQubitMeasured(qubit) { print("Gate applied after measurement. Not currently implemented!") }
        gates.append(Gate.sqrt_x_dg(qubit))
    }

    func p(_ theta: Double, _ qubit: Int) {
        if isQubitMeasured(qubit) { print("Gate applied after measurement. Not currently implemented!") }
        gates.append(Gate.p(theta, qubit))
    }

    func rx(_ theta: Double, _ qubit: Int) {
        if isQubitMeasured(qubit) { print("Gate applied after measurement. Not currently implemented!") }
        gates.append(Gate.rx(theta, qubit))
    }

    func ry(_ theta: Double, _ qubit: Int) {
        if isQubitMeasured(qubit) { print("Gate applied after measurement. Not currently implemented!") }
        gates.append(Gate.ry(theta, qubit))
    }

    func rz(_ theta: Double, _ qubit: Int) {
        if isQubitMeasured(qubit) { print("Gate applied after measurement. Not currently implemented!") }
        gates.append(Gate.rz(theta, qubit))
    }

    func u(_ theta: Double, _ phi: Double, _ lam: Double, _ qubit: Int) {
        if isQubitMeasured(qubit) { print("Gate applied after measurement. Not currently implemented!") }
        gates.append(Gate.u(theta, phi, lam, qubit))
    }

    //
    // Two qubit gates
    //

    func cnot(_ control: Int, _ target: Int) {
        if isQubitMeasured(control) || isQubitMeasured(target) { print("Gate applied after measurement. Not currently implemented!") }
        gates.append(Gate.cnot(control, target))
    }

    func cx(_ control: Int, _ target: Int) {
        if isQubitMeasured(control) || isQubitMeasured(target) { print("Gate applied after measurement. Not currently implemented!") }
        gates.append(Gate.cx(control, target))
    }

    func swap(_ control: Int, _ target: Int) {
        if isQubitMeasured(control) || isQubitMeasured(target) { print("Gate applied after measurement. Not currently implemented!") }
        gates.append(Gate.swap(control, target))
    }

    func cz(_ control: Int, _ target: Int) {
        if isQubitMeasured(control) || isQubitMeasured(target) { print("Gate applied after measurement. Not currently implemented!") }
        gates.append(Gate.cz(control, target))
    }

    //
    // Three qubit gates
    //

    func toffoli(_ control1: Int, _ control2: Int, _ target: Int) {
        if isQubitMeasured(control1) || isQubitMeasured(control2) || isQubitMeasured(target) { print("Gate applied after measurement. Not currently implemented!") }
        gates.append(Gate.toffoli(control1, control2, target))
    }

    func ccx(_ control1: Int, _ control2: Int, _ target: Int) {
        if isQubitMeasured(control1) || isQubitMeasured(control2) || isQubitMeasured(target) { print("Gate applied after measurement. Not currently implemented!") }
        gates.append(Gate.ccx(control1, control2, target))
    }

}
