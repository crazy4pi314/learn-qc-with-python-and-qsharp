// Operation.qs: Demo of the Message function used to make a HelloWorld program
// (Chapter 7).
//
// Copyright (c) Sarah Kaiser and Chris Granade.
// Code sample from the book "Learn Quantum Computing with Python and Q#" by
// Sarah Kaiser and Chris Granade, published by Manning Publications Co.
// Book ISBN 9781617296130.
// Code licensed under the MIT License.

namespace ClassicalHello { 
    @EntryPoint()
    operation RunHelloWorld() : Unit {
        HelloWorld();
    }
}
