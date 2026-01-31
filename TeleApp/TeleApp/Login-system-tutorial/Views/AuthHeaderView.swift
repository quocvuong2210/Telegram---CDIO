//
//  AuthHeaderView.swift
//  TeleApp
//
//  Created by Dezhun on 29/1/26.
//

import UIKit

class AuthHeaderView: UIView {
    private let logoImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "Logo")
        iv.tintColor = .white
        return iv
    }()
    private let titleLabel: UILabel = {
           let label = UILabel()
           label.textColor = .label
           label.textAlignment = .center
           label.font = .systemFont(ofSize: 26, weight: .bold)
           label.text = "Error"
           return label
       }()
    private let subTitleLabel: UILabel = {
            let label = UILabel()
            label.textColor = .secondaryLabel
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 18, weight: .regular)
            label.text = "Error"
            return label
        }()
    
    init(title: String, subTile: String){
        super.init(frame: .zero)
        self.titleLabel.text = title
        self.subTitleLabel.text = subTile
        
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        self.addSubview(logoImageView)
        self.addSubview(titleLabel)
        self.addSubview(subTitleLabel)
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.logoImageView.topAnchor.constraint(equalTo:
                self.topAnchor, constant: 30),
            self.logoImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.logoImageView.widthAnchor.constraint(equalToConstant: 90),
            self.logoImageView.heightAnchor.constraint(equalTo:logoImageView.widthAnchor),
            
            self.titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor,constant: 19),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            self.subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,constant: 12),
            self.subTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.subTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
}
