//
//  SearchViewController.swift
//  Netflix Clone
//
//  Created by Ahmed on 27/05/2022.
//

import UIKit

class SearchViewController: UIViewController {
    
    private var titles: [Title] = []
    
    private let discoverTable: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.id)
        return table
    }()
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultViewController())
        controller.searchBar.placeholder = "Search for a Movie or Tv show"
        controller.searchBar.searchBarStyle = .minimal
        controller.searchBar.tintColor = .label
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        
        view.addSubview(discoverTable)
        discoverTable.delegate = self
        discoverTable.dataSource = self
        
        navigationItem.searchController = searchController
        
        searchController.searchResultsUpdater = self
        
        fetchDiscover()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTable.frame = view.bounds
    }
    
    func fetchDiscover() {
        APICaller.shared.getDiscoverMovies { [weak self] result in
            switch result {
                
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async { self?.discoverTable.reloadData() }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.id, for: indexPath) as! TitleTableViewCell
        let title = titles[indexPath.row]
        cell.configure(with: TitleViewModel(titleName: title.original_title ?? title.original_name ?? "Unknown", posterURL: title.poster_path ?? ""))
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        guard let name = title.original_name ?? title.original_title else { return }
        
        APICaller.shared.getMovie(with: name) { [weak self] result in
            switch result {
            
            case .success(let element):
                DispatchQueue.main.async {
                    let vc = TitlePreviewViewController()
                    vc.configure(with: TitlePreviewViewModel(title: name, youtubeView: element, titleOverview: title.overview ?? ""))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
}


extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let resultController = searchController.searchResultsController as? SearchResultViewController else { return }
        resultController.delegate = self
        guard let query = searchBar.text?.trimmingCharacters(in: .whitespaces) else { return }
        if !query.isEmpty, query.count >= 3 {
            APICaller.shared.search(with: query) { result in
                switch result {
                    
                case .success(let titles):
                    resultController.titles = titles
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

extension SearchViewController: SearchResultViewControllerDelegate {
    func searchResultViewControllerDidTapItem(_ viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}
