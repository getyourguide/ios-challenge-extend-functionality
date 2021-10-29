//
// Copyright © 2021 GetYourGuide. All rights reserved.
//

import Combine
import UIKit

enum Section: CaseIterable {
    case reviews
}

final class ReviewsViewController: UIViewController {
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 150
        tableView.register(
            ReviewTableViewCell.self,
            forCellReuseIdentifier: ReviewTableViewCell.reuseID
        )

        return tableView
    }()

    private lazy var dataSource = UITableViewDiffableDataSource<Section, ReviewViewModel>(
        tableView: tableView,
        cellProvider: { tableView, indexPath, viewModel in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ReviewTableViewCell.reuseID
            ) as? ReviewTableViewCell
            cell?.configure(with: viewModel)

            return cell
        }
    )

    private let viewModel: ReviewsViewModelProtocol
    private var disposeBag = Set<AnyCancellable>()

    init(viewModel: ReviewsViewModelProtocol) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)

        setUp()
        bindToViewModel()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.send(.viewLoaded)
    }

    private func setUp() {
        tableView.dataSource = dataSource
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.pinEdges(to: view)
    }

    private func bindToViewModel() {
        viewModel.viewState
            .sink { [weak self] viewState in
                self?.update(with: viewState.reviewViewModels)
            }
            .store(in: &disposeBag)
    }

    private func update(with viewModels: [ReviewViewModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ReviewViewModel>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(viewModels, toSection: .reviews)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension ReviewsViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        viewModel.send(
            .willDisplayCell(indexPath: indexPath)
        )
    }
}
