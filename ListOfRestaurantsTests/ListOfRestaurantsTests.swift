import XCTest
import UIKit
import SwiftyJSON
@testable import JustEatTestTask

class ListOfRestaurantsTests: XCTestCase {

    // MARK: — UI Tests
    func testCellDisplayWithDefaultLogo() throws {
        // Arrange
        let cell = ShortRestaurantInfoTableViewCell()
        let restaurant = Restaurant(rating: 4.5, name: "Tapchan", logo: Logo(url: "", image: nil), cuisineTypes: ["American", "123"])
        let restImage = restaurant.logo.image ?? UIImage(systemName: "timelapse")

        // Act
        cell.restaurant = restaurant

        // Assert
        XCTAssertEqual(cell.restaurantNameLabel.text, restaurant.name)
        XCTAssertEqual(cell.restaurantLogoImage.image, restImage)
        XCTAssertEqual(cell.cuisinesLabel.text, restaurant.transformCuisineTypesToString(array: restaurant.cuisineTypes))
        XCTAssertEqual(cell.ratingView.starValueLabel.text, String(restaurant.rating))
    }

    // MARK: — Unit Tests
    func testRestaurantMappingFromJSONToObject() throws {
        // Arrange
        var restaurant: Restaurant?
        var json: JSON?
        if let path = Bundle(for: type(of: self)).path(forResource: "RestaurantJSON", ofType: "json") {
            do {
                let fileUrl = URL(fileURLWithPath: path)
                let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
                json = try JSON(data: data)
            }
        } else {
            XCTFail("Missing file: RestaurantJSON.json")
        }

        // Act
        if let jsonData = json {
            restaurant = Restaurant(json: jsonData)
        } else {
            XCTFail("Error")
        }

        // Assert
        XCTAssertEqual(restaurant?.name, "Forno Pizza")
        XCTAssertEqual(restaurant?.rating, 4.88)
        XCTAssertEqual(restaurant?.transformCuisineTypesToString(array: restaurant?.cuisineTypes ?? []), "Pizza, Italian")
        XCTAssertEqual(restaurant?.logo.url, "https://d30v2pzvrfyzpo.cloudfront.net/uk/images/restaurants/97680.gif")
    }

}
