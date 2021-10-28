//
// Copyright © 2021 GetYourGuide. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var reviews: [Review] = []
    var networkClient: NetworkClient = {
        let networkClient = NetworkClient()

        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        networkClient.jsonDecoder = jsonDecoder

        return networkClient
    }()

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.register(
            ReviewTableViewCell.self,
            forCellReuseIdentifier: ReviewTableViewCell.reuseID
        )

        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.pinEdges(to: view)

        fetchReviews()
    }

    func fetchReviews() {
        let url = URL(
            string: "https://travelers-api.getyourguide.com/activities/23776/reviews?offset=\(reviews.count)"
        )!

        _ = networkClient.run(
            URLRequest(url: url)
        ) { (result: Result<ReviewsResponse, NetworkError>) in
            switch result {
            case let.success(response):
                self.reviews.append(contentsOf: response.reviews)
            case let .failure(error):
                print(error)
            }

            self.tableView.reloadData()
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        reviews.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ReviewTableViewCell.reuseID
        ) as! ReviewTableViewCell
        cell.configure(with: reviews[indexPath.row])

        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == reviews.count - 5 {
            fetchReviews()
        }
    }
}
