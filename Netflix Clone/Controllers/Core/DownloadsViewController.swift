//
//  DownloadsViewController.swift
//  Netflix Clone
//
//  Created by Ahmed on 27/05/2022.
//

import UIKit
import CoreData

class DownloadsViewController: UIViewController {
    
    private var titles: [TitleItem] = []
    
    private let dwonloadTable: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.id)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        view.addSubview(dwonloadTable)
        dwonloadTable.dataSource = self
        dwonloadTable.delegate = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchTitlesFromDB()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        dwonloadTable.frame = view.bounds
    }
    
    private func fetchTitlesFromDB() {
        DataPresistenceManager.shared.fetchingTitlesFromDataBase { [weak self] result in
            guard let self = self else { return }
            switch result {
                
            case .success(let titles):
                self.titles = titles
                DispatchQueue.main.async {
                    self.dwonloadTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    


}


extension DownloadsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.id, for: indexPath) as! TitleTableViewCell
        let title = titles[indexPath.row]
        cell.configure(with: TitleViewModel(titleName: title.original_title ?? title.original_name ?? "Unknown title name", posterURL: title.poster_path ?? ""))
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
            
        case .delete:
            DataPresistenceManager.shared.deleteTitleWith(model: titles[indexPath.row]) { [weak self] result in
                switch result {
                case .success():
                    print("Deleted fromt the database")
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self?.titles.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
             }
         default:
            break
        }
    }
}
