using System;

using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.Simulation.Simulators;

namespace Qrng                                                  // <1>
{
    class Driver
    {
        static void Main(string[] args)
        {
            using (var qsim = new QuantumSimulator())
            {
                PlayMorganasGame.Run(qsim).Wait();              // <2>
            }
        }
    }
}