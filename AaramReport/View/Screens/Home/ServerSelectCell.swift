import UIKit

class ServerSelectCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    var data: RiotServer? { // 서버 정보
        didSet {
            guard let data = data else { return }
            nameLabel.text = data.code
            imageView.sd_setImage(with: URL(string: data.url))
        }
    }

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
