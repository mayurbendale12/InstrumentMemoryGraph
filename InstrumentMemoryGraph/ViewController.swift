import UIKit
// Below are some tips to avoid taking more memory by the App
// - Make sure to dequeing tableViewCell instead of creating new cell
// - Use shadowPath when applying shadow to any view's layer, this will reduce the calculation and informs the CALayer that where to apply the shadow
// - Make sure to weak or unowned the vc reference
// - UIImage(named: "") : This caches the image and keeps in the memory so it results in using more memoery if images are large. Instead we can use UIImage(contentOfFile: ) which doesn't cache the image

class ViewController: UIViewController {
    //This won't release the RedViewController instances from memory.
    // Remove this code to avoid retaining it from memory
    private var viewControllers = [UIViewController]()

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
        viewControllers.append(redViewControlller)
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

    deinit {
        print("RedViewController deinit")
        customView = nil
    }
}

class CustomView: UIView {
    private var redController: RedViewController?
    //To avoid retain cycle
//    private weak var redController: RedViewController?
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
        //UIImage(named caches the image so it doesn't increase memory that much
//        let image = UIImage(named: "nature")
//        imageView.image = image

        //This increase the memory suddenly
        let imagePath = Bundle.main.path(forResource: "nature", ofType: "jpeg") ?? ""
        let image = UIImage(contentsOfFile: imagePath)
        customQueue.async {
            let imageData = image?.jpegData(compressionQuality: 1)
            let image = UIImage(data: imageData!)
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
