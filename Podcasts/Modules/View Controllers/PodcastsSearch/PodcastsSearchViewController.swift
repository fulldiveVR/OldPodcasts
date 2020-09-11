//
//  PodcastsSearchController.swift
//  Podcasts
//
//  Created by Eugene Karambirov on 21/09/2018.
//  Copyright © 2018 Eugene Karambirov. All rights reserved.
//

import UIKit

final class PodcastsSearchViewController: UITableViewController {

    // MARK: - Properties
    private var viewModel: PodcastsSearchViewModel
    private lazy var searchController = UISearchController(searchResultsController: nil)

    // MARK: - View Controller's life cycle
    init(viewModel: PodcastsSearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationItem.hidesSearchBarWhenScrolling = false
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        navigationItem.hidesSearchBarWhenScrolling = true
        super.viewDidAppear(animated)
    }
}

private extension PodcastsSearchViewController {

    func searchPodcasts(with searchText: String) {
        viewModel.searchPodcasts(with: searchText) { [weak self] in
            self?.tableView.dataSource = self?.viewModel.dataSource
            self?.tableView.reloadData()
        }
    }
}

// MARK: - UITableView
extension PodcastsSearchViewController {

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Sizes.cellHeight
    }

    // MARK: Header Setup
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        makeEmptyStateView()
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let height = Sizes.headerHeight(for: tableView)
        return viewModel.podcasts.isEmpty
            && searchController.searchBar.text?.isEmpty == true ? height : 0
    }

    // MARK: Footer Setup
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        PodcastsSearchingView()
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        viewModel.podcasts.isEmpty
            && searchController.searchBar.text?.isEmpty == false ? Sizes.footerHeight : 0
    }

    // MARK: Navigation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let podcast = viewModel.podcast(for: indexPath)
        let episodesViewModel = EpisodesViewModel(
            podcast: podcast,
            podcastsService: viewModel.podcastsService,
            playerService: viewModel.playerService
        )
        let episodesController = EpisodesViewController(viewModel: episodesViewModel)
        navigationController?.pushViewController(episodesController, animated: true)
    }
}

// MARK: - UISearchBarDelegate
extension PodcastsSearchViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchPodcasts(with: searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.deleteLoadedPodcasts()
        tableView.reloadData()
    }
}

// MARK: - Setup
private extension PodcastsSearchViewController {

    func initialSetup() {
        view.backgroundColor = .white
        setupNavigationBar()
        setupSearchBar()
        setupTableView()
    }

    func makeEmptyStateView() -> UIView {
        let label = UILabel()
        label.text = Strings.enterSearchTermMessage
        label.textAlignment = .center
        label.textColor = .purple
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }

    func setupNavigationBar() {
        navigationItem.searchController = searchController
        title = Strings.title
    }

    func setupSearchBar() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.definesPresentationContext = true
        searchController.searchBar.placeholder = Strings.searchBarPlaceholder
        searchController.searchBar.delegate = self
    }

    func setupTableView() {
        tableView.register(PodcastCell.self, forCellReuseIdentifier: PodcastCell.typeName)
        tableView.dataSource = viewModel.dataSource
        tableView.tableFooterView = UIView()
    }
}

private extension PodcastsSearchViewController {

    enum Strings {
        static let podcastsSearchingView = "PodcastsSearchingView"
        static let enterSearchTermMessage = "Please, enter a search term."
        static let searchBarPlaceholder = "Search"
        static let title = "Search"
    }

    enum Sizes {
        static let cellHeight: CGFloat = 132
        static let footerHeight: CGFloat = 200

        static func headerHeight(for tableView: UITableView) -> CGFloat {
            tableView.bounds.height / 2
        }
    }
}
