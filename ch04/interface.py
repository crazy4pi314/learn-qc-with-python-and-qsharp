from abc import ABCMeta, abstractmethod
from contextlib import contextmanager

# tag::qubit_interface[]
class Qubit(metaclass=ABCMeta):
    @abstractmethod
    def h(self) -> None: pass         # <1>

    @abstractmethod                   # <2>
    def measure(self) -> bool: pass

    @abstractmethod
    def reset(self) -> None: pass     # <3>
# end::qubit_interface[]

# tag::device_interface[]
class QuantumDevice(metaclass=ABCMeta):
    @abstractmethod
    def allocate_qubit(self) -> Qubit:
        pass

    @abstractmethod
    def deallocate_qubit(self, qubit : Qubit):
        pass

    @contextmanager
    def using_qubit(self):
        qubit = self.allocate_qubit()
        try:
            yield qubit
        finally:
            qubit.reset()
            self.deallocate_qubit(qubit)
# end::device_interface[]
