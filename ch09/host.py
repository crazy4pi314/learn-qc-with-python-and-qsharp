#!/bin/env python
# -*- coding: utf-8 -*-
##
# host.py: Runs the host program for the phase estimation quantum algorithm.
##
# Copyright (c) Sarah Kaiser and Chris Granade.
# Code sample from the book "Learn Quantum Computing with Python and Q#" by
# Sarah Kaiser and Chris Granade, published by Manning Publications Co.
# Book ISBN 9781617296130.
# Code licensed under the MIT License.
##

import qsharp
from PhaseEstimation import RunGame, RunGameUsingControlledRotations

from typing import Any
import scipy.optimize as optimization
import numpy as np

BIGGEST_ANGLE = 2 * np.pi

def run_game_at_scales(scales: np.ndarray,
                       n_measurements_per_scale: int = 100,
                       control: bool = False
    ) -> Any:
    hidden_angle = np.random.random() * BIGGEST_ANGLE
    print(f"Pssst the hidden angle is {hidden_angle}, good luck!")
    return (
        RunGameUsingControlledRotations
        if control else RunGame
    ).simulate(
        hiddenAngle=hidden_angle,
        nMeasurementsPerScale=n_measurements_per_scale,
        scales=list(scales)
    )

if __name__ == "__main__":
    import matplotlib.pyplot as plt
    scales = np.linspace(0, 2, 101)
    for control in (False, True):
        data = run_game_at_scales(scales, control=control)

        def rotation_model(scale, angle):
            return np.sin(angle * scale / 2) ** 2
        angle_guess, est_error = optimization.curve_fit(
            rotation_model, scales, data, BIGGEST_ANGLE / 2,
            bounds=[0, BIGGEST_ANGLE]
        )
        print(f"The hidden angle you think was {angle_guess}!")

        plt.figure()
        plt.plot(scales, data, 'o')
        plt.title("Probability of Lancelot measuring One at each scale")
        plt.xlabel("Lancelot's input scale value")
        plt.ylabel("Lancelot's probability of measuring a One")
        plt.plot(scales, rotation_model(scales, angle_guess))

    plt.show()
