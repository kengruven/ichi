# What is a number?

Out here **in the real world**, the numbers I use most often look like:

 1. An integer (as a count or index)
 2. A decimal number or mixed fraction (as a measurement), with any/all of:
    1. units ("41°F", "5 3/8th inches")
    2. precision ("... ±1/16th", "about ...")

 3. Values with special units which have their own funky rules:
    1. Money (nearly always 2 decimals of precision)
    2. Temperature (which requires an affine transform between units)
    3. Time (often as a mixed fraction with many different divisors: 7, 24, 60, etc)

Occasionally, I need:

 4. Complex numbers
 5. Arbitrary size integers
 6. Arbitrary precision decimals (including repeating decimals)
 7. Legacy units (like Japanese traditional measurements)
 
The operations I perform tend to be:
 - Algebraic operations (checking that units are compatible, and converting if necessary)
 - Unit conversion

Most **programming languages**, in contrast, offer two kinds of numbers:

 1. Modulo integers (mod 2^8N, for various N; where overflow wraps, saturates, or is undefined)
   a. Signed and unsigned variants
 2. IEEE-754 floating point numbers (binary scientific notation, plus various other values like `NaN`s and `Inf`s)

In some higher-level languages and standard libraries, there is also:

 3. Arbitrary size integers

These features aren't even properly cohesive with each other:

 - Often, bignums are a separate type that can't be used as a simple replacement for the standard fixint.
 - While floating point numbers have concepts like "infinity" and "not-a-number" as native values,
     integers do not have any corresponding values.
 - When a language has some elegant native method for referring to "not-an-X" (like Maybe or Optional),
     it still always retains the special `NaN` value for floats.

Clearly, these are very different worlds.
