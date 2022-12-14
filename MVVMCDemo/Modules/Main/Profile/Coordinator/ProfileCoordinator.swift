//
//  ProfileCoordinator.swift
//  MVVMCDemo
//
//  Created by Book on 2022/8/9.
//

import Foundation
import UIKit

protocol ProfileCoordinatorDelegate: AnyObject {
    func ProfileCoordinatorTapLogout(_ coordinator: ProfileCoordinator)
}

class ProfileCoordinator: BaseCoordinator {

    weak var coordinator: ProfileCoordinatorDelegate?

    init() {
        let rootViewController = ProfileViewController()
        super.init(with: .root(rootViewController: rootViewController))
        rootViewController.coordinator = self
    }

    deinit {
        print("ProfileCoordinator deinit")
    }
}

// MARK: - ProfileViewControllerCoordinator
extension ProfileCoordinator: ProfileViewControllerCoordinator {
    func profileViewControllerTapCustomFlow(_ viewController: ProfileViewController) {
        let child = CustomFlowCoordinator(with: .push(router: router))
        setChild(child)
        child.start()
    }

    func profileViewControllerTapLogout(_ viewController: ProfileViewController) {
        coordinator?.ProfileCoordinatorTapLogout(self)
    }
}
