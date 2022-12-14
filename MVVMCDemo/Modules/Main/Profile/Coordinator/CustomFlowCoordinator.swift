//
//  ProfileACoordinator.swift
//  MVVMCDemo
//
//  Created by Book on 2022/8/9.
//

import UIKit

class CustomFlowCoordinator: BaseCoordinator {

    let id = UUID().uuidString

    override func start() {
        let viewController = CustomFlowViewController(id: id)
        startViewController = viewController
        super.start()
        viewController.coordinator = self
    }

    deinit {
        print("CustomCoordinator \(id) deinit")
    }
}

// MARK: - ProfileViewControllerCoordinator
extension CustomFlowCoordinator: CustomFlowViewControllerCoordinator {
    func customFlowViewControllerPushNew(_ viewController: CustomFlowViewController) {
        let viewController = CustomFlowViewController(id: id)
        viewController.coordinator = self
        push(viewController, animated: true)
    }

    func customFlowViewControllerPresentNew(_ viewController: CustomFlowViewController) {
        let viewController = CustomFlowViewController(id: id)
        viewController.coordinator = self
        present(viewController: viewController, animated: true, completion: nil)
    }

    func customFlowViewControllerPushNewFlow(_ viewController: CustomFlowViewController) {
        let child = CustomFlowCoordinator(with: .push(router: router))
        setChild(child)
        child.start()
    }

    func customFlowViewControllerPresentNewFlow(_ viewController: CustomFlowViewController) {
        let child = CustomFlowCoordinator(with: .present(router: router))
        setChild(child)
        child.start()
    }

    func customFlowViewControllerEndThisFlow(_ viewController: CustomFlowViewController) {
        end()
    }
}
