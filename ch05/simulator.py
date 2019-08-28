from interface import QuantumDevice, Qubit
import qutip as qt
import numpy as np
from typing import List

KET_0 = qt.basis(2, 0)
H = qt.hadamard_transform()

# tag::qubit_and_sq_operations[]

class SimulatedQubit(Qubit):
    qubit_id : int
    parent : "Simulator"

    def __init__(self, parent_simulator : "Simulator", id : int):
        self.qubit_id = id
        self.parent = parent_simulator
        self.reset()

    def h(self) -> None:
        self.parent._apply(H, self.qubit_id)

    def rx(self, theta : float) -> None:
        self.parent._apply(qt.rx(theta), self.qubit_id)

    def ry(self, theta : float) -> None:
        self.parent._apply(qt.ry(theta), self.qubit_id)

    def rz(self, theta : float) -> None:
        self.parent._apply(qt.rz(theta), self.qubit_id)

    def x(self) -> None:
        self.parent._apply(qt.sigmax(), self.qubit_id)

    def y(self) -> None:
        self.parent._apply(qt.sigmay(), self.qubit_id)

    def z(self) -> None:
        self.parent._apply(qt.sigmaz(), self.qubit_id)

# end::qubit_and_sq_operations[]

    def measure(self) -> bool:
        # TODO            
        pr0 = np.abs(self.state[0, 0]) ** 2
        sample = np.random.random() <= pr0
        return bool(0 if sample else 1)

    def reset(self) -> None:
        if self.measure(): self.x()

    def cnot(self, target : Qubit):      # <1>
        self.parent._apply(
            qt.cnot(2, 0, 1),
            self.qubit_id,
            target.qubit_id
        )

# tag::simulator_setup[]
class Simulator(QuantumDevice):                   # <1>
    capacity : int                                # <2>
    available_qubits : List[SimulatedQubit]           # <3>
    register_state : qt.Qobj                      # <4>

    def __init__(self, capacity=3):
        self.capacity = capacity
        self.available_qubits = list(             # <5>
            map(SimulatedQubit, range(capacity))
        )
        self.register_state = qt.tensor(          # <6>
            *[
                qt.basis(2, 0)
                for _ in range(capacity)
            ]
        )

    def allocate_qubit(self) -> SimulatedQubit:   # <7>
        if self.available_qubits:
            return self.available_qubits.pop()

    def deallocate_qubit(self, qubit : SimulatedQubit):
        self.available_qubits.append(qubit)

# end::simulator_setup[]

# tag::apply_method[]

    # Private method to allow qubits to send gates back
    # to the simulator.
    def _apply(self, operation : qt.Qobj, ids : List[int]):  # <1>
        if len(ids) == 1:                                 # <2>
            matrix = qt.circuit.gate_expand_1toN(operation, self.capacity, ids[0])
        else:
            raise ValueError("Only one qubit operations supported.")
        
        self.register_state = matrix * self.register_state # <3>


# end::apply_method[]
