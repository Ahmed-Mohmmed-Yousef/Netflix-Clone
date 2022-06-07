//
//  HeroHeaderUIView.swift
//  Netflix Clone
//
//  Created by Ahmed on 27/05/2022.
//

import UIKit
import SDWebImage

class HeroHeaderUIView: UIView {
    
    private let downloadBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Download", for: .normal)
        btn.layer.borderColor = UIColor.white.cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 5
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let playBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Play", for: .normal)
        btn.layer.borderColor = UIColor.white.cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 5
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private let heroImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "heroImage")
        return imageView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(heroImageView)
        addGradint()
        addSubview(playBtn)
        addSubview(downloadBtn)
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        heroImageView.frame = bounds
    }
    
    private func addGradint() {
        let gradiant = CAGradientLayer()
        gradiant.colors = [UIColor.clear.cgColor, UIColor.systemBackground.cgColor]
        gradiant.frame = bounds
        layer.addSublayer(gradiant)
    }
    
    private func applyConstraints() {
        let playBtnConstraints = [
            playBtn.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 60),
            playBtn.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            playBtn.widthAnchor.constraint(equalToConstant: 120)
        ]
        
        let downloadBtnConstraints = [
            downloadBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -60),
            downloadBtn.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            downloadBtn.widthAnchor.constraint(equalToConstant: 120)
        ]
        
        NSLayoutConstraint.activate(playBtnConstraints)
        NSLayoutConstraint.activate(downloadBtnConstraints)
    }
    
    func configure(with model: TitleViewModel) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500" + model.posterURL) else { return }
        heroImageView.sd_setImage(with: url, completed: nil)
    }

}
