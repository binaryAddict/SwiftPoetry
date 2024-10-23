import Foundation

public protocol Chainable {}

public extension Chainable {
    @discardableResult func with(_ block: (Self) -> Void) -> Self {
        block(self)
        return self
    }
    func mutatingWith(_ block: (inout Self) -> Void) -> Self {
        var value = self
        block(&value)
        return value
    }
    mutating func updatingWith(_ block: (inout Self) -> Void) {
        var value = self
        block(&value)
        self = value
    }
}

extension NSObject: Chainable {}
