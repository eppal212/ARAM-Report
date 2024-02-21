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
