import UIKit
import RxSwift
import RxCocoa
import Toast
import FloatingPanel

class HomeViewController: UIViewController {

    @IBOutlet weak var nickRememberButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var serverButton: UIButton!
    @IBOutlet weak var nicknameInput: UITextField!
    @IBOutlet weak var tagInput: UITextField!

    private let rememberNickRelay = PublishRelay<Bool>() // 닉네임 기억 여부 Relay
    private let serverRelay = BehaviorRelay<RiotServer>(value: RiotServer.data[0]) // 검색 서버 Relay
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        initBinding()
        initLayout()
    }

    private func initBinding() {
        // 닉네임 기억 버튼 취소선 그리기 구독
        rememberNickRelay.subscribe(onNext: { [weak self] flag in
            guard let attributeText = self?.nickRememberButton.titleLabel?.attributedText else { return }
            let attr = NSMutableAttributedString(attributedString: attributeText)
            if flag {
                attr.removeAttribute(.strikethroughStyle, range: NSMakeRange(0, attr.length))
            } else {
                attr.addAttribute(.strikethroughStyle,
                                  value: NSUnderlineStyle.single.rawValue,
                                  range: NSMakeRange(0, attr.length))
            }
            self?.nickRememberButton.setAttributedTitle(attr, for: .normal)

        }).disposed(by: disposeBag)

        // 서버 버튼 바인딩
        serverRelay.map({ $0.code }).bind(to: serverButton.rx.title()).disposed(by: disposeBag)
    }

    private func initLayout() {
        self.hideKeyboardWhenTappedAround() // 백그라운드 터치시 키보드 닫기

        // Label UI 조정
        titleLabel.setAutoKerning()
        subtitleLabel.setAutoKerning(minusValue: 10)
        serverButton.configuration?.contentInsets = .zero

        // 닉네임 기억 설정여부에 따라서 기억중인 닉네임 TextField에 세팅
        let isRememberNick = UserDefaults.standard.string(forKey: Const.useNickRememberKey) == "Y"
        if isRememberNick {
            nicknameInput.text = UserDefaults.standard.string(forKey: Const.savedNicknameKey) ?? ""
            tagInput.text = UserDefaults.standard.string(forKey: Const.savedTagKey) ?? ""
        }
        rememberNickRelay.accept(isRememberNick) // 버튼 취소선 반영
    }

    // MARK: - Button Action
    // 최근 검색 닉네임 기억 on/off 처리
    @IBAction func onClickSave(_ sender: UIButton) {
        // 닉네임 기억 여부 저장
        let useNickRemember = UserDefaults.standard.string(forKey: Const.useNickRememberKey) == "Y"
        UserDefaults.standard.set(useNickRemember ? "N" : "Y", forKey: Const.useNickRememberKey)

        rememberNickRelay.accept(!useNickRemember) // 변경사항 버튼 반영
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

            let viewController = ServerSelectBottomSheet(coder: creater) { [weak self] server in
                // 서버 Item 선택 이벤트
                self?.serverRelay.accept(server)
                bottomSheet.dismiss(animated: true)
            }
            return viewController

        }) as? ServerSelectBottomSheet else { return }

        bottomSheet.setContentVC(contentVC: contentVC, layout: contentVC)
        self.present(bottomSheet, animated: true)
    }

    // 검색 버튼 클릭
    @IBAction func onClickSearch(_ sender: UIButton) {
        // 입력 정보 확인
        if let nickname =  nicknameInput.text, !nickname.isEmpty, let tag = tagInput.text, !tag.isEmpty {
            // 계정 확인
            ApiClient.default.getAccount(gameName: nickname, tagLine: tag).subscribe(onNext: { [weak self] account in

                // MatchListViewController로 이동
                guard let matchListVC = self?.storyboard?.instantiateViewController(withIdentifier: "MatchListViewController") as? MatchListViewController else { return }
                matchListVC.setAccountData(accountData: account, server: self?.serverRelay.value)
                self?.navigationController?.pushViewController(matchListVC, animated: true)

            }, onError: { [weak self] _ in
                self?.view.makeToast("올바른 서버, 닉네임, 태그를 입력해 주세요.")
            }).disposed(by: disposeBag)

            // 검색 닉네임 저장
            UserDefaults.standard.set(nickname, forKey: Const.savedNicknameKey)
            UserDefaults.standard.set(tag, forKey: Const.savedTagKey)
        } else {
            self.view.makeToast("닉네임과 태그를 입력해주세요.")
        }
    }
}
