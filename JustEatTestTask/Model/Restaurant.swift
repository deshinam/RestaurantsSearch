import UIKit
import SwiftyJSON

struct Restaurant {
    var rating: Double
    var name: String
    var logo: Logo
    var cuisineTypes: [String]
    
    func transformCuisineTypesToString(array: [String]) -> String {
        return array.map {$0}.joined(separator: ", ")
    }
}
extension Restaurant {
    init(json: JSON) {
        rating = json["RatingStars"].doubleValue
        name = json["Name"].stringValue
        logo = Logo(url: "https" + json["LogoUrl"].stringValue.dropFirst(4), image: nil)
        cuisineTypes = json["Cuisines"].arrayValue.map { $0["Name"].stringValue}
    }
}

struct Logo {
    var url: String
    var image: UIImage?
}
