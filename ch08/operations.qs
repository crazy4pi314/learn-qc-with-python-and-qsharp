// operations.qs: Sample code for Phase Estimation (Chapter 8).
//
// Copyright (c) Sarah Kaiser and Chris Granade.
// Code sample from the book "Learn Quantum Computing with Python and Q#" by
// Sarah Kaiser and Chris Granade, published by Manning Publications Co.
// Book ISBN 9781617296130.
// Code licensed under the MIT License.

// tag::open_stmts[]
namespace PhaseEstimation {                                                   // <1>
    open Microsoft.Quantum.Intrinsic;                                         // <2>
    open Microsoft.Quantum.Convert as Convert;                                // <3>
    open Microsoft.Quantum.Measurement as Meas;                               // <4>
    open Microsoft.Quantum.Arrays as Arrays;                                  // <5>
    // end::open_stmts[]

    // tag::apply_scaled[]
    operation ApplyScaledRotation(angle : Double,                             // <1>
                                  scale : Double,                           
                                  target : Qubit)                          
    : Unit is Adj + Ctl {                                                     // <2>
        R1(angle * scale, target);                                            // <3>
    }
    // end::apply_scaled[]

    // tag::hide_scalable[]

    newtype ScalableOperation = (                                             // <1>
        Apply: ((Double, Qubit) => Unit is Adj + Ctl)                         // <2>
    );

    function HiddenRotation(hiddenAngle : Double) : ScalableOperation {       // <3>
        return ScalableOperation(ApplyScaledRotation(hiddenAngle, _, _));     // <4>
    }

    // end::hide_scalable[]

    // tag::est_pr[]

    operation EstimateProbabilityAtScale(scale : Double,                      // <1>
                                         nMeasurements : Int,                 // <2>
                                         op : ScalableOperation)              // <3>
    : Double {                                                                // <4>
        mutable nOnes = 0;                                                    // <5>
        for (idx in 0..nMeasurements - 1) { 
            using (target = Qubit()) {                                        // <6>
                within {                                                      // <7>
                    H(target);                                                // <8>
                } apply {
                    op::Apply(scale, target);                                 // <9>
                }
                set nOnes += Meas.MResetZ(target) == One                      // <10>
                             ? 1
                             | 0;
            }
        }
        return Convert.IntAsDouble(nOnes) /                                   // <11>
               Convert.IntAsDouble(nMeasurements);
    }

    // end::est_pr[]

    // tag::run_game[]

    operation RunGame(hiddenAngle : Double,
                      scales : Double[],
                      nMeasurementsPerScale : Int)
    : Double[] {
        let hiddenRotation = HiddenRotation(hiddenAngle);                     // <1>
        return Arrays.ForEach(                                                // <2>
            EstimateProbabilityAtScale(                                       // <3>
                _,
                nMeasurementsPerScale,
                hiddenRotation
            ),
            scales                                                            // <4>
        );
    }

    // end::run_game[]

    // tag::est_pr_controlled[]

    operation EstimateProbabilityAtScaleUsingControlledRotations(
                            target : Qubit,
                            scale : Double,
                            nMeasurements : Int,
                            op : ScalableOperation)
    : Double {
        mutable nOnes = 0;
        for (idx in 0..nMeasurements - 1) {
            using (control = Qubit()) {
                within {
                    H(control);                                               // <1>
                } apply {                 
                    Controlled op::Apply(                                     // <2>
                        [control],
                        (scale, target)
                    );
                }
                set nOnes += Meas.MResetZ(control) == One
                                ? 1
                                | 0;
            }
        }
        return Convert.IntAsDouble(nOnes) /
               Convert.IntAsDouble(nMeasurements);
    }

    // end::est_pr_controlled[]

    // tag::run_game_controlled[]

    operation RunGameUsingControlledRotations(hiddenAngle : Double,
                      scales : Double[],
                      nMeasurementsPerScale : Int)
    : Double[] {
        let hiddenRotation = HiddenRotation(hiddenAngle);
        using (target = Qubit()) {                                            // <1>
            X(target);                                                        // <2>
            let measurements = Arrays.ForEach(
                EstimateProbabilityAtScaleUsingControlledRotations(
                    target,
                    _,
                    nMeasurementsPerScale,
                    hiddenRotation
                ),
                scales
            );
            X(target);
            return measurements;
        }
    }

    // end::run_game_controlled[]

}
