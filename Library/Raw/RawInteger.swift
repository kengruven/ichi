// NOTE TO SELF: raw types mean "without units".
// FUTURE: use Z/R/C/Q as aliases for raw types?

// [.] TODO: +-*/ (/ gives remainder, too?)
// - [ ] IDEA: / should give (quotient, remainder) -- or a way to get a Rational
// --- [ ] OR: new op /% to do both, and / truncates, so /= makes sense?
// - [X] TODO: += etc
// [X] TODO: +- (unary)
// [X] TODO: pow (^?)
// [ ] TODO?: inc/dec
// [X] TODO: < > <= >= == !=
// [.] TODO: format/parse
// [ ] TODO: to/from Swift.Int
// -- [ ] TODO: #bits needed?
// [ ] TODO: #digits; [] to access?
// [?] FUTURE: other bases?
// [?] FUTURE: ranges (..< ...)

struct RawInteger: RawRealType {
    private let negative: Bool
    private let chunks: [Int64]  // chunks of chunkSize digits -- i[0] is the LSW
    private static let chunkSize = 2  // number of decimal digits per chunk -- should be strictly less than floor(log(type(of:chunk))==18, to make carrying/normalization much simpler
    // ^^TEMPORARY: make this more like 12!

    // CHECK: is zero [] or [0]?  for now, [0].
    static let zero = RawInteger(negative: false, chunks: [0])
    static let one = RawInteger(negative: false, chunks: [1])
}

extension RawInteger {
    static prefix func + (item: RawInteger) -> RawInteger {
        return item
    }

    static prefix func - (item: RawInteger) -> RawInteger {
        return 0 - item
    }

    static func + (left: RawInteger, right: RawInteger) -> RawInteger {
        fatalError("WRITEME: a+b")
    }

    static func - (left: RawInteger, right: RawInteger) -> RawInteger {
        return left + -right
    }

    static func * (left: RawInteger, right: RawInteger) -> RawInteger {
        fatalError("WRITEME: a * b")
    }

    static func += (_ left: inout RawInteger, _ right: RawInteger) {
        left = left + right
    }

    static func -= (_ left: inout RawInteger, _ right: RawInteger) {
        left = left - right
    }

    static func *= (_ left: inout RawInteger, _ right: RawInteger) {
        left = left * right
    }

    // MAYBE?/TODO: no /= because / returns a (quot,rem) tuple?  but /= seems like it'd be pretty useful!

    // FUTURE?: a symbol, like ** or ^ maybe?
    func pow(_ exponent: RawInteger) -> RawInteger {
        var result: RawInteger = 1
        var i: RawInteger = 0
        while i < exponent {
            result *= self
            i += 1
        }
        return result
    }

    static func == (left: RawInteger, right: RawInteger) -> Bool {
        guard left.negative == right.negative else { return false }
        guard left.chunks == right.chunks else { return false }
        return true
    }

    static func != (left: RawInteger, right: RawInteger) -> Bool {
        return !(left == right)
    }

    // UNTESTED:
    static func < (left: RawInteger, right: RawInteger) -> Bool {
        // sign different?
        switch (left.negative, right.negative) {
            case (true, false): return true
            case (false, true): return false
            default: break
        }

        // length different?
        if left.chunks.count != right.chunks.count {
            return (left.chunks.count < right.chunks.count).toggled(if: left.negative)
        }

        // need to check each chunk, starting from the most-sig
        for (a, b) in zip(left.chunks, right.chunks).reversed() {
            if a != b {
                return (a < b).toggled(if: left.negative)
            }
        }
        return false
    }

    static func <= (left: RawInteger, right: RawInteger) -> Bool {
        return left < right || left == right
    }

    static func > (left: RawInteger, right: RawInteger) -> Bool {
        return right < left
    }

    static func >= (left: RawInteger, right: RawInteger) -> Bool {
        return right < left || right == left
    }
}

// KLUGE/TEMP: multiply it out myself here -- this function doesn't really exist in swift...
fileprivate func _pow(_ base: Int, _ exponent: Int) -> Int {
    var result = 1
    for _ in 0..<exponent {
        result *= base
    }
    return result
}

extension RawInteger: ExpressibleByIntegerLiteral {
    init(integerLiteral value: Int) {
        self.negative = (value < 0)

        let multiplier = Int64(_pow(10, RawInteger.chunkSize))
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
                buffer.append(chunkValue)  // BUG?: if this is 0, do we add extra useless [0]'s at the msb end?

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
