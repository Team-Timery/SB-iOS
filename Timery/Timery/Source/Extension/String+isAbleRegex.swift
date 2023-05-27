import Foundation

extension String {
    func isAbleRegex(regex: String) -> Bool {
      let emailTest = NSPredicate(format: "SELF MATCHES %@", regex)
      return emailTest.evaluate(with: self)
    }
}
