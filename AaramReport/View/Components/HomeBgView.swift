//
//  HomeBgView.swift
//  AaramReport
//
//  Created by OBeris on 2/4/24.
//

import UIKit
import AVFoundation

@IBDesignable
class HomeBgView: UIView {
    let ovelayDim = UIView()
    @IBInspectable var overlayOpacity: CGFloat = 0 { // 동영상 위에 오버레이 되는 Dim 투명도
        didSet {
            ovelayDim.backgroundColor = UIColor(white: 0, alpha: overlayOpacity)
        }
    }
    @IBInspectable var videoName: String = "" // 재생할 비디오 이름
    @IBInspectable var videoExtension: String = "mp4"

    let playerLayer = AVPlayerLayer() // 동영상을 재생할 레이어
    var playerLooper: AVPlayerLooper? // 동영상 반복 (이곳에 선언 안 하면 동작 안 함)

    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = self.frame
    }

    // UI 초기화
    func initView() {
        // 동영상 세팅
        guard let videoFile = Bundle.main.url(forResource: videoName, withExtension: videoExtension) else { return }
        let playerItem = AVPlayerItem(url: videoFile)
        let queuePlayer = AVQueuePlayer(playerItem: playerItem)
        playerLayer.player = queuePlayer
        self.layer.addSublayer(playerLayer)
        playerLooper = AVPlayerLooper(player: queuePlayer, templateItem: playerItem)
        queuePlayer.play()

        // Dim 세팅
        self.addSubview(ovelayDim)
        ovelayDim.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ovelayDim.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            ovelayDim.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            ovelayDim.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            ovelayDim.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0)])
    }

}
