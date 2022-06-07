//
//  HomeViewController.swift
//  Netflix Clone
//
//  Created by Ahmed on 27/05/2022.
//

import UIKit

enum Sections: Int {
    case TrendingMovies = 0
    case TrendingTv = 1
    case Popular = 2
    case Upcomong = 3
    case TopRated = 4
}

class HomeViewController: UIViewController {
    
    private var randomTitleMovie: Title? {
        didSet {
            headerView?.configure(with: TitleViewModel(titleName: randomTitleMovie?.original_name ?? "Unknown", posterURL: randomTitleMovie?.poster_path ?? ""))
        }
    }
    private var headerView: HeroHeaderUIView?
    
    let sectionTitles: [String] = ["Trending Movie", "Popular", "Trending Tv", "Upcoming Movies", "Top Rated"]
    
    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.id)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(homeFeedTable)
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
        configureNavigationBar()
        
        headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        homeFeedTable.tableHeaderView = headerView
        configureHeroHeaderView()
        
        fetchData()
        
    }
    
    private func configureHeroHeaderView() {
        APICaller.shared.getTrendingMovies { [weak self] result in
            switch result {
                
            case .success(let titles):
                self?.randomTitleMovie = titles.randomElement()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
    
    private func configureNavigationBar() {
        let img = UIImage(named: "netflixLogo")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: img, style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .label
    }
    
    private func fetchData() {
//        navigationController?.pushViewController(TitlePreviewViewController(), animated: true)
    }
    
    
}


extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.id, for: indexPath) as! CollectionViewTableViewCell
        cell.delegete = self
        let currentScetion = Sections(rawValue: indexPath.section)!
        
        switch currentScetion {
        case .TrendingMovies:
            APICaller.shared.getUpcomingMovies { result in
                switch result {
                    
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                    cell.configure(with: [])
                }
            }
        case .TrendingTv:
            APICaller.shared.getTrendingTvs { result in
                switch result {
                    
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                    cell.configure(with: [])
                }
            }
        case .Popular:
            APICaller.shared.getPopular { result in
                switch result {
                    
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                    cell.configure(with: [])
                }
            }
        case .Upcomong:
            APICaller.shared.getUpcomingMovies { result in
                switch result {
                    
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                    cell.configure(with: [])
                }
            }
        case .TopRated:
            APICaller.shared.getTopRated { result in
                switch result {
                    
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                    cell.configure(with: [])
                }
            }
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .label
        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLatter()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defualtOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y - defualtOffset
        navigationController?.navigationBar.transform = .init(translationX: 0.0, y: min(0, -offset))
    }
}


extension HomeViewController: CollectionViewTableViewCellDelegate {
    func collectionViewTableViewCellTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}
