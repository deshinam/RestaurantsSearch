import Foundation
import Alamofire
import AlamofireImage
import SwiftyJSON

public enum RestaurantsAPIError: Error {
    case error
    case noresults
}

final class NetworkManager {
    // MARK: — Public Properties
    static var sharedNetworkManager = NetworkManager()

    // MARK: — Private Properties
    private struct Constants {
        static let restaurantInfoAPI = "https://uk.api.just-eat.io/restaurants/bypostcode/"
    }
    private var currentRequest: Request?
    
    // MARK: — Initializers
    private init() { }

    // MARK: — Public Methods
    func getArrayOfRestaurants(postCode: String, completion: @escaping (Result<[Restaurant], RestaurantsAPIError>) -> Void) {
        currentRequest?.cancel()
        currentRequest = AF.request("\(Constants.restaurantInfoAPI)\(postCode)")
            .responseJSON {response in
                switch response.result {
                case .success(let value):
                    let restaurants = JSON(value)["Restaurants"].array?.map { json -> Restaurant in
                        Restaurant(json: json)
                    }
                    completion(.success(restaurants ?? []))
                case .failure:
                    completion(.failure(RestaurantsAPIError.error))
                }
            }
    }
}
