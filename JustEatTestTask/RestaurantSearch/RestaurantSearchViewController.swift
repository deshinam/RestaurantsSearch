import Foundation
import UIKit

class RestaurantSearchViewController: UIViewController, UISearchControllerDelegate, UISearchBarDelegate {
    var searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
       searchController.delegate = self
       searchController.searchBar.delegate = self
       searchController.searchBar.showsBookmarkButton = true
       searchController.searchBar.setImage(UIImage(named: "no"), for: .bookmark, state: .normal)
    }
}
