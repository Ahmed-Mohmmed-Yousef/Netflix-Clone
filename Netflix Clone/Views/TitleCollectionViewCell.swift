//
//  TitleCollectionViewCell.swift
//  Netflix Clone
//
//  Created by Ahmed on 31/05/2022.
//

import SDWebImage
import UIKit

class TitleCollectionViewCell: UICollectionViewCell {
    
    
    static let id = "TitleCollectionViewCell"
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(with model: String) {
        guard let url = URL(string: model) else { return }
        posterImageView.sd_setImage(with: url, completed: nil)
    }
    
}
