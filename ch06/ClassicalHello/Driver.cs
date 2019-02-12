using System;                                              // <1>

using Microsoft.Quantum.Simulation.Core;                   // <2>
using Microsoft.Quantum.Simulation.Simulators;

namespace ClassicalHello
{
    class Driver
    {
        static void Main(string[] args)                    // <3>
        {
            using (var qsim = new QuantumSimulator())      // <4>
            {
                HelloWorld.Run(qsim).Wait();               // <5>
            }
        }
    }
}