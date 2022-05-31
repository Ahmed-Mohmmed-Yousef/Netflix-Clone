//
//  UpcomingViewController.swift
//  Netflix Clone
//
//  Created by Ahmed on 27/05/2022.
//

import UIKit

class UpcomingViewController: UIViewController {

    private var titles: [Title] = []
    private let upcomingTable: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        
        
        view.addSubview(upcomingTable)
        upcomingTable.delegate = self
        upcomingTable.dataSource = self
        
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTable.frame = view.bounds
    }
    
    
    private func fetchData() {
        APICaller.shared.getUpcomingMovies { [weak self] result in
            switch result {
                
            case .success(let title):
                self?.titles = title
                DispatchQueue.main.async { self?.upcomingTable.reloadData() }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}


extension UpcomingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = titles[indexPath.row].original_name ?? titles[indexPath.row].original_title ?? "Unkown"
        return cell
    }
    
    
}
