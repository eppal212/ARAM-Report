//
//  MainViewController.swift
//  AaramReport
//
//  Created by OBeris on 2/3/24.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {

    @IBOutlet weak var topTitleLabel: UILabel!
    @IBOutlet weak var bottomTitleLabel: UILabel!

    let server = BehaviorRelay<String>(value: "")
    let nickname = BehaviorRelay<String>(value: "")
    let tag = BehaviorRelay<String>(value: "")

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initBind()
    }

    func initView() {
        topTitleLabel.setAutoKerning()
        bottomTitleLabel.setAutoKerning(minusValue: 10)
    }

    func initBind() {
        // 서버 선택 바인드
        // 닉네이 & 태그 입력 바인드
    }

    // 최근 검색 닉네임 저장 on/off 처리
    func toggleSave() {

    }

    // 라이엇 홈페이지로 이동
    func onClickRiotApi() {

    }

    // 검색 버튼 클릭
    func onClickSearch() {

    }
}

