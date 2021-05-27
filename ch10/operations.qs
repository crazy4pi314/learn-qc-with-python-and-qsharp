// operations.qs: Sample code for Hamiltonian simulation (Chapter 10).
//
// Copyright (c) Sarah Kaiser and Chris Granade.
// Code sample from the book "Learn Quantum Computing with Python and Q#" by
// Sarah Kaiser and Chris Granade, published by Manning Publications Co.
// Book ISBN 9781617296130.
// Code licensed under the MIT License.
//
// Adapted from the QDK samples repo here:
// https://github.com/microsoft/Quantum/tree/master/samples/simulation


namespace HamiltonianSimulation {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Simulation;
    open Microsoft.Quantum.Characterization;


    function H2BondLengths() : Double[] {
        return [0.2, 0.25, 0.3, 0.35, 0.4, 0.45, 0.5,
        0.55, 0.6, 0.65, 0.7, 0.75, 0.8, 0.85, 0.9, 0.95, 1.0,
        1.05, 1.1, 1.15, 1.2, 1.25, 1.3, 1.35, 1.4, 1.45, 1.5,
        1.55, 1.6, 1.65, 1.7, 1.75, 1.8, 1.85, 1.9, 1.95, 2.0,
        2.05, 2.1, 2.15, 2.2, 2.25, 2.3, 2.35, 2.4, 2.45, 2.5,
        2.55, 2.6, 2.65, 2.7, 2.75, 2.8, 2.85];
    }

    function H2Coeff(idxBondLength : Int) : Double[] {
        return [
            [0.5678, -1.4508, 0.6799, 0.0791, 0.0791],
            [0.5449, -1.287, 0.6719, 0.0798, 0.0798],
            [0.5215, -1.1458, 0.6631, 0.0806, 0.0806],
            [0.4982, -1.0226, 0.6537, 0.0815, 0.0815],
            [0.4754, -0.9145, 0.6438, 0.0825, 0.0825],
            [0.4534, -0.8194, 0.6336, 0.0835, 0.0835],
            [0.4325, -0.7355, 0.6233, 0.0846, 0.0846],
            [0.4125, -0.6612, 0.6129, 0.0858, 0.0858],
            [0.3937, -0.595, 0.6025, 0.087, 0.087],
            [0.376, -0.5358, 0.5921, 0.0883, 0.0883],
            [0.3593, -0.4826, 0.5818, 0.0896, 0.0896],
            [0.3435, -0.4347, 0.5716, 0.091, 0.091],
            [0.3288, -0.3915, 0.5616, 0.0925, 0.0925],
            [0.3149, -0.3523, 0.5518, 0.0939, 0.0939],
            [0.3018, -0.3168, 0.5421, 0.0954, 0.0954],
            [0.2895, -0.2845, 0.5327, 0.097, 0.097],
            [0.2779, -0.255, 0.5235, 0.0986, 0.0986],
            [0.2669, -0.2282, 0.5146, 0.1002, 0.1002],
            [0.2565, -0.2036, 0.5059, 0.1018, 0.1018],
            [0.2467, -0.181, 0.4974, 0.1034, 0.1034],
            [0.2374, -0.1603, 0.4892, 0.105, 0.105],
            [0.2286, -0.1413, 0.4812, 0.1067, 0.1067],
            [0.2203, -0.1238, 0.4735, 0.1083, 0.1083],
            [0.2123, -0.1077, 0.466, 0.11, 0.11],
            [0.2048, -0.0929, 0.4588, 0.1116, 0.1116],
            [0.1976, -0.0792, 0.4518, 0.1133, 0.1133],
            [0.1908, -0.0666, 0.4451, 0.1149, 0.1149],
            [0.1843, -0.0549, 0.4386, 0.1165, 0.1165],
            [0.1782, -0.0442, 0.4323, 0.1181, 0.1181],
            [0.1723, -0.0342, 0.4262, 0.1196, 0.1196],
            [0.1667, -0.0251, 0.4204, 0.1211, 0.1211],
            [0.1615, -0.0166, 0.4148, 0.1226, 0.1226],
            [0.1565, -0.0088, 0.4094, 0.1241, 0.1241],
            [0.1517, -0.0015, 0.4042, 0.1256, 0.1256],
            [0.1472, 0.0052, 0.3992, 0.127, 0.127],
            [0.143, 0.0114, 0.3944, 0.1284, 0.1284],
            [0.139, 0.0171, 0.3898, 0.1297, 0.1297],
            [0.1352, 0.0223, 0.3853, 0.131, 0.131],
            [0.1316, 0.0272, 0.3811, 0.1323, 0.1323],
            [0.1282, 0.0317, 0.3769, 0.1335, 0.1335],
            [0.1251, 0.0359, 0.373, 0.1347, 0.1347],
            [0.1221, 0.0397, 0.3692, 0.1359, 0.1359],
            [0.1193, 0.0432, 0.3655, 0.137, 0.137],
            [0.1167, 0.0465, 0.362, 0.1381, 0.1381],
            [0.1142, 0.0495, 0.3586, 0.1392, 0.1392],
            [0.1119, 0.0523, 0.3553, 0.1402, 0.1402],
            [0.1098, 0.0549, 0.3521, 0.1412, 0.1412],
            [0.1078, 0.0572, 0.3491, 0.1422, 0.1422],
            [0.1059, 0.0594, 0.3461, 0.1432, 0.1432],
            [0.1042, 0.0614, 0.3433, 0.1441, 0.1441],
            [0.1026, 0.0632, 0.3406, 0.145, 0.145],
            [0.1011, 0.0649, 0.3379, 0.1458, 0.1458],
            [0.0997, 0.0665, 0.3354, 0.1467, 0.1467],
            [0.0984, 0.0679, 0.3329, 0.1475, 0.1475]
        ][idxBondLength];
    }

    function H2IdentityCoeff(idxBond : Int) : Double {
        return [
            2.8489, 2.1868, 1.7252, 1.3827, 1.1182,
            0.9083, 0.7381, 0.5979, 0.4808, 0.3819,
            0.2976, 0.2252, 0.1626, 0.1083, 0.0609,
            0.0193, -0.0172, -0.0493, -0.0778, -0.1029,
            -0.1253, -0.1452, -0.1629, -0.1786, -0.1927,
            -0.2053, -0.2165, -0.2265, -0.2355, -0.2436,
            -0.2508, -0.2573, -0.2632, -0.2684, -0.2731,
            -0.2774, -0.2812, -0.2847, -0.2879, -0.2908,
            -0.2934, -0.2958, -0.298, -0.3, -0.3018,
            -0.3035, -0.3051, -0.3066, -0.3079, -0.3092,
            -0.3104, -0.3115, -0.3125, -0.3135
        ][idxBond];
    }

    function H2Terms(idxHamiltonian : Int)
    : (Pauli[], Int[]) {
        return [
            ([PauliZ], [0]),
            ([PauliZ], [1]),
            ([PauliZ, PauliZ], [0, 1]),
            ([PauliY, PauliY], [0, 1]),
            ([PauliX, PauliX], [0, 1])
        ][idxHamiltonian];
    }

    operation PrepareInitalState(q : Qubit[])
    : Unit {
        X(q[0]);
    }

    operation EvolveUnderHamiltonianTerm(
        idxBondLength : Int,
        idxTerm : Int,
        stepSize : Double,
        qubits : Qubit[])
    : Unit is Adj + Ctl {
        let (pauliString, idxQubits) =
            H2Terms(idxTerm);
        let coeff =
            (H2Coeff(idxBondLength))[idxTerm];
        let op = Exp(pauliString,
            stepSize * coeff, _);
        (RestrictedToSubregisterCA(op, idxQubits))
            (qubits);
    }

    operation EvolveUnderHamiltonian(
        idxBondLength : Int,
        trotterStepSize : Double,
        qubits : Qubit[])
    : Unit is Adj + Ctl {
        let trotterOrder = 1;
        let op = EvolveUnderHamiltonianTerm(
                idxBondLength, _, _, _);
        (DecomposedIntoTimeStepsCA ((5, op), trotterOrder))
            (trotterStepSize, qubits);
    }

    operation EstimateH2Energy(idxBondLength : Int)
    : Double {
        let nQubits = 2;
        let trotterStepSize = 1.0;
        let trotterStep = EvolveUnderHamiltonian(
            idxBondLength, trotterStepSize, _);
        let estPhase = EstimateEnergy(nQubits,
            PrepareInitalState, trotterStep,
            RobustPhaseEstimation(6, _, _));
        return estPhase / trotterStepSize
            + H2IdentityCoeff(idxBondLength);
    }
}
