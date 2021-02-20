import Foundation
import PromiseKit

protocol ListOfRestaurantsPresenterProtocol {
    func getRestaurants(by postcode: String)
    func getArray() -> [Restaurant]?
    func getRestaurantsCount() -> Int?
    func getCell(cellForRowAt indexPath: IndexPath) -> UITableViewCell
}

final class ListOfRestaurantsPresenter {
    // MARK: — Public Properties
    public var restaurants: [Restaurant] = [Restaurant]()
    
    // MARK: — Private Properties
    private let networkManager = NetworkManager.sharedNetworkManager
    private var listOfRestaurantsTableViewController: ListOfRestaurantsTableViewControllerProtocol?
    
    // MARK: — Initializers
    init (viewController: ListOfRestaurantsTableViewControllerProtocol) {
        self.listOfRestaurantsTableViewController = viewController
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
        networkManager.performRequestArray(postCode: postcode).done {[weak self] data in
            self?.restaurants = data ?? [Restaurant]()
            var isEmptyFlag = true
            if self?.restaurants.count ?? 0 > 1 {
                isEmptyFlag = false
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

    func getCell(cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ShortRestaurantInfoTableViewCell()
        cell.restaurant = restaurants[indexPath.row]
        return cell
    }
}
