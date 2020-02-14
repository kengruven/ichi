import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        print("hello, world!")

        // TODO: sample uses of Raw{Integer,Rational,Decimal}
        // TODO: sample uses of {Integer,Rational,Decimal}
        // TODO: static and dynamic type checking and conversions

        // FIRST STEPS:
        let i: RawInteger = 345
        print("i = \(i)")
    }
}
