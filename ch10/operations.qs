// operations.qs: Sample code for Grover's search (Chapter 10).
//
// Copyright (c) Sarah Kaiser and Chris Granade.
// Code sample from the book "Learn Quantum Computing with Python and Q#" by
// Sarah Kaiser and Chris Granade, published by Manning Publications Co.
// Book ISBN 9781617296130.
// Code licensed under the MIT License.
//

// tag::open_stmts[]
namespace GroverSearch { 
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Arithmetic;

    open Microsoft.Quantum.Preparation;                              
    open Microsoft.Quantum.Math;
    // end::open_stmts[]

    // tag::prepare_all_ones[]
    operation PrepareAllOnes(register : Qubit[]) : Unit is Adj + Ctl {
        ApplyToEachCA(X, register);                                     // <1>
    }
    // end::prepare_all_ones[]

    // tag::reflect_about_all_ones[]
    operation ReflectAboutAllOnes(register : Qubit[]) : Unit is Adj + Ctl {
        Controlled Z(Most(register), Tail(register));                   // <1>
    }
    // end::reflect_about_all_ones[]

    // tag::initial_state_reflect[]
    operation PrepareInitialState(register : Qubit[]) : Unit is Adj + Ctl {
        ApplyToEachCA(H, register);                                     // <1>
    }

    operation ReflectAboutInitialState(
        prepareInitialState : (Qubit[] => Unit is Adj),                 // <2>
        register : Qubit[]                                              // <3>
    )
    : Unit {
        within {                                                        // <4>
            Adjoint prepareInitialState(register);                      // <5>
            PrepareAllOnes(register);                                   
        } apply {
            ReflectAboutAllOnes(register);                              // <7>
        }
    }
    // end::initial_state_reflect[]

    // tag::marked_reflection[]
    operation ReflectAboutMarkedState(
        markedItemOracle : ((Qubit[], Qubit) => Unit is Adj),           // <1>
        inputQubits : Qubit[])                                          // <2>
    : Unit is Adj {
        using (flag = Qubit()) {                                        // <3>
            within {
                X(flag);                                                // <4>
                H(flag);
            } apply{
                markedItemOracle(inputQubits, flag);                    // <5>                                        
            }
        }
    }
    // end::marked_reflection[]

    // tag::niterations[]
    function NIterations(nQubits : Int) : Int {
        let nItems = 1 <<< nQubits;                                     // <1>
        let angle = ArcSin(1. / Sqrt(IntAsDouble(nItems)));             // <2>
        let nIterations = Round(0.25 * PI() / angle - 0.5);             // <3>
        return nIterations;
    }
    //end::niterations[]

    //tag::apply_oracle[]
    operation ApplyOracle(
        idxMarkedItem : Int,                                            // <1>
        register : Qubit[],                                             
        flag : Qubit)                                                   
    : Unit is Adj + Ctl {
        (ControlledOnInt(idxMarkedItem, X))(register, flag);            // <2>
    }
    //end::apply_oracle[]

    // tag::grover_search[]
    operation SearchForMarkedItem(                                      // <1>
        nItems : Int,                                                   // <2>
        markItem : ((Qubit[], Qubit) => Unit is Adj)                    // <3>
    )
    : Int {                                                             // <4>
        using (qubits = Qubit[BitSizeI(nItems)]) {                      // <5>
            PrepareInitialState(qubits);                                // <6>

            for (idxIteration in 0..NIterations(BitSizeI(nItems)) - 1) {// <7>
                ReflectAboutMarkedState(markItem, qubits);
                ReflectAboutInitialState(PrepareInitialState, qubits);
            }

            return MeasureInteger(LittleEndian(qubits));                // <8>
        }
    }
    // end::grover_search[]

    //tag::grover_sample[]
    operation RunGroverSearch(nItems : Int, idxMarkedItem : Int) : Unit {
        let markItem = ApplyOracle(idxMarkedItem, _, _);                // <1>
        let foundItem = SearchForMarkedItem(nItems, markItem);          // <2>
        Message($"Marked {idxMarkedItem} and found {foundItem}.");      // <3>
    }
    //end::grover_sample[]
}
