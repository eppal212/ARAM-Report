import Foundation
import FloatingPanel
import UIKit
import SDWebImage
import SDWebImageSVGCoder

class ServerSelectBottomSheet: UIViewController {

    @IBOutlet weak var collectionViewLeading: NSLayoutConstraint!
    @IBOutlet weak var collectionViewTrailing: NSLayoutConstraint!

    private var selectHandler: ((String) -> Void)? // 셀 클릭 이벤트

    private let columnCount = 3 // 열 갯수
    private let cellSpacing = 10 // 셀 간격
    private let cellHeight = 60 // 셀 높이

    init?(coder: NSCoder, onClickServer: @escaping (String) -> Void) {
        super.init(coder: coder)
        selectHandler = onClickServer
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let SVGCoder = SDImageSVGCoder.shared
        SDImageCodersManager.shared.addCoder(SVGCoder)
    }
}

// CollectionView 관련
extension ServerSelectBottomSheet: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return RiotServer.data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServerSelectCell", for: indexPath)
        if let serverSelectCell = cell as? ServerSelectCell {
            serverSelectCell.nameLabel?.text = RiotServer.data[indexPath.row].code
            serverSelectCell.imageView.sd_setImage(with: URL(string: RiotServer.data[indexPath.row].url))
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectHandler?(RiotServer.data[indexPath.row].code)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // width 계산 : collectionView 너비에서 좌우마진, 셀 사이 공간을 빼고 셀 갯수로 나눈 값
        let margin = collectionViewLeading.constant + collectionViewTrailing.constant
        let gap = CGFloat(cellSpacing) * CGFloat(columnCount + 1)
        let width = (self.view.frame.size.width - gap - margin) / CGFloat(columnCount)
        return CGSize(width: width, height: CGFloat(cellHeight))
    }
}

// FloatingPanelLayout 속성
extension ServerSelectBottomSheet: FloatingPanelLayout {
    var position: FloatingPanel.FloatingPanelPosition { .bottom }

    var initialState: FloatingPanel.FloatingPanelState { .tip }

    var anchors: [FloatingPanel.FloatingPanelState : FloatingPanel.FloatingPanelLayoutAnchoring] {
        [ .tip: FloatingPanelLayoutAnchor(absoluteInset: 410, edge: .bottom, referenceGuide: .safeArea) ]
    }
}
