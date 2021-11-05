

class QuantumCircuit {

    var gates: [Gate] = []
    var N: Int = 0
    var initialState: State = State()

    init(_ N: Int) {
        self.N = N
        self.initialState = State(N)
    }

    func run() -> State {
        var finalState = initialState
        for gate in gates {
            finalState = gate.apply(finalState)
        }
        return finalState
    }

    func x(_ qubit: Int) {
        gates.append(Gate.x(qubit))
    }

    func h(_ qubit: Int) {
        gates.append(Gate.h(qubit))
    }

    func cnot(_ control: Int, _ target: Int) {
        gates.append(Gate.cnot(control, target))
    }

}