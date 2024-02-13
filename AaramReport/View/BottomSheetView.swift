import UIKit
import FloatingPanel

class BottomSheetView: FloatingPanelController {

    init() {
        super.init(delegate: nil)
        initLayout()
    }

    convenience init(contentVC: UIViewController, layout: FloatingPanelLayout) {
        self.init()
        setContentVC(contentVC: contentVC, layout: layout)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initLayout()
    }

    private func initLayout() {
        self.isRemovalInteractionEnabled = true
        self.backdropView.dismissalTapGestureRecognizer.isEnabled = true
        self.backdropView.backgroundColor = .black

        self.surfaceView.grabberHandle.isHidden = true

        let appearance = SurfaceAppearance()
        appearance.cornerRadius = 16
        appearance.backgroundColor = UIColor(white: 0, alpha: 0.5)
        self.surfaceView.appearance = appearance
    }

    func setContentVC(contentVC: UIViewController, layout: FloatingPanelLayout) {
        self.set(contentViewController: contentVC)
        self.layout = layout
    }
}
