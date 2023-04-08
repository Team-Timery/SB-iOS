import Foundation
import RxSwift

protocol ViewModelType {
    associatedtype Input
    associatedtype Output

    var disposedBag: DisposeBag { get set }

    func transform(input: Input) -> Output
}
