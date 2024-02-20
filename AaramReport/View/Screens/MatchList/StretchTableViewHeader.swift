import Foundation
import UIKit

@IBDesignable
class StretchTableViewHeader: UIView {

    let imageView = UIImageView()

    private var imageViewHeight = NSLayoutConstraint()
    private var imageViewBottom = NSLayoutConstraint()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initLayout()
    }

    private func initLayout() {
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageViewBottom = imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        imageViewHeight = imageView.heightAnchor.constraint(equalTo: self.heightAnchor)
        NSLayoutConstraint.activate([ imageViewBottom, imageViewHeight, self.widthAnchor.constraint(equalTo: imageView.widthAnchor) ])
    }

    // scrollView.contentOffest, scrollView.contentInset을 받아옴
    func scrollViewDidScroll(offset: CGPoint, inset: UIEdgeInsets) {
        let offsetY = offset.y + inset.top
        self.clipsToBounds = offsetY > 0
        imageViewBottom.constant = offsetY > 0 ? offsetY / 2 : 0
        imageViewHeight.constant = max(-offsetY, 0)
    }
}
