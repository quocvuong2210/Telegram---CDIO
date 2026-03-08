//
//  LoginViewController.swift
//  TeleApp
//
//  Created by Dezhun on 27/1/26.
//

import UIKit

class LoginController: UIViewController {
    
    private let headerVIew = AuthHeaderView(title: "Sign In", subTile: "Sign In to your account")
    
    private let emailField = CustomTextField(authFieldType: .email)
    private let passwordField = CustomTextField(authFieldType: .password)
    
    private let signInButton = CustomButton(title: "Sign In",hasBackground: true ,fontSize: .big)
    private let newUserButton = CustomButton(title: "New User ? Create Account.", fontSize: .med)
    private let forgotPasswordButton = CustomButton(title: "Forgot Password ?", fontSize: .small)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
        self.signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        self.newUserButton.addTarget(self, action: #selector(didTapNewUser), for: .touchUpInside)
        self.forgotPasswordButton.addTarget(self, action: #selector(didTapForgotPassword), for: .touchUpInside)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    private func setupUI() {
        self.view.backgroundColor = .systemBackground
        
        self.view.addSubview(headerVIew)
        self.view.addSubview(emailField)
        self.view.addSubview(passwordField)
        self.view.addSubview(signInButton)
        self.view.addSubview(newUserButton)
        self.view.addSubview(forgotPasswordButton)
        
        headerVIew.translatesAutoresizingMaskIntoConstraints = false
        emailField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        newUserButton.translatesAutoresizingMaskIntoConstraints = false
        forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.headerVIew.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
            self.headerVIew.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.headerVIew.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.headerVIew.heightAnchor.constraint(equalToConstant: 222),
            
            self.emailField.topAnchor.constraint(equalTo: headerVIew.bottomAnchor,constant: 12),
            self.emailField.centerXAnchor.constraint(equalTo: headerVIew.centerXAnchor),
            self.emailField.heightAnchor.constraint(equalToConstant: 55),
            self.emailField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor,constant: 22),
            self.passwordField.centerXAnchor.constraint(equalTo: headerVIew.centerXAnchor),
            self.passwordField.heightAnchor.constraint(equalToConstant: 55),
            self.passwordField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.signInButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor,constant: 22),
            self.signInButton.centerXAnchor.constraint(equalTo: headerVIew.centerXAnchor),
            self.signInButton.heightAnchor.constraint(equalToConstant: 55),
            self.signInButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.newUserButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor,constant: 11),
            self.newUserButton.centerXAnchor.constraint(equalTo: headerVIew.centerXAnchor),
            self.newUserButton.heightAnchor.constraint(equalToConstant: 44),
            self.newUserButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.forgotPasswordButton.topAnchor.constraint(equalTo: newUserButton.bottomAnchor,constant: 6),
            self.forgotPasswordButton.centerXAnchor.constraint(equalTo: headerVIew.centerXAnchor),
            self.forgotPasswordButton.heightAnchor.constraint(equalToConstant: 44),
            self.forgotPasswordButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
        ])
    }
    @objc private func didTapSignIn() {
        let vc = HomeController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: false, completion: nil)
    }
    @objc private func didTapNewUser() {
        let vc = RegisterController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc private func didTapForgotPassword() {
        let vc = ForgotPasswordController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

