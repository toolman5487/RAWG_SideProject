import UIKit
import SnapKit
import Combine

final class SearchTabViewController: UIViewController {
    
    private let searchViewModel = SearchViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    var results: [GameSearchResult] = [] {
        didSet { tableView.reloadData() }
    }
    
    private lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.placeholder = "Search Games"
        controller.searchResultsUpdater = self
        return controller
    }()
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupTableView()
        setupBindings()
    }
    
    private func setupNavigation() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: "SearchResultCell")
        tableView.rowHeight = 80
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupBindings() {
        searchViewModel.$searchResults
            .receive(on: DispatchQueue.main)
            .sink { [weak self] results in
                self?.results = results
            }
            .store(in: &cancellables)
    }
}

extension SearchTabViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let query = searchController.searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        searchViewModel.searchGames(query: query)
    }
}

extension SearchTabViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath) as! SearchResultCell
        let item = results[indexPath.row]
        cell.configure(with: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedGame = results[indexPath.row]
        let gameDetailVC = GameDetailViewController(gameId: selectedGame.id)
        navigationController?.pushViewController(gameDetailVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

