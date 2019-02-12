from interface import QuantumDevice, Qubit
import qutip as qt
import numpy as np

# tag::qubit[]
KET_0 = qt.basis(2, 0)                          # <1>
H = qt.hadamard_transform()

class SimulatedQubit(Qubit):
    def __init__(self):                         # <2>
        self.reset()

    def rz(self, theta : float) -> None:
        self.state = qt.rz(theta) * self.state  # <3>

    def h(self) -> None:                        # <4>
        self.state = H * self.state

    def measure(self) -> bool:                  
        pr0 = np.abs(self.state[0, 0]) ** 2
        sample = np.random.random() <= pr0
        return bool(0 if sample else 1)

    def reset(self) -> None:
        self.state = KET_0.copy()
# end::qubit[]

    def rx(self, theta : float) -> None:
        self.state = qt.rx(theta) * self.state

    def ry(self, theta : float) -> None:
        self.state = qt.ry(theta) * self.state

# tag::pauli_instructions[]

    def x(self) -> None:
        self.state = qt.sigmax() * self.state    # <1>

    def y(self) -> None:
        self.state = qt.sigmay() * self.state

    def z(self) -> None:
        self.state = qt.sigmaz() * self.state

# end::pauli_instructions[]

class SingleQubitSimulator(QuantumDevice):
    available_qubits = [SimulatedQubit()]

    def allocate_qubit(self) -> SimulatedQubit:
        if self.available_qubits:
            return self.available_qubits.pop()

    def deallocate_qubit(self, qubit : SimulatedQubit):
        self.available_qubits.append(qubit)
