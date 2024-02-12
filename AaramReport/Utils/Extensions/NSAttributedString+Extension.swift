//
//  NSAttributedString+Extension.swift
//  AaramReport
//
//  Created by OBeris on 2/4/24.
//

import Foundation

extension NSAttributedString {
    func width(withHeight height: CGFloat? = nil) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height ?? .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)

        return ceil(boundingBox.width)
    }
}
