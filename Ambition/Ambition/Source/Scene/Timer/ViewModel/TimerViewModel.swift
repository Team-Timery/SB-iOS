import Foundation
import RxSwift
import RxCocoa

class TimerViewModel: ViewModelType {
    var disposedBag: DisposeBag = DisposeBag()

    struct Input {
        let getSubjectList: Signal<Void>
        let deleteSubject: Signal<Int>
    }

    struct Output {
        let postData: Driver<MySubjectsEntity?>
        let reloadList: PublishRelay<Void>
    }

    func transform(input: Input) -> Output {
        let subjectService = SubjectService()
        let postData = BehaviorRelay<MySubjectsEntity?>(value: nil)
        let reloadList = PublishRelay<Void>()

        input.getSubjectList.asObservable()
            .flatMap { _ in
                subjectService.getMySubjects()
            }
            .subscribe(onNext: { data, res in
                switch res {
                case .SUCCEED:
                    postData.accept(data)
                default:
                    postData.accept(nil)
                }
            })
            .disposed(by: disposedBag)

        input.deleteSubject.asObservable()
            .flatMap { id in
                subjectService.deleteMySubject(subjectID: id)
            }
            .subscribe(onNext: { res in
                switch res {
                case .SUCCEED:
                    reloadList.accept(())
                default:
                    print("errr")
                }
            })
            .disposed(by: disposedBag)

        return Output(
            postData: postData.asDriver(),
            reloadList: reloadList
        )
    }
}
