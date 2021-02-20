import UIKit
import SnapKit

protocol Observer: class {
    func searchButtonClicked (postCode: String)
    func locationButtonClicked()
}

final class SearchFieldView: UIView {

    // MARK: — Private Properties
    private struct Constants {
        static let cityLabelFont: CGFloat = 14
        static let cityLabelColor: UIColor = .black
        static let defaultValue: Double = 0.0
        static let locationImage: UIImage = UIImage(systemName: "location.fill") ?? UIImage()
        static let searchImage: UIImage = UIImage(systemName: "magnifyingglass") ?? UIImage()
    }

    private lazy var locationButton: UIButton = {
        let button = UIButton()
        button.contentMode = .scaleAspectFill
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(Constants.locationImage, for: .normal)
        button.tintColor = .black
        return button
    }()

    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.contentMode = .scaleAspectFill
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(Constants.searchImage, for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemOrange
        return button
    }()

    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Search by postcode"
        return textField
    }()

    private lazy var searchButtonObservers = [Observer]()
    private lazy var locationButtonObservers = [Observer]()

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
        searchButton.addTarget(self, action: #selector(searchCityButtonTapped(sender:)), for: .touchUpInside)

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
    }

    @objc private func searchCityButtonTapped(sender: UIButton) {
        searchButtonObservers.forEach({ $0.searchButtonClicked(postCode: searchTextField.text ?? "")})
    }

    @objc private func locationButtonTapped(sender: UIButton) {
        locationButtonObservers.forEach({ $0.locationButtonClicked()})
    }

    // MARK: — Public Methods
    func subscribeSearchButton(_ observer: Observer) {
        searchButtonObservers.append(observer)
    }

    func unsubscribeSearchButton(_ observer: Observer) {
        if let idx = searchButtonObservers.firstIndex(where: { $0 === observer }) {
            searchButtonObservers.remove(at: idx)
        }
    }

    func subscribeLocationButton(_ observer: Observer) {
        locationButtonObservers.append(observer)
    }

    func unsubscribeLocationButton(_ observer: Observer) {
        if let idx = locationButtonObservers.firstIndex(where: { $0 === observer }) {
            locationButtonObservers.remove(at: idx)
        }
    }

    func updatePostCode(postcode: String) {
        searchTextField.text = postcode
    }

}

