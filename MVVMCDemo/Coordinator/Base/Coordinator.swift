//
//  BaseCoordinator.swift
//  MVVMCDemo
//
//  Created by Book on 2022/8/9.
//

import Foundation
import UIKit

public protocol Coordinatable: AnyObject {
    var parent: Coordinatable? { get }
    var children: [Coordinatable] { get }

    var startViewController: UIViewController? { get }
    var lastViewController: UIViewController? { get }

    func start()
    func end()

    func setParent(_ parent: Coordinatable?)

    func addChild(_ child: Coordinatable)
    func removeChild(_ child: Coordinatable)
    func removeAllChildren()
    func removeFromParent()
}

public extension Coordinatable {
    func removeFromParent() {
        parent?.removeChild(self)
    }
}

public class BaseCoordinator: Coordinatable {

    public weak var parent: Coordinatable?
    public var children: [Coordinatable] = []

    public var router: NavigationRouter
    public var navigator: UINavigationController {
        router.navigationController
    }

    public weak var startViewController: UIViewController?
    public weak var lastViewController: UIViewController?

    private var initType: InitType

    init(with initType: InitType) {
        self.initType = initType
        switch initType {
        case .root(let rootViewController):
            let navigationController = UINavigationController(rootViewController: rootViewController)
            self.router = .init(navigationController: navigationController)
            startViewController = rootViewController
            lastViewController = rootViewController
        case .push(let router):
            self.router = router
        case .present(let router):
            self.router = router
        }
    }

    public func start() {
        guard let startViewController = startViewController else {
            return
        }

        switch initType {
        case .root:
            break
        case .push:
            push(startViewController, animated: true)
        case .present:
            let navi = UINavigationController(rootViewController: startViewController)
            lastViewController = startViewController
            navigator.present(navi, animated: true) {
                self.router = .init(navigationController: navi)
            }
        }
    }

    public func end() {
        switch initType {
        case .root:
            navigator.popToRootViewController(animated: true)
        case .push:
            if let parent = parent,
               let lastViewController = parent.lastViewController {
                navigator.presentedViewController?.dismiss(animated: true)
                router.popToViewController(viewController: lastViewController,
                                           animated: true)
//                removeFromParent()
            }
        case .present:
            navigator.presentedViewController?.dismiss(animated: true)
            navigator.dismiss(animated: true)
            removeFromParent()
        }
    }

    public func setParent(_ parent: Coordinatable?) {
        self.parent = parent
    }

    public func addChild(_ child: Coordinatable) {
        child.setParent(self)
        children.append(child)
    }

    public func removeAllChildren() {
        children.forEach { child in
            child.setParent(nil)
            child.removeAllChildren()
        }
        children.removeAll()
    }

    public func removeChild(_ child: Coordinatable) {
        for (index, coordinator) in children.enumerated() {
            if coordinator === child {
                children.remove(at: index)
            }
        }
//        child.removeAllChildren()
//        child.setParent(nil)
    }
}

// MARK: - Navigation
extension BaseCoordinator {
    public func push(_ viewController: UIViewController, animated: Bool) {
        lastViewController = viewController
        viewController.coordinator = self
        router.push(viewController, animated: animated)
    }

    public func pop(animated: Bool) {
        router.pop(animated: animated)
    }

    public func present(viewController: UIViewController,
                        animated: Bool = true,
                        completion: (() -> Void)? = nil) {
        viewController.coordinator = self
        navigator.present(viewController, animated: animated, completion: completion)
    }
}

// MARK: - Enum
extension BaseCoordinator {
    enum InitType {
        case root(rootViewController: UIViewController)
        case push(router: NavigationRouter)
        case present(router: NavigationRouter)
    }
}
