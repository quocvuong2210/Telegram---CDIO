//
//  HomeController.swift
//  TeleApp
//
//  Created by Dezhun on 27/1/26.
//

import UIKit

class HomeController: UIViewController {
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = . center
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.text = "Loading..."
        label.numberOfLines = 2
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
        self.label.text = "CodeBarh\ncodebrah@gmail.com"
    }
    
    private func setupUI() {
        
        self.view.backgroundColor = .systemBackground
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: nil, action: #selector(didTapLogout))
        
        self.view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
        ])
    }
    @objc private func didTapLogout() {
        self.navigationController?.dismiss(animated: true)
    }
}
