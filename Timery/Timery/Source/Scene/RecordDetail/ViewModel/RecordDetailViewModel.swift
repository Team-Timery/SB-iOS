import Foundation
import RxSwift
import RxCocoa

final class RecordDetailViewModel: ViewModelType {
    struct Input {
        let memoChanged: Observable<String>
    }
    struct Output {
        let recordEntity: Driver<RecordEntity>
    }

    var disposeBag: DisposeBag = .init()
    private let recordEntity: RecordEntity

    init(recordEntity: RecordEntity) {
        self.recordEntity = recordEntity
    }

    func transform(input: Input) -> Output {
        let recordService = RecordService()

        let recordEntityRelay = BehaviorRelay(value: recordEntity)

        input.memoChanged
            .flatMap { [recordEntity] newMemo in
                recordService.updateRecordMemo(recordID: recordEntity.recordID, memo: newMemo)
                    .map { newMemo }
            }
            .map { [recordEntity] in
                RecordEntity(
                    recordID: recordEntity.recordID,
                    startedTime: recordEntity.startedTime,
                    finishedTime: recordEntity.finishedTime,
                    total: recordEntity.total,
                    memo: $0,
                    isRecord: recordEntity.isRecord,
                    subject: recordEntity.subject
                )
            }
            .catchAndReturn(recordEntity)
            .bind(to: recordEntityRelay)
            .disposed(by: disposeBag)

        return Output(
            recordEntity: recordEntityRelay.asDriver()
        )
    }
}
