//
//  SearchResultViewController.swift
//  Netflix Clone
//
//  Created by Ahmed on 03/06/2022.
//

import UIKit

protocol SearchResultViewControllerDelegate: AnyObject {
    func searchResultViewControllerDidTapItem(_ viewModel: TitlePreviewViewModel)
}

class SearchResultViewController: UIViewController {
    
    public var titles: [Title] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in self?.searchResultsController.reloadData() }
        }
    }
    
    private let searchResultsController: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width / 3 - 10
        layout.itemSize = CGSize(width: width, height: 200)
        layout.minimumInteritemSpacing = 0
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.id)
        return collection
    }()
    
    weak var delegate: SearchResultViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(searchResultsController)
        searchResultsController.delegate = self
        searchResultsController.dataSource = self
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        searchResultsController.frame = view.bounds
    }
    


}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.id, for: indexPath) as! TitleCollectionViewCell
        cell.configure(with: titles[indexPath.row].poster_path ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let title = titles[indexPath.row]
        guard let name = title.original_name ?? title.original_title else { return }
        
        APICaller.shared.getMovie(with: name) { [weak self] result in
            switch result {
            
            case .success(let element):
                self?.delegate?.searchResultViewControllerDidTapItem(TitlePreviewViewModel(title: name, youtubeView: element, titleOverview: title.overview ?? ""))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}
