// operations.qs: Sample code for Phase Estimation (Chapter 9).
//
// Copyright (c) Sarah Kaiser and Chris Granade.
// Code sample from the book "Learn Quantum Computing with Python and Q#" by
// Sarah Kaiser and Chris Granade, published by Manning Publications Co.
// Book ISBN 9781617296130.
// Code licensed under the MIT License.

namespace PhaseEstimation {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Convert as Convert;
    open Microsoft.Quantum.Measurement as Meas;
    open Microsoft.Quantum.Arrays as Arrays;

    operation ApplyScaledRotation(
        angle : Double, scale : Double,
        target : Qubit)
    : Unit is Adj + Ctl {
        R1(angle * scale, target);
    }

    newtype ScalableOperation = (
        Apply: ((Double, Qubit) => Unit is Adj + Ctl)
    );

    function HiddenRotation(hiddenAngle : Double)
    : ScalableOperation {
        return ScalableOperation(
            ApplyScaledRotation(hiddenAngle, _, _)
        );
    }

    operation EstimateProbabilityAtScale(
        scale : Double,
        nMeasurements : Int,
        op : ScalableOperation)
    : Double {
        mutable nOnes = 0;
        for idx in 0..nMeasurements - 1 {
            use target = Qubit();
            within {
                H(target);
            } apply {
                op::Apply(scale, target);
            }
            set nOnes += Meas.MResetZ(target) == One
                         ? 1 | 0;
        }
        return Convert.IntAsDouble(nOnes) /
               Convert.IntAsDouble(nMeasurements);
    }

    operation RunGame(
        hiddenAngle : Double, scales : Double[], nMeasurementsPerScale : Int
    ) : Double[] {
        let hiddenRotation = HiddenRotation(hiddenAngle);
        return Arrays.ForEach(
            EstimateProbabilityAtScale(
                _,
                nMeasurementsPerScale,
                hiddenRotation
            ),
            scales
        );
    }

    operation EstimateProbabilityAtScaleUsingControlledRotations(
        target : Qubit,
        scale : Double,
        nMeasurements : Int,
        op : ScalableOperation)
    : Double {
        mutable nOnes = 0;
        for idx in 0..nMeasurements - 1 {
            use control = Qubit();
            within {
                H(control);
            } apply {
                Controlled op::Apply(
                    [control],
                    (scale, target)
                );
            }
                set nOnes += Meas.MResetZ(control) == One
                             ? 1 | 0;
        }
        return Convert.IntAsDouble(nOnes) /
               Convert.IntAsDouble(nMeasurements);
    }

    operation RunGameUsingControlledRotations(
        hiddenAngle : Double,
        scales : Double[],
        nMeasurementsPerScale : Int)
    : Double[] {
        let hiddenRotation = HiddenRotation(hiddenAngle);
        use target = Qubit();
        X(target);
        let measurements = Arrays.ForEach(
            EstimateProbabilityAtScaleUsingControlledRotations(
                target, _, nMeasurementsPerScale, hiddenRotation
            ),
            scales
        );
        X(target);
        return measurements;
    }
}
