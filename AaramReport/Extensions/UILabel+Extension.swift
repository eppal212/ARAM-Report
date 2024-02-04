//
//  UILabel+Extension.swift
//  AaramReport
//
//  Created by OBeris on 2/4/24.
//

import UIKit

extension UILabel {
    func setAutoKerning() {
        guard let attr = attributedText else { return }

        let textWidth = attr.width(withHeight: frame.height)

        guard textWidth != frame.width else { return }

        let spaceCount = attr.length - 1
        let spaceWidth = (frame.width - textWidth) / CGFloat(spaceCount)

        let mutable = NSMutableAttributedString(attributedString: attr)
        mutable.addAttribute(.kern, value: spaceWidth, range: NSRange(location: 0, length: attr.length - 1))

        attributedText = mutable
    }
}
