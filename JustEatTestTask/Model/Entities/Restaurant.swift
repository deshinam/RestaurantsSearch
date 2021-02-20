import UIKit
import SwiftyJSON

struct Restaurant {
    var rating: Double
    var name: String
    var logo: Logo
}

struct Logo {
    var url: String
    var image: UIImage?
}
