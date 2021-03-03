import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let listOfRestaurants = ListOfRestaurantsTableViewController()
        let presenter = ListOfRestaurantsPresenter(viewController: listOfRestaurants)
        listOfRestaurants.setPresenter(presenter: presenter)
        window?.rootViewController = listOfRestaurants
        window?.makeKeyAndVisible()
        return true
    }
}
