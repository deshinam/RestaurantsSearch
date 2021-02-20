import Foundation
import Alamofire
import AlamofireImage
import SwiftyJSON
import PromiseKit

public class NetworkManager {
    // MARK: — Public Properties
    static var sharedNetworkManager = NetworkManager()
    
    // MARK: — Private Properties
    private struct Constants {
        static let restaurantInfoAPI = "https://uk.api.just-eat.io/restaurants/bypostcode/"
    }
    
    // MARK: — Initializers
    private init() { }
    
    // MARK: — Public Methods
    func performRequestArray(postCode: String)->Promise<[Restaurant]?>  {
        return firstly {
            getArrayOfRestaurants(postCode: postCode)
        }.then { (restaurants) -> Promise<[Restaurant]?> in
            if restaurants?.count ?? 0 > 1 {
                return self.downloadPhotos(restaurants: restaurants)
            } else {
                return .value(nil)
            }
        }
    }
    
    // MARK: — Private Methods
    private func downloadPhotos(restaurants: [Restaurant]?) -> Promise<[Restaurant]?> {
        guard var restaurantsWithLogos = restaurants else {
            return .value(nil)
        }
        var promises: [Promise<Void>] = []
        for i in 0..<10 {
            let promise = Promise<Void> { seal in
                AF.request(restaurantsWithLogos[i].logo.url, method: .get).response { response  in
                    switch response.result {
                    case .success(let responseData):
                        restaurantsWithLogos[i].logo.image = UIImage(data: responseData!, scale:1)
                        seal.fulfill(())
                    case .failure(let error):
                        seal.reject(error)
                    }
                }
            }
            promises.append(promise)
        }
        return when(resolved: promises).map {_ in
            return restaurantsWithLogos
        }
    }
    
    private func getArrayOfRestaurants(postCode: String) ->Promise<[Restaurant]?> {
        return Promise<[Restaurant]?> {seal in
            AF.request("\(Constants.restaurantInfoAPI)\(postCode)")
                .responseJSON {response in
                    switch response.result {
                    case .success(let value):
                        let restaurants = JSON(value)["Restaurants"].array?.map { json -> Restaurant in
                            Restaurant(rating: json["RatingStars"].doubleValue,
                                       name: json["Name"].stringValue,
                                       logo: Logo(url: "https" + json["LogoUrl"].stringValue.dropFirst(4), image: nil),
                                       cuisineTypes:  json["Cuisines"].arrayValue.map { $0["Name"].stringValue})
                        }
                        seal.fulfill(restaurants)
                    case .failure(let error):
                        print("Error while fetching colors: \(String(describing: error))")
                        seal.reject(error)
                    }
                }
        }
    }
}
