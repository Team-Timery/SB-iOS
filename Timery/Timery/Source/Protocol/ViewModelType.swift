import Foundation
import RxSwift

public protocol ViewModelType: HasDisposeBag {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}
