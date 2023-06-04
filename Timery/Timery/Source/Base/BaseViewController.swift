import RxSwift
import UIKit

open class BaseViewController<ViewModel: ViewModelType>:
    UIViewController,
    HasViewModel,
    AddViewable,
    ConstraintMakable,
    HasDisposeBag,
    ViewModelBindable {
    public var viewModel: ViewModel
    public var disposeBag: DisposeBag = DisposeBag()

    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        makeConstraints()
        bind()
    }

    open func addSubViews() {}
    open func makeConstraints() {}
    open func bind() {}
}
