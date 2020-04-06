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
    open Microsoft.Quantum.Canon;                                             // <1>          
    open Microsoft.Quantum.Simulation;                                        // <2>
    open Microsoft.Quantum.Characterization;                                  // <3>
    // end::open_stmts[]

// Step 1
    operation RandomGuess(number : Int) : Int {
        return  RandomInt(number - 2) + 1;
    }

// Step 2
    function IsCoprime(guess : Int, number : Int) : Bool {
        //IsCoprimeI
    }

// Step 3
    operation FindFrequency(guess : Int, number : Int) : Int {

    }

// Step 4
    operation FrequencyToPeriod(guess : Int, number : Int) : Int {

    }

// Step 5 + 6
    operation IsPeriodFactor(guess : Int, number : Int) : Bool {

    }


    operation FindFactors(number : Int) : Int[]
    //is Adj + Ctl 
    {
        // need right logic to handle finding all the factors
    }
}  