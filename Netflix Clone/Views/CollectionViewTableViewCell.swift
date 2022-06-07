//
//  CollectionViewTableViewCell.swift
//  Netflix Clone
//
//  Created by Ahmed on 27/05/2022.
//

import UIKit

protocol CollectionViewTableViewCellDelegate: AnyObject {
    func collectionViewTableViewCellTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel)
}

class CollectionViewTableViewCell: UITableViewCell {

    static let id = "CollectionViewTableViewCell"
    
    private var titles: [Title] = []
    
    weak var delegete: CollectionViewTableViewCellDelegate?
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 140, height: 200)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.id)
        collection.backgroundColor = .systemBackground
        return collection
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemPink
        contentView.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    func configure(with titles: [Title]) {
        self.titles = titles
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    func dwonloadTitleAt(indexPath: IndexPath) {
        let title = titles[indexPath.row]
        DataPresistenceManager.shared.downloadTitleWith(model: title) { result in
            switch result {
                
            case .success():
                print("Downloaded")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}


extension CollectionViewTableViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.id, for: indexPath) as! TitleCollectionViewCell
        cell.configure(with: titles[indexPath.row].poster_path ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let title = titles[indexPath.row]
        guard let titleName = title.original_title ?? title.original_name else { return }
        APICaller.shared.getMovie(with: titleName + "trailer") { [weak self] result in
            switch result {
                
            case .success(let videoElement):
                let title = self?.titles[indexPath.row]
                guard let titleOverview = title?.overview else { return }
                let viewModel = TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: titleOverview)
                self?.delegete?.collectionViewTableViewCellTapCell(self!, viewModel: viewModel)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let actionProvider: UIContextMenuActionProvider = { _ in
            return UIMenu(title: "More", children: [
                UIAction(title: "Download", image: UIImage(systemName: "arrow.down.to.line"), identifier: nil, discoverabilityTitle: nil, state: .off, handler: { [weak self] _ in
                    self?.dwonloadTitleAt(indexPath: indexPath)
                })
            ])
        }
        
        return UIContextMenuConfiguration(identifier: "unique-ID" as NSCopying, previewProvider: nil, actionProvider: actionProvider)
    }
    
//    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
//        if #available(iOS 15.0, *) {
//            let config = UIContextMenuConfiguration(
//                identifier: nil,
//                previewProvider: nil) { _ in
//                    let downloadAction = UIAction(title: "Download", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { action in
//                        print("Dwonlaod tapped")
//                    }
//                    return UIMenu(title: "", subtitle: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
//                }
//            return config
//        }
//
//        return nil
//    }
    
}
