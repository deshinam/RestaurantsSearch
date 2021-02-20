import Foundation

final class ListOfRestaurantsConfigurator {
    
    // MARK: — Public Methods
    func configure (viewController: ListOfRestaurantsTableViewControllerProtocol) {
        let presenter = ListOfRestaurantsPresenter(viewController: viewController)
        viewController.setPresenter(presenter: presenter)
    }
}
