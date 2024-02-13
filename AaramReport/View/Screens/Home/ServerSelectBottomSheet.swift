import Foundation
import UIKit

class ServerSelectBottomSheet: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    var selectHandler: ((String) -> Void)?

    init?(onClickServer: @escaping (String) -> Void, coder: NSCoder) {
        super.init(coder: coder)
        selectHandler = onClickServer
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "RiotServerCell")
    }
}

extension ServerSelectBottomSheet: UITableViewDataSource, UITabBarDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RiotServerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RiotServerCell", for: indexPath)
        cell.textLabel?.text = RiotServerList[indexPath.row].id
        return cell
    }
}
