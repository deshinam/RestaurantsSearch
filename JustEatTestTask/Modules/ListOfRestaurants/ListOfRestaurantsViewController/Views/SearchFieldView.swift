import UIKit
import SnapKit

final class SearchFieldView: UIView {

    // MARK: — Private Properties
    private struct Constants {
        static let cityLabelFont: CGFloat = 14
        static let cityLabelColor: UIColor = .black
        static let defaultValue: Double = 0.0
        static let locationImage: UIImage = UIImage(systemName: "location.fill") ?? UIImage()
        static let searchImage: UIImage = UIImage(systemName: "magnifyingglass") ?? UIImage()
        static let searchFieldPlaceholder = "Search by postcode"
    }
    
    private lazy var locationButton: UIButton = {
        let button = UIButton(type: .system)
        button.contentMode = .scaleAspectFill
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(Constants.locationImage, for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.contentMode = .scaleAspectFill
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(Constants.searchImage, for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemOrange
        return button
    }()
    
    // MARK: — Internal Properties
    internal lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = Constants.searchFieldPlaceholder
        return textField
    }()

    internal var locationButtonTappedAction: (()->())?
    internal var searchPostCodeButtonTappedAction: ((String)->())?

    // MARK: — Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: — Private Methods
    private func setUpView() {
        self.layer.borderColor = UIColor.systemOrange.cgColor
        self.layer.borderWidth = 1
        
        addSubview(searchTextField)
        addSubview(locationButton)
        addSubview(searchButton)
        
        searchButton.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom)
            make.trailing.equalTo(self.snp.trailing)
            make.width.equalTo(50)
        }
        searchButton.addTarget(self, action: #selector(searchRestaurantsButtonTapped(sender:)), for: .touchUpInside)
        
        locationButton.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom)
            make.trailing.equalTo(searchButton.snp.leading).inset(-10)
            make.width.equalTo(40)
        }
        locationButton.addTarget(self, action: #selector(locationButtonTapped(sender:)), for: .touchUpInside)
        
        searchTextField.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).inset(10)
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom)
            make.trailing.equalTo(locationButton.snp.trailing).inset(10)
        }
        searchTextField.becomeFirstResponder()
        searchTextField.addTarget(self, action: #selector(searchRestaurantsButtonTapped(sender:)), for: .editingDidEndOnExit)
    }
    
    @objc private func searchRestaurantsButtonTapped(sender: UIButton) {
        if let action = searchPostCodeButtonTappedAction {
            action(searchTextField.text ?? "")
        }
        searchTextField.resignFirstResponder()
    }
    
    @objc private func locationButtonTapped(sender: UIButton) {
        if let action = locationButtonTappedAction {
            action()
        }
        searchTextField.resignFirstResponder()
    }
    
    // MARK: — Public Methods
    func updatePostCode(postcode: String) {
        searchTextField.text = postcode
    }
}
