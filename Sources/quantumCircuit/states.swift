

public class State {

    var state: Tensor = Tensor()
    var N: Int = 0

    init() {}

    init(_ N: Int) {
        self.N = N
        var stateVector = Array(repeating: 0.0, count: 2**N - 1)
        stateVector = [1.0] + stateVector
        state = Tensor( real: stateVector, 
                        imag: Array(repeating: 0.0, count: 2**N),
                        shape: Array(repeating: 2, count: N))
    }

    init(state: Tensor) {
        // Add checks!!!!!
        self.N = state.shape.count
        self.state = state
    }
}