# Learn Quantum Computing with Python and Q# <br> Sample Code #

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/crazy4pi314/learn-qc-with-python-and-qsharp/master)
[![discord](https://img.shields.io/discord/713831924451377193)](https://discord.gg/RmReNjt)
[![Qsharp-version](https://img.shields.io/badge/Q%23%20dependencies-0.12-blue)](https://docs.microsoft.com/en-us/quantum/resources/relnotes#version-01220070124)
![Prebuild Docker images](https://github.com/crazy4pi314/learn-qc-with-python-and-qsharp/workflows/Prebuild%20Docker%20images/badge.svg?branch=master)
[![licence](https://img.shields.io/github/license/crazy4pi314/learn-qc-with-python-and-qsharp)](https://github.com/crazy4pi314/learn-qc-with-python-and-qsharp/blob/master/LICENSE)

This repository provides sample code for [_Learn Quantum Computing with Python and Q#_](https://www.manning.com/books/learn-quantum-computing-with-python-and-q-sharp) (Dr. Sarah Kaiser and Dr. Chris Granade, Manning Publications), currently in Manning Early Access Preview.

Below, we provide some instructions on getting started with each sample; please see [Appendix A](https://livebook.manning.com/book/learn-quantum-computing-with-python-and-q-sharp/appendix-a?origin=product-toc) for more details.

## Getting Started with Code Samples ##

The samples for Chapters 2 through 5 are written in Python, while the examples in Chapters 6 and later are written in Q# and are called from either Python or by IQ# Notebooks.
All samples can be run in one of two ways, depending on your preferences:

- Using [conda](https://docs.conda.io/en/latest/) (a distribution of Python) and the [Quantum Development Kit](https://docs.microsoft.com/quantum) together
- Using [Visual Studio Code devcontainers](https://code.visualstudio.com/docs/remote/containers) and [Docker](https://www.docker.com/) to manage software installation

### Anaconda

The [Anaconda distribution of Python 3](https://www.anaconda.com/distribution/) provides the [conda package manager](https://docs.conda.io/en/latest/) to help you install and work with software written in Python.
You can use conda and the Quantum Development Kit together to run all of the samples in this book.

Prerequisites:

- Anaconda for Python 3.7, available from https://www.anaconda.com/distribution/.
- Optional:
  - The .NET Core SDK 3.0 or later, available from https://dotnet.microsoft.com/download.

Once you have all of the prerequisites installed, you can create a conda environment using the configuration provided in this repository:

```
conda env create -f environment.yml
```

This will provide all of the Python software you'll need to get started into a new conda environment called `qsharp-book`.
To use this new environment, run `conda activate qsharp-book`.

> If you would optionally like to use IQ# from outside of your conda environment, you can use the .NET Core SDK:
>
> ```
> dotnet tool install --global Microsoft.Quantum.IQSharp
> dotnet iqsharp install
> ```
>
> This step is **not** required to use the samples shown in the book.

### Using devcontainers ###

If you prefer, you can also use Visual Studio Code and Docker together to automatically configure all of the software required for use with the code samples in this book.

Prerequisites:

- Docker Desktop 2.0 or later (Windows and macOS).
- Docker CE or EE 18.06 or later (Linux).
- Visual Studio Code, available from https://code.visualstudio.com/download, with the [Remote Development extension pack](https://aka.ms/vscode-remote/download/extension).

> For more details about how to install and use Docker, check out [_Docker in Action, 2nd Edition_](https://www.manning.com/books/docker-in-action-second-edition).

Once you have all of the prerequisites installed, open the folder containing these samples in Visual Studio Code.
You should then be prompted to reopen the folder in a development container; if not, press Ctrl+Shift+P (Windows and Linux) or ⌘+Shift+P (macOS) to open the command pallet and type "Reopen in Container."
This will automatically download and install all software required for use with these samples into a Docker container, and will run Visual Studio Code within that new container.

> **Known issues:**
> - When using a devcontainer, the plotting examples in Chapter 8 and 9 can only be run through Jupyter Notebook, not by running `host.py` from the command line.
> - To run Jupyter Notebook, use `jupyter notebook --ip 0.0.0.0` rather than just `jupyter notebook`, so as to allow your host operating system to access the Notebook server.
