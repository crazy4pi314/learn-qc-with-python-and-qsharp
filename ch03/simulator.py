from interface import QuantumDevice, Qubit
import numpy as np

# tag::constants[]
KET_0 = np.array([ 
    [1],
    [0]
], dtype=complex)
H = np.array([
    [1, 1],
    [1, -1]
], dtype=complex) / np.sqrt(2)                  
X = np.array([                                  # <1>
    [0, 1],
    [1, 0]
], dtype=complex) / np.sqrt(2) 
# end::constants[]

# tag::qubit[]
class SimulatedQubit(Qubit):
    def __init__(self):                         
        self.reset()

    def h(self):
        self.state = H @ self.state
    
    def x(self):                                # <2>                                
        self.state = X @ self.state

    def measure(self) -> bool:                  
        pr0 = np.abs(self.state[0, 0]) ** 2 
        sample = np.random.random() <= pr0  
        return bool(0 if sample else 1)     

    def reset(self):
        self.state = KET_0.copy()
# end::qubit[]

class SingleQubitSimulator(QuantumDevice):
    available_qubits = [SimulatedQubit()]

    def allocate_qubit(self) -> SimulatedQubit:
        if self.available_qubits:
            return self.available_qubits.pop()

    def deallocate_qubit(self, qubit : SimulatedQubit):
        self.available_qubits.append(qubit)
    