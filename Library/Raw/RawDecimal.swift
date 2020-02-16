struct RawDecimal: RawRealType {
    // WRITEME: scientific notation: base, exp
    // WRITEME: precision!  enum{PP*, sigfigs, ???}

    // WRITEME: +-*/ ^ exp/log trig ...
}

// FUTURE: ->Q (using precision!) -- and ->Qpi?

extension RawDecimal: ExpressibleByFloatLiteral {
    init(floatLiteral value: Double) {
        fatalError("WRITEME: got float \(value)")
    }
}
