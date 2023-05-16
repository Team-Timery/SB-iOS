import Foundation

protocol SubjectCellTapButtonDelegate: AnyObject {
    func deleteButtonTapped(id: Int, indexPath: IndexPath, title: String?)
}
