//
//  TitleTableViewCell.swift
//  Netflix Clone
//
//  Created by Ahmed on 31/05/2022.
//

import UIKit

class TitleTableViewCell: UITableViewCell {
    
    static let id = "TitleTableViewCell"
    
    
    private let playTitleBtn: UIButton = {
        let btn = UIButton()
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        btn.setImage(image, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 2
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let titlesPosterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titlesPosterImageView)
        contentView.addSubview(titleLbl)
        contentView.addSubview(playTitleBtn)
        
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            titlesPosterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            titlesPosterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            titlesPosterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            titlesPosterImageView.widthAnchor.constraint(equalToConstant: 100),
            
            playTitleBtn.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            playTitleBtn.widthAnchor.constraint(equalToConstant: 35),
            playTitleBtn.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            titleLbl.leadingAnchor.constraint(equalTo: titlesPosterImageView.trailingAnchor, constant: 20),
            titleLbl.trailingAnchor.constraint(equalTo: playTitleBtn.leadingAnchor, constant: -8),
            titleLbl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
        ])
    }
    
    func configure(with model: TitleViewModel) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500" + model.posterURL) else { return }
        titlesPosterImageView.sd_setImage(with: url, completed: nil)
        titleLbl.text = model.titleName
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.titlesPosterImageView.image = nil
    }
}
