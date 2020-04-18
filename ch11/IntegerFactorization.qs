// operations.qs: Sample code for integer factorization example (Chapter 11).
//
// Copyright (c) Sarah Kaiser and Chris Granade.
// Code sample from the book "Learn Quantum Computing with Python and Q#" by
// Sarah Kaiser and Chris Granade, published by Manning Publications Co.
// Book ISBN 9781617296130.
// Code licensed under the MIT License.
//
// Adapted from the QDK samples repo here: 
// https://github.com/microsoft/Quantum/tree/master/samples/simulation

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


    operation ApplyOrderFindingOracle( generator : Int, modulus : Int, power : Int, target : Qubit[]): Unit is Adj + Ctl {
        Fact(IsCoprimeI(generator, modulus), "`generator` and `modulus` must be co-prime");
        // Implements |x⟩ ↦ |x⋅a mod N ⟩.
        MultiplyByModularInteger(ExpModI(generator, power, modulus), modulus, LittleEndian(target));
    }

    operation EstimateFrequency( inputOracle : ((Int, Qubit[]) => Unit is Adj+Ctl), bitsPrecision : Int, bitSize : Int) : Int {
        using (eigenstateRegister = Qubit[bitSize]) {

            let eigenstateRegisterLE = LittleEndian(eigenstateRegister);
            ApplyXorInPlace(1, eigenstateRegisterLE);

            let oracle = DiscreteOracle(inputOracle);
            let phase = RobustPhaseEstimation(bitsPrecision, oracle, eigenstateRegisterLE!);
            ResetAll(eigenstateRegister);
         
            return Round(((phase * IntAsDouble(2 ^ bitsPrecision)) / 2.0) / PI());
        }        
    }

    operation EstimatePeriod( generator : Int, modulus : Int) : Int {

        Fact(IsCoprimeI(generator, modulus), "`generator` and `modulus` must be co-prime");

        let bitSize = BitSizeI(modulus);
        let bitsPrecision = 2 * bitSize + 1;
        mutable result = 1;
        mutable frequencyEstimate = 0;
        
        repeat{
            set frequencyEstimate = EstimateFrequency(
                ApplyOrderFindingOracle(generator, modulus, _, _), bitsPrecision, bitSize);

            if (frequencyEstimate != 0) {
                set result = PeriodFromFrequency(frequencyEstimate, bitsPrecision, modulus, result);
            }
        } until(ExpModI(generator, result, modulus) == 1);
 
        return result;
    }

    function PeriodFromFrequency(
        frequencyEstimate : Int, 
        bitsPrecision : Int, 
        modulus : Int, 
        result : Int) : Int {
        let (numerator, period) = (ContinuedFractionConvergentI(Fraction(frequencyEstimate, 2 ^ bitsPrecision), modulus))!;
        let (numeratorAbs, periodAbs) = (AbsI(numerator), AbsI(period));
        return (periodAbs * result) / GreatestCommonDivisorI(result, periodAbs);
    }

    operation IsPeriodFactor(
        generator : Int, 
        period : Int, 
        number : Int) : (Bool, (Int, Int)) {
            if (period % 2 == 0) {

                let halfPower = ExpModI(generator, period / 2, number);

                if (halfPower != number - 1) {
                    let factor = MaxI(GreatestCommonDivisorI(halfPower - 1, number), GreatestCommonDivisorI(halfPower + 1, number));
                    return (true, (factor, number / factor));
                } else {
                    return (false, (1,1));
                }
            } else {
                return (false, (1,1));
            }
    }

    operation FindSemiPrimeFactors(number : Int) : (Int, Int) 
    {
        if (number % 2 == 0) {
            Message("An even number has been given; 2 is a factor.");
            return (number / 2, 2);
        }
        mutable factors = (1, 1);
        mutable areFactors = false;

        repeat {
            // Step 1
            let generator = RandomInt(number - 2) + 1;

            // Step 2
            if (IsCoprimeI(generator, number)) {

                Message($"Estimating period of {generator}");

                // Step 3
                let period = EstimatePeriod(generator, number);

                // Step 4
                set (areFactors, factors) = IsPeriodFactor(generator, period, number);

            }
            else {
                let gcd = GreatestCommonDivisorI(number, generator);
                Message($"We have guessed a divisor of {number} to be {gcd} by accident.");
                set areFactors = true;
                set factors = (gcd, number / gcd);
            }
        } until (areFactors);
        return factors;
    }
}