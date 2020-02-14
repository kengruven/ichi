protocol RawRealType: RawNumericType {
    // TODO: what common functionality is there for reals?
    // - < > <= >= == !=
    // --- Q: can i make ≤≥ aliases?
    // ----- A: according to <https://docs.swift.org/swift-book/ReferenceManual/LexicalStructure.html#ID418> i can!
    // - MAYBE: +-*/ (except / on ints gives remainder, etc)
}
