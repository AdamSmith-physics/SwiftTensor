import Foundation

public class QuantumState: Codable {

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
    
    static func == (lhs: QuantumState, rhs: QuantumState) -> Bool {
        return
            lhs.state == rhs.state &&
            lhs.N == rhs.N
    }
    
    func probabilities() -> [Double] {
        return (state .* state.conj).real
    }
    
    func phases() -> [Double] {
        var returnVals: [Double] = []
        for ii in 0..<state.real.count {
            let tempPhase = atan2(state.imag[ii], state.real[ii])
            returnVals.append(tempPhase >= 0 ? tempPhase : (tempPhase + 2*pi))  // phase in [0,2pi)
        }
        return returnVals
    }
    
    func phases_2pi() -> [Double] {
        var returnVals: [Double] = []
        for ii in 0..<state.real.count {
            let tempPhase = atan2(state.imag[ii], state.real[ii]) / (2*pi)
            returnVals.append(tempPhase >= 0 ? tempPhase : (tempPhase + 1))  // phase in [0,1)
        }
        return returnVals
    }
    
    func measure(shots: Int, qubits: [Int]) -> [String : Int] {
        // speed improvement needed!

        var probabilities: [Double] = self.probabilities()
        probabilities = cumsum(probabilities)  // add line to ensure probabilities add to 1
        
        let x: [Int] = Array(0..<probabilities.count)
        
        var tempMeasurementDict: [Int: Int] = [:]
        var measurementDict: [String : Int] = [:]
        var measuredStateList: [Int] = []
        
        let syncQueue = DispatchQueue(label: "...") // needed when accessing a variable from many threads

        // Parellization not worth it! Do differently.
        //DispatchQueue.concurrentPerform(iterations: shots) { kk in
        for _ in 0..<shots {
            let r_val = Double.random(in: 0..<1)
            
            /*var whichState: Int = probabilities.count-1
            //var accum = 0.0
            for (i, p) in probabilities.enumerated() {
                //accum += p
                if r_val < p {
                    whichState = i 
                    break
                }
            }*/
            let whichState: Int = probabilities.firstIndex(where: {$0 > r_val}) ?? probabilities.count-1
            

            if tempMeasurementDict[whichState] != nil {
                tempMeasurementDict[whichState]! += 1
            } else {
                tempMeasurementDict[whichState] = 1
            }

            //let y = x.map{ (probabilities[$0]<r_val ? 1 : 0) }
            //let whichState: Int = y.reduce(0, +) //ones.reduce(0){ $0 + (probabilities[$1]<r_val ? $1 : 0 ) }
            //measuredStateList = measuredStateList + [whichState]  //need to convert to strings!
            
            /*
            var stateString = num2bin(num: whichState, toSize: self.N)
            stateString = qubits.compactMap{ stateString[$0] }.joined()

            //syncQueue.sync {
            if measurementDict[stateString] != nil {
                measurementDict[stateString]! += 1
            } else {
                measurementDict[stateString] = 1
            }
            */
            //}

        }


        // convert to strings after first using int. Should be quicker?
        for (whichState, count) in tempMeasurementDict {
            var stateString = num2bin(num: whichState, toSize: self.N)
            stateString = qubits.compactMap{ stateString[$0] }.joined()
            
            if measurementDict[stateString] != nil {
                measurementDict[stateString]! += count
            } else {
                measurementDict[stateString] = count
            }
        }
        
        
        
        /*for whichState in measuredStateList {
            var stateString = num2bin(num: whichState, toSize: self.N)
            stateString = qubits.compactMap{ stateString[$0] }.joined()
            if measurementDict[stateString] != nil {
                measurementDict[stateString]! += 1
            } else {
                measurementDict[stateString] = 1
            }
        }*/
        
        return measurementDict
    }
    
}
