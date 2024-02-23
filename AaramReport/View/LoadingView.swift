import Foundation
import UIKit
import Lottie

class LoadingView: UIView {

    private let bgImage = UIImageView()
    private let animationView = LottieAnimationView(name: "loading")

    override init(frame: CGRect) {
        super.init(frame: frame)
        initLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initLayout()
    }

    private func initLayout() {
        // 배경 이미지
        self.addSubview(bgImage)
        bgImage.image = UIImage(named: "clientBg")
        bgImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bgImage.topAnchor.constraint(equalTo: self.topAnchor),
            bgImage.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            bgImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bgImage.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])

        // 로티 애니메이션
        self.addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            animationView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.75),
        ])
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.5
        animationView.play()
    }

    func remove() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) { [weak self] in
            UIView.animate(withDuration: 0.3) {
                self?.alpha = 0
            } completion: { _ in
                self?.removeFromSuperview()
            }
        }
    }
}
