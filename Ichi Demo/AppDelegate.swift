import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        print("hello, world!")

        // TODO: sample uses of Raw{Integer,Rational,Decimal}
        // TODO: sample uses of {Integer,Rational,Decimal}
        // TODO: static and dynamic type checking and conversions

        // FIRST STEPS:
        let i: RawInteger = 20
        print("i = \(i)")

        let j: RawInteger = "200,000,000,000,000,000,000"
        print("j = \(j)")

        // BUG?: with chunkSize=2, this has an [11]=0

        print("i < j ? \(i < j)")
        print("j < i ? \(j < i)")
        print("i < i ? \(i < i)")

        let k = i + j
        print("k = \(k)")
    }
}
