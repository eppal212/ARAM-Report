import Foundation
import os.log

// 일반적인 로그 출력
func print(_ message: String,
           prefixe: String = "ASDF",
           functionName: String = #function,
           fileName: String = #file,
           lineNumber: Int = #line) {

    let logString = "[\(prefixe)] \(message)"

#if DEBUG
    os_log("%{public}@", type: .default, logString)
#endif
}

// 디버그 정보를 더한 로그 출력
func printd(_ message: String?,
            type: OSLogType = .default,
            functionName: String = #function,
            fileName: String = #file,
            lineNumber: Int = #line) {

    let className = (fileName as NSString).lastPathComponent
    let logString = "[\(className)|\(functionName):#\(lineNumber)] \(message ?? "")"

#if DEBUG
    os_log("%{public}@", type: .default, logString)
#endif
}
