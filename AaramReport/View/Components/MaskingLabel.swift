//  https://stackoverflow.com/questions/39140306/masking-uiview-uiimageview-to-cutout-transparent-text

import UIKit

@IBDesignable
class MaskingLabel: UILabel {
    private var originalBackgroundColor: UIColor? = nil

    override init(frame: CGRect) {
        super.init(frame: frame)
        initLabel()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initLabel()
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: .zero))
        guard let context = UIGraphicsGetCurrentContext() else { return }

        context.saveGState()
        context.setBlendMode(.clear)

        originalBackgroundColor?.setFill()
        UIRectFill(rect)

        super.drawText(in: rect)
        context.restoreGState()
    }

    private func initLabel() {
        // Label을 마스킹 하기 전에 background는 투명이어야 함. 그러므로 background를 미리 백업해둠.
        originalBackgroundColor = backgroundColor
        backgroundColor = .clear
        self.clipsToBounds = true
    }
}
