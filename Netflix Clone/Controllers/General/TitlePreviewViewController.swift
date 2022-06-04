//
//  TitlePreviewViewController.swift
//  Netflix Clone
//
//  Created by Ahmed on 03/06/2022.
//

import UIKit
import WebKit

class TitlePreviewViewController: UIViewController {

    
    private let titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: 22, weight: .bold)
        lbl.text = "Harry potter"
        return lbl
    }()
    
    private let overviewLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: 18, weight: .regular)
        lbl.numberOfLines = 0
        lbl.text = "Harry potter is movie nice ............"
        return lbl
    }()
    
    private let downloadBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .red
        btn.setTitle("Download", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 8
        btn.layer.masksToBounds = true
        return btn
    }()
    
    private let webView: WKWebView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false   
        view.addSubview(downloadBtn)
        view.addSubview(overviewLbl)
        view.addSubview(titleLbl)
        
        configureConstrains()
    }
    
    private func configureConstrains() {
        NSLayoutConstraint.activate([
        
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: 200),
            
            titleLbl.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 15),
            titleLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            overviewLbl.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 15),
            overviewLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            overviewLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            downloadBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            downloadBtn.topAnchor.constraint(equalTo: overviewLbl.bottomAnchor, constant: 25),
            downloadBtn.widthAnchor.constraint(equalToConstant: 140),
            downloadBtn.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    public func configure(with model: TitlePreviewViewModel) {
        titleLbl.text = model.title
        overviewLbl.text = model.titleOverview
        
        guard let url = URL(string: "https://www.youtube.com/embed/\(model.youtubeView.id.videoId)") else {
            return
        }
        
        webView.load(URLRequest(url: url))
    }
    
}
