from dotenv import dotenv_values
from qiskit_ibm_provider import IBMProvider

env = dotenv_values(".env")
ibm_quantum_token = env["IBM_QUANTUM_TOKEN"]
provider = IBMProvider(token=ibm_quantum_token)
backends = provider.backends()

simulators = []
real_quantum_pcs = []
for backend in backends:
    if (backend.simulator):
        simulators.append(backend)
    else:
        real_quantum_pcs.append(backend)

print("Simulated qunatum computers:")
for simulator in simulators:
    sim_status = simulator.status()
    print(f"\t{simulator.name:30s} has {sim_status.pending_jobs} queues")
print()
print("Real quantum computers:")
for real_quantum_pc in real_quantum_pcs:
    real_pc_status = real_quantum_pc.status()
    print(f"\t{real_quantum_pc.name:30s} has "
          f"{real_pc_status.pending_jobs} queues with "
          f"{real_quantum_pc.num_qubits} qubits")
