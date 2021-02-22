import UIKit
import SnapKit

protocol ListOfRestaurantsTableViewControllerProtocol {
    func setPresenter(presenter: ListOfRestaurantsPresenterProtocol)
    func updateTableView(isEmpty: Bool)
}
internal typealias ViewControllerProtocols = ListOfRestaurantsTableViewControllerProtocol & LocationDelegate

final class ListOfRestaurantsTableViewController: UIViewController {

    // MARK: — Private Properties
    private struct Constants {
        static let cellIdentifier = "ShortRestaurantInfoTableViewCell"
        static let searchFieldPlaceholderText = "Enter postcode"
        static let searchTextFieldBackgroundColor: UIColor = .gray
        static let searchTextFieldTextColor: UIColor = .white
        static let searchFieldBackgroundColor: UIColor = .gray
        static let restaurantsNotFoundText =  "We can't find restaurants near you. Try to enter different postcode!"
        static let spinnerColor: UIColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
    }

    private var listOfRestaurantsPresenter: ListOfRestaurantsPresenterProtocol?
    internal lazy var searchFieldView = SearchFieldView()
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ShortRestaurantInfoTableViewCell.self, forCellReuseIdentifier: Constants.cellIdentifier)
        tableView.separatorStyle = .none
        return tableView
    }()
    private lazy var defaultLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 2
        lbl.textAlignment = .center
        lbl.text = Constants.restaurantsNotFoundText
        return lbl
    }()
    private lazy var spinnerView: UIView = UIView()

    // MARK: — Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        setUpDefaultLabel()
        setUpSearchBar()
        view.backgroundColor = .white
    }

    override func viewWillDisappear(_ animated: Bool) {
        searchFieldView.unsubscribeSearchButton(self)
        searchFieldView.unsubscribeLocationButton(self)
    }

    // MARK: — Private Methods
    private func setUpSearchBar() {
        view.addSubview(searchFieldView)
        searchFieldView.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(10)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(60)
        }
        searchFieldView.subscribeSearchButton(self)
        searchFieldView.subscribeLocationButton(self)
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
    }

    private func setUpDefaultLabel() {
        view.addSubview(defaultLabel)
        defaultLabel.isHidden = true
        defaultLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(40)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(40)
        }
    }

    private func setUpTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none

        tableView.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(80)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }

    private func displaySpinner() {
        spinnerView = UIView.init(frame: view.bounds)
        spinnerView.backgroundColor = Constants.spinnerColor
        let ai = UIActivityIndicatorView.init(style: .large)
        ai.startAnimating()
        ai.center = spinnerView.center

        DispatchQueue.main.async {[weak self] in
            self?.spinnerView.addSubview(ai)
            self?.view.addSubview(self?.spinnerView ?? UIView())
        }
        view.addSubview(spinnerView)
    }

    private func removeSpinner() {
        DispatchQueue.main.async {[weak self] in
            self?.spinnerView.removeFromSuperview()
        }
    }

    private func showPostCodeNotFoundNotification() {
        let alert = UIAlertController(title: "Geolocation", message: "We are unable to identify your address. Please enter your postcode manually", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }

    private func showNoGeolocationAccessNotification() {
        let alert = UIAlertController(title: "You denied location access request", message: "To re-enable, please go to Settings and turn on Location Service for this app.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}

extension ListOfRestaurantsTableViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfRestaurantsPresenter?.getRestaurantsCount() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath)
        return listOfRestaurantsPresenter?.getCell(cell: cell, cellForRowAt: indexPath) ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        listOfRestaurantsPresenter?.willDrawCell(cell: cell)
    }
}

extension ListOfRestaurantsTableViewController: Observer {
    func searchButtonClicked (postCode: String) {
        if postCode.count>1 {
            displaySpinner()
            listOfRestaurantsPresenter?.getRestaurants(by: postCode)
        }
    }

    func locationButtonClicked() {
        listOfRestaurantsPresenter?.getLocation()
    }
}

extension ListOfRestaurantsTableViewController: ListOfRestaurantsTableViewControllerProtocol {
    func setPresenter(presenter: ListOfRestaurantsPresenterProtocol) {
        listOfRestaurantsPresenter = presenter
    }

    func updateTableView(isEmpty: Bool) {
        tableView.reloadData()
        removeSpinner()
        if isEmpty {
            tableView.isHidden = true
            defaultLabel.isHidden = false
        } else {
            tableView.isHidden = false
            defaultLabel.isHidden = true
        }
    }
}

extension ListOfRestaurantsTableViewController: LocationDelegate {
    func onDeniedPermission() {
        showNoGeolocationAccessNotification()
    }

    func onLocationUnavailable() {
        showPostCodeNotFoundNotification()
    }

    func onLocationSuccess(_ postCode: String) {
        searchFieldView.updatePostCode(postcode: postCode)
    }
}
