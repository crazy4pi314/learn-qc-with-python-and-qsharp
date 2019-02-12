using System;

using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.Simulation.Simulators;

namespace Qrng
{
    class Driver
    {
        // tag::main[]
        static void Main(string[] args)
        {
            System.Console.WriteLine("Pick a win probability for Morgana: ");
            var winProbability = Double.Parse(System.Console.ReadLine());
            using (var qsim = new QuantumSimulator())
            {
                PlayMorganasGame.Run(qsim, winProbability).Wait();
            }
        }
        // end::main[]
    }
}