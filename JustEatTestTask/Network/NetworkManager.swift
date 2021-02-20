import Foundation
import Alamofire
import AlamofireImage
import SwiftyJSON
import PromiseKit

public class NetworkManager {
    // MARK: — Public Properties
    static var sharedNetworkManager = NetworkManager()
    
    // MARK: — Private Properties
    private enum LogoError: Error {
        case ConvertToData
        case PhotoDecoding
        case downloadPhotoUrl
        case downloadPhotoConvertToData
        case downloadPhotoConvertToUIImage
        case otherError
    }
    
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
        return Promise { seal in
            if let restaurantsWithLogo: [Restaurant] = restaurants {
                for var restaurant in restaurantsWithLogo.prefix(10) {
                    AF.request(restaurant.logo.url, method: .get).response { response  in
                        print(restaurant.logo.url)
                        switch response.result {
                        case .success(let responseData):
                            //   restaurantsWithLogo[i].logo.image = UIImage(data: responseData!, scale:1)
                            restaurant.logo.image = UIImage(systemName: "star.fill")
                            print(restaurant.logo.image)
                        case .failure(let error):
                            print("error--->",error)
                        }
                    }
                }
                seal.fulfill(restaurantsWithLogo)
            } else {
                seal.reject(LogoError.otherError)
            }
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
                                       logo: Logo(url: "https" + json["LogoUrl"].stringValue.dropFirst(4), image: nil))
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




//                                            guard let logoURL = URL(string: restaurantsWithLogo[i].logo.url) else {
//                                                seal.reject(LogoError.downloadPhotoUrl)
//                                                return
//                                            }
//                                            guard let logoData = try? Data(contentsOf: logoURL) else {
//                                                seal.reject(LogoError.downloadPhotoConvertToData)
//                                                return
//                                            }
//                                            guard let logoImage = UIImage(data: logoData) else {
//                                                seal.reject(LogoError.downloadPhotoConvertToUIImage)
//                                                return
//                                            }
//                                            restaurantsWithLogo[i].logo.image = logoImage
