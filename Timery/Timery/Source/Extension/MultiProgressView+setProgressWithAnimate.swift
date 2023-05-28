import UIKit
import MultiProgressView

extension MultiProgressView {
    func setProgressWithAnimate(section: Int, to progressValue: Float, withDuration: Double) {
        UIView.animate(withDuration: withDuration, animations: {
            self.setProgress(section: section, to: progressValue)
        })
    }
}
