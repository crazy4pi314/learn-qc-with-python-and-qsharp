using System;

using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.Simulation.Simulators;

namespace DeutschJozsa
{
    class Driver
    {
        static void Main(string[] args)
        {
            using (var qsim = new QuantumSimulator())
            {
                RunDeutschJozsaAlgorithm.Run(qsim).Wait();
            }
        }
    }
}