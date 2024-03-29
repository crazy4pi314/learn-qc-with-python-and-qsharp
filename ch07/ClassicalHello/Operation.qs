﻿// Operation.qs: Demo of the Message function used to make a HelloWorld program
// (Chapter 7).
//
// Copyright (c) Sarah Kaiser and Cassandra Granade.
// Code sample from the book "Learn Quantum Computing with Python and Q#" by
// Sarah Kaiser and Cassandra Granade, published by Manning Publications Co.
// Book ISBN 9781617296130.
// Code licensed under the MIT License.

namespace ClassicalHello {
    open Microsoft.Quantum.Intrinsic;

    function HelloWorld() : Unit {
        Message("Hello, classical world!");
    }
}
