from abc import ABCMeta, abstractmethod
from contextlib import contextmanager

# tag::qubit_interface[]
class Qubit(metaclass=ABCMeta):
    @abstractmethod
    def h(self): pass

    @abstractmethod
    def x(self): pass                 # <1>

    @abstractmethod
    def measure(self) -> bool: pass

    @abstractmethod
    def reset(self): pass
# end::qubit_interface[]

# tag::device_interface[]
class QuantumDevice(metaclass=ABCMeta):
    @abstractmethod
    def allocate_qubit(self) -> Qubit:           # <1>
        pass

    @abstractmethod
    def deallocate_qubit(self, qubit : Qubit):   # <2>
        pass

    @contextmanager
    def using_qubit(self):                       # <3>
        qubit = self.allocate_qubit()
        try:
            yield qubit
        finally:
            qubit.reset()                        # <4>
            self.deallocate_qubit(qubit)
# end::device_interface[]
