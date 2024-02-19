import Foundation
import RxSwift

class DataDragon {
    static let `default`: DataDragon = {
        return DataDragon()
    }()

    private var version: String = ""
    private var spellMetadata: SpellMetadata?

    private let disposeBag = DisposeBag()

    // MARK: - Metadata
    // 최신 버전 획득
    func getLatestVersion(onError: @escaping () -> Void) {
        if version.isEmpty {
            ApiClient.default.getVersion().subscribe(onNext: { [weak self] versions in
                guard let version = versions.first else { return }
                self?.version = version
                self?.getMetadata()
            }, onError: { _ in
                onError()
            }).disposed(by: disposeBag)
        }
    }

    // DDragon 메타데이터 세팅
    private func getMetadata() {
        ApiClient.default.getSpellMetadata(version: version).subscribe(onNext: { [weak self] data in
            self?.spellMetadata = data
        }).disposed(by: disposeBag)
    }

    // MARK: - Data from ID
    //
    func getProfileImageUrl(id: Int?) -> URL? {
    https://ddragon.leagueoflegends.com/cdn/14.3.1/img/profileicon/588.png
    }

    // 소환사 주문 이미지 url 반환
    func getSpellImageUrl(id: Int?) -> URL? {
        var path = Const.dataDragon + "cdn/\(version)/img/spell/"
        for (_, data) in spellMetadata?.data?.asDictionary ?? [:] where data?.key == String(id ?? 0) {
            path += data?.image?.full ?? ""
        }
        return URL(string: path)
    }
}
