protocol Dimension: NumericType {
    // FIRST TRY:
    associatedtype ValueType: RawRealType

    var value: ValueType { get set }
    var unit: Unit { get set }
}


/*
 NEW PLAN!
 - static dimension = Int<Distance>(5, .meters)
 --- Meters has ?? = Dimension.Length, so this is statically checked
 --- (HARD!)
 --- to dyn: .asDynamicType = simple erasure
 - dynamic dimension = Int(walue: 5, unit: Unit("m"))
 --- to stat: .asStaticType<Distance>(n, ??)
 --- Q: is there a small finite number of units i can use here?
 ----- Q: can i build up composite units from this small set, and still have type-checking?

 THE BASIC PROBLEM:
 - allow units to be specified at run-time
 - allow units to be specified at compile-time
 - types are checked where they're specified
 - (some languages will only allow #1, and that's ok -- it should be usable that way still)
 */
