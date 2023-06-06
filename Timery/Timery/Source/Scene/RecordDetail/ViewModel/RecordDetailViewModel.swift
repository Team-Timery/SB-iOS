import Foundation
import RxSwift

final class RecordDetailViewModel: ViewModelType {
    struct Input {}
    struct Output {}

    var disposeBag: DisposeBag = .init()
    private let recordEntity: RecordEntity

    init(recordEntity: RecordEntity) {
        self.recordEntity = recordEntity
    }

    func transform(input: Input) -> Output {
        return Output()
    }
}
