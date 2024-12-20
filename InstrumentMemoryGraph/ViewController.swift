//
//  ViewController.swift
//  InstrumentMemoryGraph
//
//  Created by Mayur Bendale on 11/09/24.
//

import UIKit
// - Make sure to dequeing tableViewCell instead of creating new cell
// - Use shadowPath when applying shadow to any view's layer, this will reduce the calculation and informs the CALayer that where to apply the shadow
// - Make sure to weak or unowned the vc reference
// - UIImage(named: "") : This caches the image and keeps in the memory so it results in using more memoery if images are large. Instead we can use UIImage(contentOfFile: ) which doesn't cache the image


class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let button = UIButton()
        button.setTitle("Click Me", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        button.center = view.center
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        view.addSubview(button)
    }

    @objc private func didTapButton() {
        let redViewControlller = RedViewController()
        navigationController?.pushViewController(redViewControlller, animated: true)
    }
}

class RedViewController: UIViewController {
    var customView: CustomView?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        customView = CustomView(redController: self)
        view.addSubview(customView!)
    }
}

class CustomView: UIView {
    private weak var redController: RedViewController?
    private let customQueue = DispatchQueue(label: "com.msb.InstrumentMemoryGraph",
                                            qos: .userInitiated,
                                            attributes: [.concurrent])
    let imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    init(redController: RedViewController?) {
        self.redController = redController
        super.init(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
        addSubview(imageView)
//        let image = UIImage(named: "nature")
//        let pngData = image?.pngData()
//        print(pngData as Any)
        let imagePath = Bundle.main.path(forResource: "nature", ofType: "jpeg") ?? ""
        let image = UIImage(contentsOfFile: imagePath)
        customQueue.async {
            let pngData = image?.pngData()
            print(pngData as Any)
        }
        imageView.image = image
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
