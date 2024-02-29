import Foundation
import UIKit
import Toast

// 토스트 메시지 출력
func showToast(_ message: String) {
    guard let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene else { return }

    var style = ToastStyle()
    style.messageAlignment = .center

    let keyWindow = scene.windows.first(where: { $0.isKeyWindow })
    keyWindow?.rootViewController?.view.makeToast(message, style: style)
}

// API 데이터로 간이 mmr 계산
func getMmr(tier: String?, rank: String?) -> Int {
    guard let tier = tier else { return -1 }
    let rankStr = tier == "MASTER" || tier == "GRANDMASTER" || tier == "CHALLENGER" ? "" : (" \(rank ?? "")")
    return Mmr[tier + rankStr] ?? -1
}

// 간이 mmr로 근사값 Tier 반환
func getTierFromMmr(mmr: Int, skipRank: Bool) -> String {
    let value = round(CGFloat(mmr) / 100.0) * 100
    let key = Mmr.allKeys(forValue: Int(value)).first
    let tier = skipRank ? key?.components(separatedBy: " ").first : key
    return tier ?? ""
}
