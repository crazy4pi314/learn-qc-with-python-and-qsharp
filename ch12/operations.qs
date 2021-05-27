// IntegerFactorization.qs: Sample code for integer factorization example (Chapter 12).
//
// Copyright (c) Sarah Kaiser and Chris Granade.
// Code sample from the book "Learn Quantum Computing with Python and Q#" by
// Sarah Kaiser and Chris Granade, published by Manning Publications Co.
// Book ISBN 9781617296130.
// Code licensed under the MIT License.
//
// Adapted from the QDK samples repo here:
// https://github.com/microsoft/Quantum/tree/master/samples/

namespace IntegerFactorization {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Oracles;
    open Microsoft.Quantum.Characterization;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Random;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Arithmetic;

    operation FactorSemiprimeInteger(number : Int) : (Int, Int) {
        if number % 2 == 0 {
            Message("An even number has been given; 2 is a factor.");
            return (number / 2, 2);
        }
        mutable factors = (1, 1);
        mutable foundFactors = false;

        repeat {
            let generator = DrawRandomInt(
                    3, number - 2);

            if IsCoprimeI(generator, number) {
                Message($"Estimating period of {generator}...");
                let period = EstimatePeriod(
                    generator, number);
                set (foundFactors, factors) =
                    MaybeFactorsFromPeriod(
                        generator, period, number
                    );
            } else {
                let gcd = GreatestCommonDivisorI(
                    number, generator);
                Message(
                    $"We have guessed a divisor of {number} to be " +
                    $"{gcd} by accident. Nothing left to do."
                );
                set foundFactors = true;
                set factors = (gcd, number / gcd);
            }
        }
        until foundFactors
        fixup {                                  
            Message(
                "The estimated period did not yield a valid factor, " +
                "trying again."
            );
        }
        return factors;                          
    }

    function MaybeFactorsFromPeriod(
        generator : Int, period : Int, number : Int)
    : (Bool, (Int, Int)) {
        if period % 2 == 0 {

            let halfPower = ExpModI(generator,
                period / 2, number);

            if (halfPower != number - 1) {
                let factor = MaxI(
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

    operation EstimatePeriod(generator : Int, modulus : Int) : Int {
        Fact(
            IsCoprimeI(generator, modulus),
            "`generator` and `modulus` must be co-prime"
        );

        let bitSize = BitSizeI(modulus);
        let nBitsPrecision = 2 * bitSize + 1;
        mutable result = 1;
        mutable frequencyEstimate = 0;

        repeat {
            set frequencyEstimate =
                EstimateFrequency(
                    ApplyPeriodFindingOracle(
                        generator, modulus, _, _
                    ),
                    nBitsPrecision, bitSize
                );

            if frequencyEstimate != 0 {
                set result =
                    PeriodFromFrequency(         
                        frequencyEstimate, nBitsPrecision,
                        modulus, result
                    );
            } else {
                Message("The estimated frequency was 0, trying again.");
            }
        }
        until ExpModI(generator, result, modulus) == 1 
        fixup {
            Message(                            
                "The estimated period from continued fractions failed, " +
                "trying again."
            );
        }
        return result;
    }

    operation EstimateFrequency(
        inputOracle : ((Int, Qubit[]) => Unit is Adj+Ctl),
        nBitsPrecision : Int,
        bitSize : Int)
    : Int {
        use register = Qubit[bitSize];

        let registerLE = LittleEndian(register);
        ApplyXorInPlace(1, registerLE);

        let phase = RobustPhaseEstimation(
            nBitsPrecision,
            DiscreteOracle(inputOracle),
            registerLE!
        );
        ResetAll(register);

        return Round(
            (phase * IntAsDouble(2 ^ nBitsPrecision)) / (2.0 * PI())
        );
    }

    function PeriodFromFrequency(
        frequencyEstimate : Int, nBitsPrecision : Int,
        modulus : Int, result : Int)
    : Int {
        let continuedFraction = ContinuedFractionConvergentI(
            Fraction(frequencyEstimate, 2^nBitsPrecision), modulus
        );
        let denominator = AbsI(Snd(continuedFraction!));
        return (denominator * result) / GreatestCommonDivisorI(
            result, denominator
        );
    }

    operation ApplyPeriodFindingOracle(
        generator : Int, modulus : Int, power : Int, target : Qubit[])
    : Unit is Adj + Ctl {
        Fact(
            IsCoprimeI(generator, modulus),
            "The generator and modulus must be co-prime."
        );
        MultiplyByModularInteger(
            ExpModI(generator, power, modulus),
            modulus,
            LittleEndian(target)
        );
    }
}
