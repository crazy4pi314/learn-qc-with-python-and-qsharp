// operations.qs: Sample code for Grover's search (Chapter 11).
//
// Copyright (c) Sarah Kaiser and Chris Granade.
// Code sample from the book "Learn Quantum Computing with Python and Q#" by
// Sarah Kaiser and Chris Granade, published by Manning Publications Co.
// Book ISBN 9781617296130.
// Code licensed under the MIT License.
//

namespace GroverSearch {
    open Microsoft.Quantum.Arithmetic;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;

    operation PrepareAllOnes(register : Qubit[]) : Unit is Adj + Ctl {
        ApplyToEachCA(X, register);
    }

    operation ReflectAboutAllOnes(register : Qubit[]) : Unit is Adj + Ctl {
        Controlled Z(Most(register),
            Tail(register));
    }

    operation PrepareInitialState(register : Qubit[]) : Unit is Adj + Ctl {
        ApplyToEachCA(H, register);
    }

    operation ReflectAboutInitialState(
        prepareInitialState : (Qubit[] => Unit is Adj),
        register : Qubit[])
    : Unit {
        within {
            Adjoint prepareInitialState(register);
            PrepareAllOnes(register);
        } apply {
            ReflectAboutAllOnes(register);
        }
    }

    operation ReflectAboutMarkedState(
        markedItemOracle :
            ((Qubit[], Qubit) => Unit is Adj),
        inputQubits : Qubit[])
    : Unit is Adj {
        use flag = Qubit();
        within {
            X(flag);
            H(flag);
        } apply{
            markedItemOracle(inputQubits,
                flag);
        }
    }

    function NIterations(nQubits : Int) : Int {
        let nItems = 1 <<< nQubits;
        let angle = ArcSin(1. /
            Sqrt(IntAsDouble(nItems)));
        let nIterations =
            Round(0.25 * PI() / angle - 0.5);
        return nIterations;
    }

    operation ApplyOracle(
        idxMarkedItem : Int,
        register : Qubit[],
        flag : Qubit
    ) : Unit is Adj + Ctl {
        (ControlledOnInt(idxMarkedItem, X))
            (register, flag);
    }

    operation SearchForMarkedItem(
        nItems : Int,
        markItem : ((Qubit[], Qubit) => Unit is Adj)
    ) : Int {
        use qubits = Qubit[BitSizeI(nItems)];
        PrepareInitialState(qubits);

        for idxIteration in
                0..NIterations(BitSizeI(nItems)) - 1 {
            ReflectAboutMarkedState(markItem, qubits);
            ReflectAboutInitialState(PrepareInitialState, qubits);
        }

        return MeasureInteger(LittleEndian(qubits));
    }

    operation RunGroverSearch(nItems : Int, idxMarkedItem : Int) : Unit {
        let markItem = ApplyOracle(
            idxMarkedItem, _, _);
        let foundItem = SearchForMarkedItem(
                nItems, markItem);
        Message(
            $"Marked {idxMarkedItem} and found {foundItem}.");
    }
}
