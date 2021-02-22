import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let listOfRestaurants = ListOfRestaurantsTableViewController()
        let configurator = ListOfRestaurantsConfigurator()
        configurator.configure(viewController: listOfRestaurants)
        window?.rootViewController = listOfRestaurants
        window?.makeKeyAndVisible()
        return true
    }
}
