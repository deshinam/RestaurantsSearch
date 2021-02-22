import UIKit

protocol ListOfRestaurantsPresenterProtocol {
    func getRestaurants(by postcode: String)
    func getArray() -> [Restaurant]?
    func getRestaurantsCount() -> Int?
    func getCell(cell: UITableViewCell, cellForRowAt: IndexPath)  -> UITableViewCell
    func willDrawCell(cell: UITableViewCell)
    func getLocation()
}

final class ListOfRestaurantsPresenter {
    // MARK: — Public Properties
    public var restaurants: [Restaurant] = [Restaurant]()

    // MARK: — Private Properties
    private let networkManager = NetworkManager.sharedNetworkManager
    private var listOfRestaurantsTableViewController: ListOfRestaurantsTableViewControllerProtocol?
    private var locationManager: LocationManager?

    // MARK: — Initializers
    init (viewController: ViewControllerProtocols) {
        self.listOfRestaurantsTableViewController = viewController
        locationManager = LocationManager(delegate: viewController)
    }

    // MARK: — Private Methods
    private func updateTableView(isEmpty: Bool) {
        if self.listOfRestaurantsTableViewController != nil {
            self.listOfRestaurantsTableViewController!.updateTableView(isEmpty: isEmpty)
        }
    }
}

extension ListOfRestaurantsPresenter: ListOfRestaurantsPresenterProtocol {
    func getRestaurants(by postcode: String) {
        var isEmptyFlag = true
        networkManager.getArrayOfRestaurants(postCode: postcode) {[weak self] data in
            switch data {
            case .success(let value):
                isEmptyFlag = value.isEmpty
                self?.restaurants = value
            case .failure:
                break
            }
            self?.updateTableView(isEmpty: isEmptyFlag)
        }
    }

    func getRestaurantsCount() -> Int? {
        return restaurants.count
    }

    func getArray() -> [Restaurant]? {
        return restaurants
    }

    func getCell(cell: UITableViewCell, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let restaurantCell = cell as? ShortRestaurantInfoTableViewCell else {return cell}
        restaurantCell.restaurant = restaurants[indexPath.row]
        return cell
    }

    func willDrawCell(cell: UITableViewCell) {
        guard let restaurantCell = cell as? ShortRestaurantInfoTableViewCell else {return}
        restaurantCell.prepareForDraw()
    }

    func getLocation() {
        locationManager?.getLocation()
    }
}
