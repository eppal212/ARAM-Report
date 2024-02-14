import UIKit

class ServerSelectCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    // CollectionView는 SelectionStyle이 없어서 직접 구현
    override var isHighlighted: Bool {
        willSet {
            if isHighlighted {
                UIView.animate(withDuration: 0.1) { [weak self] in
                    self?.alpha = 1.0
                }
            } else {
                UIView.animate(withDuration: 0.1) { [weak self] in
                    self?.alpha = 0.5
                }
            }
        }
    }
}
