import Foundation
import ObjectMapper

class RestaurantsArray: Mappable {

    var restaurantsInfo: [RestaurantInfo] = [RestaurantInfo]()

    required public init?(map: Map) {}

    public func mapping(map: Map) {
        restaurantsInfo <- map["Restaurants"]
    }
}

class RestaurantInfo: Mappable {
    var rating: Double = 0
    var name: String = ""
    var logo: String = ""

    required public init?(map: Map) {}

    public func mapping(map: Map) {
        rating <- map["RatingStars"]
        name <- map["Name"]
        logo <- map["LogoUrl"]
    }
}


