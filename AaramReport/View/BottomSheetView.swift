import UIKit
import FloatingPanel

class BottomSheetView: FloatingPanelController {
    
    init(contentVC: UIViewController) {
        super.init(delegate: nil)

        self.set(contentViewController: contentVC)
        self.isRemovalInteractionEnabled = true
        self.backdropView.dismissalTapGestureRecognizer.isEnabled = true
        self.backdropView.backgroundColor = .black

        self.surfaceView.grabberHandle.isHidden = true

        let appearance = SurfaceAppearance()
        appearance.cornerRadius = 16
        self.surfaceView.appearance = appearance

        let panelLayout = TouchBlockIntrinsicPanelLayout()
        self.layout = panelLayout
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

class TouchBlockIntrinsicPanelLayout: FloatingPanelBottomLayout {
    override var initialState: FloatingPanelState { .tip }
    override var anchors: [FloatingPanelState : FloatingPanelLayoutAnchoring] {
        return [
            .tip: FloatingPanelLayoutAnchor(absoluteInset: 300, edge: .bottom, referenceGuide: .safeArea)
        ]
    }

    override func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
        0.5
    }
}
