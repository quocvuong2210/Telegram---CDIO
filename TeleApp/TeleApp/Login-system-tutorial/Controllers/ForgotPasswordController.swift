//
//  ForgotPasswordViewController.swift
//  TeleApp
//
//  Created by Dezhun on 27/1/26.
//

import UIKit

class ForgotPasswordController: UIViewController {
    
    private let headerView = AuthHeaderView(title: "Forgot Password", subTile: "Reset your Password")
    
    private let emailField = CustomTextField(authFieldType: .email)
    private let resetPasswordButton = CustomButton(title: "Sign Up", hasBackground: true, fontSize: .big)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
        self.resetPasswordButton.addTarget(nil, action: #selector(didTapForgotPassword), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setupUI() {
        self.view.backgroundColor = .systemBackground
        
        self.view.addSubview(headerView)
        self.view.addSubview(emailField)
        self.view.addSubview(resetPasswordButton)
        
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        emailField.translatesAutoresizingMaskIntoConstraints = false
        resetPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.headerView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30),
            self.headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.headerView.heightAnchor.constraint(equalToConstant: 230),
            
            self.emailField.topAnchor.constraint(equalTo: headerView.bottomAnchor,constant: 11),
            self.emailField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.emailField.heightAnchor.constraint(equalToConstant: 55),
            self.emailField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.resetPasswordButton.topAnchor.constraint(equalTo: emailField.bottomAnchor,constant: 11),
            self.resetPasswordButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.resetPasswordButton.heightAnchor.constraint(equalToConstant: 55),
            self.resetPasswordButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
        ])
    }
    @objc private func didTapForgotPassword() {
        guard let email = emailField.text, !email.isEmpty else { return }
        let vc = LoginController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
