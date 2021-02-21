import UIKit
import SnapKit
import CoreLocation

protocol ListOfRestaurantsTableViewControllerProtocol {
    func setPresenter(presenter: ListOfRestaurantsPresenterProtocol)
    func updateTableView(isEmpty: Bool)
}

final class ListOfRestaurantsTableViewController: UIViewController {

    // MARK: — Private Properties
    private struct Constants {
        static let cellIdentifier = "ShortRestaurantInfoTableViewCell"
        static let searchFieldPlaceholderText = "Enter postcode"
        static let searchTextFieldBackgroundColor: UIColor = .gray
        static let searchTextFieldTextColor:UIColor = .white
        static let searchFieldBackgroundColor: UIColor = .gray
        static let restaurantsNotFoundText =  "We can't find restaurants near you. Try to enter other postcode!"
        static let spinnerColor: UIColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
    }
    
    private var listOfRestaurantsPresenter: ListOfRestaurantsPresenterProtocol?
    private lazy var searchFieldView = SearchFieldView()
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
    private var locationManager = CLLocationManager()
    
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
}

extension ListOfRestaurantsTableViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfRestaurantsPresenter?.getRestaurantsCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listOfRestaurantsPresenter?.getCell(cellForRowAt: indexPath) ?? UITableViewCell()
        return cell
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
        locationManager.delegate = self
        locationManager.requestLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
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


extension ListOfRestaurantsTableViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error)-> Void in
                if error != nil {
                    self.showPostCodeNotFoundNotification()
                    return
                }
                
                if placemarks?.count ?? 0 > 0 {
                    let placemark = placemarks?[0]
                    self.locationManager.stopUpdatingLocation()
                    if let newPostCode = placemark?.postalCode {
                        self.searchFieldView.updatePostCode(postcode: newPostCode)
                    } else {
                        self.showPostCodeNotFoundNotification()
                    }
                    
                } else {
                    self.showPostCodeNotFoundNotification()
                }
            })
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showPostCodeNotFoundNotification()
    }
    
    private func showPostCodeNotFoundNotification() {
        let alert = UIAlertController(title: "Geolocation", message: "We can't define your address. Please, enter your PostCode manually", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}
