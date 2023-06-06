import Foundation
import RxSwift
import RxCocoa

final class RecordDetailViewModel: ViewModelType {
    struct Input {
        let memoChanged: Observable<String>
    }
    struct Output {
        let recordDetailEntity: Driver<(RecordEntity, RecordDetailEntity)>
    }

    var disposeBag: DisposeBag = .init()
    private let recordEntity: RecordEntity

    init(recordEntity: RecordEntity) {
        self.recordEntity = recordEntity
    }

    func transform(input: Input) -> Output {
        let recordService = RecordService()

        let recordDetailEntityRelay = BehaviorRelay(
            value: (
                recordEntity,
                RecordDetailEntity(
                    recordID: recordEntity.recordID,
                    startedTime: recordEntity.startedTime,
                    finishedTime: recordEntity.finishedTime,
                    total: recordEntity.total,
                    memo: nil
                )
            )
        )

        Observable.just(())
            .flatMap { [recordEntity] in recordService.getDetailRecord(recordID: recordEntity.recordID) }
            .map { [recordEntity] in (recordEntity, $0) }
            .bind(to: recordDetailEntityRelay)
            .disposed(by: disposeBag)

        input.memoChanged
            .flatMap { [recordEntity] newMemo in
                recordService.updateRecordMemo(recordID: recordEntity.recordID, memo: newMemo)
                    .map { newMemo }
            }
            .map { [recordEntity] in
                (
                    recordEntity,
                    RecordDetailEntity(
                        recordID: recordEntity.recordID,
                        startedTime: recordEntity.startedTime,
                        finishedTime: recordEntity.finishedTime,
                        total: recordEntity.total,
                        memo: $0
                    )
                )
            }
            .catchAndReturn(recordDetailEntityRelay.value)
            .bind(to: recordDetailEntityRelay)
            .disposed(by: disposeBag)

        return Output(
            recordDetailEntity: recordDetailEntityRelay.asDriver()
        )
    }
}
