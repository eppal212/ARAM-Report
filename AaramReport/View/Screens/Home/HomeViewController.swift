import UIKit
import Toast
import FloatingPanel

class HomeViewController: UIViewController {

    @IBOutlet weak var nickRememberButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var serverButton: UIButton!
    @IBOutlet weak var nicknameInput: UITextField!
    @IBOutlet weak var tagInput: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        initLayout()
    }

    private func initLayout() {
        self.hideKeyboardWhenTappedAround()

        // Label UI 조정
        titleLabel.setAutoKerning()
        subtitleLabel.setAutoKerning(minusValue: 10)
        serverButton.configuration?.contentInsets = .zero

        // 기억중인 닉네임 세팅
        if UserDefaults.standard.string(forKey: Const.useNickRememberKey) == "Y" {
            nicknameInput.text = UserDefaults.standard.string(forKey: Const.savedNicknameKey) ?? ""
            tagInput.text = UserDefaults.standard.string(forKey: Const.savedTagKey) ?? ""
        }
    }

    // 최근 검색 닉네임 기억 on/off 처리
    @IBAction func onClickSave(_ sender: UIButton) {
        // 여부 저장
        let useNickRemember = UserDefaults.standard.string(forKey: Const.useNickRememberKey) == "Y"
        UserDefaults.standard.set(useNickRemember ? "N" : "Y", forKey: Const.useNickRememberKey)

        // 취소선 반영
        if let attributeText = nickRememberButton.titleLabel?.attributedText {
            let attr = NSMutableAttributedString(attributedString: attributeText)
            if useNickRemember {
                attr.addAttribute(.strikethroughStyle,
                                  value: NSUnderlineStyle.single.rawValue,
                                  range: NSMakeRange(0, attr.length))
            } else {
                attr.removeAttribute(.strikethroughStyle, range: NSMakeRange(0, attr.length))
            }
            nickRememberButton.setAttributedTitle(attr, for: .normal)
        }
    }

    // 라이엇 홈페이지로 이동
    @IBAction func onClickRiotApi(_ sender: UIButton) {
        guard let url = URL(string: Const.riotApi) else {return }
        UIApplication.shared.open(url)
    }

    // 서버 선택 버튼 클릭
    @IBAction func onClickServer(_ sender: UIButton) {
        let bottomSheet = BottomSheetView()
        guard let contentVC = storyboard?.instantiateViewController(identifier: "ServerSelectBottomSheet", creator: { creater in
            let viewController = ServerSelectBottomSheet(coder: creater) { [weak self] serverName in
                self?.serverButton.setTitle(serverName, for: .normal)
                bottomSheet.dismiss(animated: true)
            }
            return viewController
        }) as? ServerSelectBottomSheet else { return }
        bottomSheet.setContentVC(contentVC: contentVC, layout: contentVC)
        self.present(bottomSheet, animated: true)
    }

    // 검색 버튼 클릭
    @IBAction func onClickSearch(_ sender: UIButton) {
        if let nickname =  nicknameInput.text, !nickname.isEmpty, let tag = tagInput.text, !tag.isEmpty {
            // TODO: 검색 로직
            // 어카운트1 한 다음에 서머너4

            // 검색 닉네임 저장
            UserDefaults.standard.set(nickname, forKey: Const.savedNicknameKey)
            UserDefaults.standard.set(tag, forKey: Const.savedTagKey)
        } else {
            self.view.makeToast("닉네임과 태그를 입력해주세요.")
        }
    }
}

