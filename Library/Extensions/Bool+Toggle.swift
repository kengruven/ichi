extension Bool {
    // named analogously to func toggle() from SE-0199:
    func toggled(if: Bool) -> Bool {
        return `if` ? !self : self
    }
}
