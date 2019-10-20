# Learn Quantum Computing with Python and Q# <br> Sample Code #

This repository provides sample code for [_Learn Quantum Computing with Python and Q#_](https://www.manning.com/books/learn-quantum-computing-with-python-and-q-sharp) (Dr. Sarah Kaiser and Dr. Chris Granade, Manning Publications), currently in Manning Early Access Preview.

Below, we provide some instructions on getting started with each sample; please see Appendix A (coming soon) for more details.

## Getting Started with Python ##

The examples for Chapters 2 through 5 are written in Python.
To run these examples, we recommend the [Anaconda distribution of Python 3](https://www.anaconda.com/distribution/).
Once you have installed Anaconda, you can create [a Conda environment](https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html) to run the sample code in by running the following command:

```
conda create -n=quantum -c conda-forge python>=3.6 ipython numpy matplotlib notebook qutip
```

## Getting Started with Q# ##

The examples in Chapters 6 through 11 are written in Q#, a new quantum programming language from Microsoft.
To run these examples, please follow the [Getting Started with Jupyter Notebooks](https://docs.microsoft.com/quantum/install-guide/jupyter) provided with Microsoft's Quantum Development Kit.
