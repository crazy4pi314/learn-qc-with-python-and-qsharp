// IntegerFactorization.qs: Sample code for integer factorization example (Chapter 11).
//
// Copyright (c) Sarah Kaiser and Chris Granade.
// Code sample from the book "Learn Quantum Computing with Python and Q#" by
// Sarah Kaiser and Chris Granade, published by Manning Publications Co.
// Book ISBN 9781617296130.
// Code licensed under the MIT License.
//
// Adapted from the QDK samples repo here:
// https://github.com/microsoft/Quantum/tree/master/samples/

// tag::open_stmts[]
namespace IntegerFactorization {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Arithmetic;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Oracles;
    open Microsoft.Quantum.Characterization;
    open Microsoft.Quantum.Diagnostics;
    // end::open_stmts[]

    // tag::factor_semiprime[]
    operation FactorSemiprimeInteger(number : Int) 
    : (Int, Int) {
        if (number % 2 == 0) {                                                // <1>
            Message("An even number has been given; 2 is a factor.");
            return (number / 2, 2);
        }
        mutable factors = (1, 1);                                             // <2>
        mutable foundFactors = false;                                         // <3>

        repeat {
            let generator = RandomInt(number - 2) + 1;                        // <4>

            if (IsCoprimeI(generator, number)) {                              // <5>
                Message($"Estimating period of {generator}...");
                let period = EstimatePeriod(generator, number);               // <6>
                set (foundFactors, factors) = MaybeFactorsFromPeriod(         // <7>
                    generator, period, number
                );
            } else {
                let gcd = GreatestCommonDivisorI(number, generator);          // <8>
                Message(
                    $"We have guessed a divisor of {number} to be " +
                    $"{gcd} by accident. Nothing left to do."
                );
                set foundFactors = true;
                set factors = (gcd, number / gcd);
            }
        } until (foundFactors)                                                // <9>
        fixup {                                                               // <10>
            Message(
                "The estimated period did not yield a valid factor, " +
                "trying again."
            );
        }
        return factors;                                                       // <11>
    }
    // end::factor_semiprime[]

    // tag::maybe_factors[]
    function MaybeFactorsFromPeriod(
        generator : Int, period : Int, number : Int                           // <1>
    )
    : (Bool, (Int, Int)) {                                                    // <2>
        if (period % 2 == 0) {                                                // <3>

            let halfPower = ExpModI(generator, period / 2, number);           // <4>

            if (halfPower != number - 1) {                                    // <5>
                let factor = MaxI(                                            // <6>
                    GreatestCommonDivisorI(halfPower - 1, number),
                    GreatestCommonDivisorI(halfPower + 1, number)
                );
                return (true, (factor, number / factor));
            } else {
                return (false, (1, 1));
            }
        } else {
            return (false, (1, 1));
        }
    }
    // end::maybe_factors[]

    // tag::estimate_period[]
    operation EstimatePeriod(generator : Int, modulus : Int) 
    : Int {
        Fact(                                                                 // <1>
            IsCoprimeI(generator, modulus),                                   // <2>
            "`generator` and `modulus` must be co-prime"
        );

        let bitSize = BitSizeI(modulus);                                      // <3>
        let nBitsPrecision = 2 * bitSize + 1;                                 // <4>
        mutable result = 1;                                                   // <5>
        mutable frequencyEstimate = 0;

        repeat {                                                              // <6>
            set frequencyEstimate = EstimateFrequency(                        // <7>
                ApplyPeriodFindingOracle(generator, modulus, _, _),           // <8>
                nBitsPrecision, bitSize
            );

            if (frequencyEstimate != 0) {                                     // <9>
                set result = PeriodFromFrequency(                             // <10>
                    frequencyEstimate, nBitsPrecision,
                    modulus, result
                );
            } else {
                Message("The estimated frequency was 0, trying again.");
            }
        } until(ExpModI(generator, result, modulus) == 1)                     // <11>
        fixup {
            Message(                                                          // <12>
                "The estimated period from continued fractions failed, " +
                "trying again."
            );
        }
        return result;
    }
    // end::estimate_period[]

    // tag::est_freq[]
    operation EstimateFrequency(
        inputOracle : ((Int, Qubit[]) => Unit is Adj+Ctl),
        nBitsPrecision : Int,
        bitSize : Int
    )
    : Int {
        using (register = Qubit[bitSize]) {                         // <1>

            let registerLE = LittleEndian(register);      // <2>
            ApplyXorInPlace(1, registerLE);                         // <3>

            let phase = RobustPhaseEstimation(                                // <4>
                nBitsPrecision,
                DiscreteOracle(inputOracle),                                  // <5>
                registerLE!
            );
            ResetAll(register);                                     // <6>

            return Round(                                                     // <7>
                ((phase * IntAsDouble(2 ^ nBitsPrecision)) / 2.0) / PI()
            );
        }
    }
    // end::est_freq[]

    // tag::period_from_freq[]
    function PeriodFromFrequency(
        frequencyEstimate : Int, nBitsPrecision : Int,
        modulus : Int, result : Int
    )
    : Int {
        let continuedFraction = ContinuedFractionConvergentI(
            Fraction(frequencyEstimate, 2^nBitsPrecision), modulus
        );
        let denominator = AbsI(Snd(continuedFraction!));
        return (denominator * result) / GreatestCommonDivisorI(
            result, denominator
        );
    }
    // end::period_from_freq[]

    // tag::oracle[]
    internal operation ApplyPeriodFindingOracle(
        generator : Int, modulus : Int, power : Int, target : Qubit[]
    )
    : Unit is Adj + Ctl {
        Fact(                                                                 // <1>
            IsCoprimeI(generator, modulus),
            "The generator and modulus must be co-prime."
        );
        MultiplyByModularInteger(                                             // <2>
            ExpModI(generator, power, modulus),                               // <3>
            modulus,
            LittleEndian(target)                                              // <4>
        );
    }
    // end::oracle[]
}
