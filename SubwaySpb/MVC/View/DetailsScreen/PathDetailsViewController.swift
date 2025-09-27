import UIKit

final class PathDetailsViewController: UITableViewController {
    private var dataArr = [String]()
    private let pathDetails: [String]

    init(pathDetails: [String]) {
        self.pathDetails = pathDetails
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var pathList: UITableView = {
        let list = UITableView()
        list.register(PathCell.self, forCellReuseIdentifier: "cell")
        list.delegate = self
        list.dataSource = self
        list.rowHeight = UITableView.automaticDimension
        list.estimatedRowHeight = 10
        list.separatorStyle = .none
        list.frame = view.bounds
        return list
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .white
        view.addSubview(pathList)
        pathDetails.isEmpty ? dataArr.append("🚇 Машинист отдыхает... 💤") : (dataArr = pathDetails)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        super.tableView(tableView, cellForRowAt: indexPath)
        guard let cell = pathList.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PathCell else {
            return UITableViewCell(frame: .zero)
        }
        cell.stationLabel.text = dataArr[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        super.tableView(tableView, numberOfRowsInSection: section)
        return dataArr.count
    }
}
