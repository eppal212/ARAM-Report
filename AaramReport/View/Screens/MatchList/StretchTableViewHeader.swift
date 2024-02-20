import Foundation
import UIKit

@IBDesignable
class StretchTableViewHeader: UIView {
    let imageView = UIImageView()

    private var imageViewHeight = NSLayoutConstraint()
    private var imageViewBottom = NSLayoutConstraint()
    private var containerViewHeight = NSLayoutConstraint()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initLayout()
    }

    private func initLayout() {
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageViewHeight = imageView.heightAnchor.constraint(equalTo: self.heightAnchor)
        imageViewBottom = imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        NSLayoutConstraint.activate([ imageViewBottom, imageViewHeight, self.widthAnchor.constraint(equalTo: imageView.widthAnchor) ])
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        containerViewHeight.constant = scrollView.contentInset.top
        let offsetY = -(scrollView.contentOffset.y + scrollView.contentInset.top)
        self.clipsToBounds = offsetY <= 0
        imageViewBottom.constant = offsetY >= 0 ? 0 : -offsetY / 2
        imageViewHeight.constant = max(offsetY + scrollView.contentInset.top, scrollView.contentInset.top)
    }

    func scrollViewDidScroll(offset: CGPoint, inset: UIEdgeInsets) {
        containerViewHeight.constant = inset.top
        let offsetY = -(offset.y + inset.top)
        self.clipsToBounds = offsetY <= 0
        imageViewBottom.constant = offsetY >= 0 ? 0 : -offsetY / 2
        imageViewHeight.constant = max(offsetY + inset.top, inset.top)
    }
}
