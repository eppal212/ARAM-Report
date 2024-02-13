import Foundation
import UIKit

class ServerSelectBottomSheet: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    private var selectHandler: ((String) -> Void)?
    private let columnCount = 4 // 열 갯수
    private let cellSpacing = 10 // 셀 간격

    init?(onClickServer: @escaping (String) -> Void, coder: NSCoder) {
        super.init(coder: coder)
        selectHandler = onClickServer
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ServerSelectBottomSheet: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return RiotServer.data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServerSelectCell", for: indexPath)
        if let serverSelectCell = cell as? ServerSelectCell {
            serverSelectCell.nameLabel?.text = RiotServer.data[indexPath.row].id
        }
        return cell
    }
}

extension ServerSelectBottomSheet: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectHandler?(RiotServer.data[indexPath.row].id)
    }
}

extension ServerSelectBottomSheet: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // width : collectionView 너비에서 좌우마진, 셀 사이 공간을 빼고 셀 갯수로 나눈 값
        let gap = CGFloat(columnCount + 1)
        let width = (self.view.frame.size.width - CGFloat(cellSpacing) * gap) / CGFloat(columnCount)
        return CGSize(width: width, height: width)
    }
}
