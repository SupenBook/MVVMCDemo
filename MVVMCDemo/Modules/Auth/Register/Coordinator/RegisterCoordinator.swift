//
//  RegisterCoordinator.swift
//  MVVMCDemo
//
//  Created by Book on 2022/8/9.
//

import UIKit

protocol RegisterCoordinatorDelegate: AnyObject {
    func RegisterCoordinatorGotoMain(_ coordinator: RegisterCoordinator)
    func RegisterCoordinatorGotoLogin(_ coordinator: RegisterCoordinator)
}

class RegisterCoordinator: BaseCoordinator {

    weak var coordinator: RegisterCoordinatorDelegate?

    init() {
        let rootViewController = RegisterViewController()
        super.init(with: .root(rootViewController: rootViewController))
        rootViewController.coordinator = self
    }

    deinit {
        print("RegisterCoordinator deinit")
    }

}

// MARK: - RegisterViewControllerCoordinator
extension RegisterCoordinator: RegisterViewControllerCoordinator {
    func registerViewControllerReigsterSuccess(_ viewController: RegisterViewController) {
        coordinator?.RegisterCoordinatorGotoMain(self)
    }

    func registerViewControllerTapLogin(_ viewController: RegisterViewController) {
        coordinator?.RegisterCoordinatorGotoLogin(self)
    }
}
