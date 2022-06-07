//
//  CompositionalLayoutViewController.swift
//  Netflix Clone
//
//  Created by Ahmed on 06/06/2022.
//

import UIKit

class CompositionalLayoutViewController: UIViewController {
    
    static func instance() -> Self {
        let sb = UIStoryboard(name: "CompositionalLayoutViewController", bundle: .main)
        let vc = sb.instantiateViewController(withIdentifier: "CompositionalLayoutViewController") as! Self
        return vc
    }

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.collectionViewLayout = layout()
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.2),
            heightDimension: .fractionalHeight(1.0)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(50)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .flexible(20)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 50
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 200
        layout.configuration = config
        return layout
    }
    

}


extension CompositionalLayoutViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCollectionViewCell.id, for: indexPath) as! MyCollectionViewCell
        cell.lbl.text = "\(indexPath.item)"
        cell.backgroundColor = .systemPink
        return cell
    }
    
    
}
