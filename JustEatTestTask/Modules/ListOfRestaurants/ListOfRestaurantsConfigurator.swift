import Foundation

final class ListOfRestaurantsConfigurator {

    // MARK: — Public Methods
    func configure (viewController: ViewControllerProtocols) {
        let presenter = ListOfRestaurantsPresenter(viewController: viewController)
        viewController.setPresenter(presenter: presenter)
    }
}
