//
//  BiometricsCheckViewController.swift
//  MVVMCDemo
//
//  Created by Book on 2022/8/9.
//

import UIKit

protocol BiometricsCheckViewControllerCoordinator: AnyObject {
    func BiometricsCheckViewControllerDidSuccess(_ viewController: BiometricsCheckViewController)
}

class BiometricsCheckViewController: BaseViewController {

    weak var coordinator: BiometricsCheckViewControllerCoordinator?

    private let imageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "BiometricsCheckView"))
        view.contentMode = .scaleAspectFill
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        coordinator?.BiometricsCheckViewControllerDidSuccess(self)
    }
}

// MARK: - Private Function
extension BiometricsCheckViewController {
    private func initView() {
        view.addSubview(imageView)

        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
