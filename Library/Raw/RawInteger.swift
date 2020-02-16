// NOTE TO SELF: raw types mean "without units".
// FUTURE: use Z/R/C/Q as aliases for raw types?

struct RawInteger: RawRealType {
    private let negative: Bool
    private let chunks: [Int64]  // chunks of chunkSize digits -- i[0] is the LSW
    private static let chunkSize = 18  // number of decimal digits per chunk -- basically floor(log(type(of:chunk))

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

        let multiplier = Int64(pow(10, RawInteger.chunkSize))
        var remainder = Int64(abs(value))
        var buffer: [Int64] = []
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

extension RawInteger: ExpressibleByStringLiteral {
    // note: this init isn't failable/throws -- it's got to return something.
    // so it forces the parsing, since you should only use this for constants
    // which you know should work!
    init(stringLiteral value: String) {
        // filter all but (leading) '-' and digits
        // - MAYBE: fail if there's any decimal point, or other junk?
        let digitValues = value.filter({ $0.isWholeNumber }).map({ Int64($0.wholeNumberValue!) }).filter({ (0..<10).contains($0) })
        // ^^KLUGE: just ignore bad chars, for now

        // group by chunks (of RawInteger.chunkSize), starting at the end
        var chunkValue: Int64 = 0
        var digitsInChunk = 0
        var multiplier: Int64 = 1  // = pow(10, digitsInChunk + 1)
        var buffer: [Int64] = []
        for digit in digitValues.reversed() {
            // KLUGE: (see below)
            if digitsInChunk == RawInteger.chunkSize {
                buffer.append(chunkValue)

                // CLEANUP: duplicate with above
                chunkValue = 0
                digitsInChunk = 0
                multiplier = 1
            }

            chunkValue += digit * multiplier
            multiplier *= 10
            digitsInChunk += 1
        }

        if chunkValue != 0 {  // KLUGE/TESTING: is this ok?
            buffer.append(chunkValue)
        }

        self.chunks = buffer
        self.negative = value.hasPrefix("-")  // FIXME: this is much stricter than the rest of the parser!
    }
}

extension RawInteger: CustomStringConvertible {
    var description: String {
        // TEMP: just dump something -- i'll write real formatting later

        var buffer = ""
        var i = 0
        for (chunkNr, chunk) in chunks.enumerated() {  // CLEANUP?: i only need lastp here
            var value = chunk
            for _ in 0..<RawInteger.chunkSize {
                let digit = value % Int64(10)
                buffer += String(digit)
                value /= Int64(10)

                if value == 0 && chunkNr == chunks.count - 1 {
                    break
                }

                if i % 3 == 2 {
                    buffer += ","
                }
                i += 1
            }
        }

        return (negative ? "-" : "") + String(buffer.reversed())
    }
}
