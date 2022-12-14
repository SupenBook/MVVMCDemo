//
//  LoginViewController.swift
//  MVVMCDemo
//
//  Created by Book on 2022/8/9.
//

import UIKit
import SnapKit

protocol LoginViewControllerCoordinator: AnyObject {
    func loginViewControllerDidSuccessLogin(_ viewController: LoginViewController)
    func loginViewControllerTapRegister(_ viewController: LoginViewController)
}

class LoginViewController: BaseViewController {

    weak var coordinator: LoginViewControllerCoordinator?

    private let imageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "LoginView"))
        view.contentMode = .scaleAspectFill
        return view
    }()

    private let loginButton: UIButton = {
        let button = UIButton()
        return button
    }()

    private let registerButton: UIButton = {
        let button = UIButton()
        return button
    }()

    private lazy var viewModel: LoginViewModel = {
        let viewModel = LoginViewModel()
        viewModel.output = self
        return viewModel
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        setupReaction()
    }
}

// MARK: - Private Function
extension LoginViewController {
    func initView() {
        view.addSubview(imageView)
        view.addSubview(loginButton)
        view.addSubview(registerButton)

        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        loginButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(64)
            make.centerY.equalTo(460)
        }

        registerButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(74)
            make.width.equalTo(48)
            make.leading.equalToSuperview().inset(32)
        }
    }

    func setupReaction() {
        loginButton.addAction { [weak self] in
            guard let self = self else { return }
            let userName = "dsajik"
            let password = "dsamdilsa"
            self.viewModel.checkLogin(userName: userName,
                                      password: password)
        }

        registerButton.addAction { [weak self] in
            guard let self = self else { return }
            self.coordinator?.loginViewControllerTapRegister(self)
        }
    }

    func showLoginError() {

    }
}

// MARK: - LoginViewModelOutput
extension LoginViewController: LoginViewModelOutput {
    func loginViewModel(_ vm: LoginViewModel, with isLoginSuccess: Bool) {
        if isLoginSuccess {
            coordinator?.loginViewControllerDidSuccessLogin(self)
        } else {
            showLoginError()
        }
    }
}
