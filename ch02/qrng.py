from interface import QuantumDevice
from simulator import SingleQubitSimulator

# tag::qrng[]
def qrng(device : QuantumDevice) -> bool:
    with device.using_qubit() as q:
        q.h()
        return q.measure()
# end::qrng[]

# tag::main[]
if __name__ == "__main__":
    qsim = SingleQubitSimulator()
    for idx_sample in range(10):
        random_sample = qrng(qsim)
        print(f"Our QRNG returned {random_sample}.")
# end::main[]
