import Foundation

public protocol ConstraintMakable {
    func makeConstraints()
}

public extension ConstraintMakable {
    func makeConstraints() {}
}
