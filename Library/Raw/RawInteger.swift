// NOTE TO SELF: raw types mean "without units".
// FUTURE: use Z/R/C/Q as aliases for raw types?

struct RawInteger: RawRealType {
    private let negative: Bool
    private let chunks: [Int]  // chunks of chunkSize digits -- i[0] is the LSW
    private static let chunkSize = 3  // number of decimal digits per chunk

    // CHECK: is zero [] or [0]?  for now, [0].
    static let zero = RawInteger(negative: false, chunks: [0])
    static let one = RawInteger(negative: false, chunks: [1])

    // WORKING HERE
}

extension RawInteger {
    static prefix func + (item: RawInteger) -> RawInteger {
        return item
    }

    static prefix func - (item: RawInteger) -> RawInteger {
        fatalError("MAYBE: RawInteger(0) - item")
    }

    static func + (left: RawInteger, right: RawInteger) -> RawInteger {
        fatalError("WRITEME")
    }

    // TODO: +-*/ (/ gives remainder, too?)
    // - TODO: += etc
    // TODO: +- (unary)
    // TODO: expt (^?)
    // TODO: inc/dec
    // TODO: < > <= >= == !=
    // TODO: format/parse
    // TODO: to/from Swift.Int
    // TODO: #digits; [] to access?

    // FUTURE: other bases?
}

// KLUGE/TEMP: multiply it out myself here -- this function doesn't really exist in swift...
fileprivate func pow(_ base: Int, _ exponent: Int) -> Int {
    var result = 1
    for _ in 0..<exponent {
        result *= base
    }
    return result
}

extension RawInteger: ExpressibleByIntegerLiteral {
    init(integerLiteral value: Int) {
        self.negative = (value < 0)

        let multiplier = pow(10, RawInteger.chunkSize)
        var remainder = abs(value)
        var buffer: [Int] = []
        while remainder > 0 {
            buffer += [remainder % multiplier]
            remainder /= multiplier
        }
        if buffer.isEmpty {
            buffer = [0]
        }

        self.chunks = buffer
    }
}

extension RawInteger: CustomStringConvertible {
    var description: String {
        // TEMP: just dump something -- i'll write real formatting later
        // - FIXME: 0 is printed as "000" -- use "%d" for the leftmost chunk
        return (negative ? "-" : "") + chunks.reversed().map({ String(format: "%03d", $0) }).joined()
    }
}
