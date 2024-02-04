//
//  MainViewController.swift
//  AaramReport
//
//  Created by OBeris on 2/3/24.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var topTitleLabel: UILabel!
    @IBOutlet weak var bottomTitleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }

    func initView() {
        topTitleLabel.setAutoKerning()
        bottomTitleLabel.setAutoKerning()
    }
}

