//
//  MainViewModel.swift
//  AaramReport
//
//  Created by OBeris on 2/11/24.
//

import Foundation
import RxSwift
import RxCocoa

class MainViewModel: NSObject {
    let server = BehaviorSubject<String>(value: "")
    let nickname = BehaviorSubject<String>(value: "")
    let tag = BehaviorSubject<String>(value: "")

}
