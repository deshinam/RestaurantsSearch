import UIKit

final class ShortRestaurantInfoTableViewCell: UITableViewCell {
    // MARK: — Public Properties
    var restaurant: Restaurant? {
        didSet {
            restaurantNameLabel.text = restaurant?.name
            restaurantLogoImage.image = restaurant?.logo.image
            ratingView.currentValue = restaurant?.rating ?? 0
            cuisinesLabel.text = restaurant?.cuisineTypes.map {$0}.joined(separator: ", ")
        }
    }

    // MARK: — Private Properties
    private struct Constants {
        static let restaurantLabelFont: CGFloat = 16
        static let restaurantLabelColor: UIColor = .black
        static let restaurantLogoImageSize: CGFloat = 60
    }

    lazy private var restaurantLogoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    lazy private var restaurantNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = Constants.restaurantLabelColor
        lbl.font = UIFont.boldSystemFont(ofSize: Constants.restaurantLabelFont)
        lbl.textAlignment = .left
        lbl.translatesAutoresizingMaskIntoConstraints = false
    return lbl
    }()

    lazy private var ratingView: RatingView = {
        let view = RatingView()
        view.translatesAutoresizingMaskIntoConstraints = false
    return view
    }()

    private lazy var cuisinesLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 2
        lbl.textAlignment = .left
        return lbl
    }()

    // MARK: — Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: — Private Methods
    private func setUpCell() {
        addSubview(restaurantLogoImage)
        addSubview(restaurantNameLabel)
        addSubview(ratingView)
        addSubview(cuisinesLabel)

        restaurantLogoImage.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).inset(10)
            make.top.equalTo(self.snp.top).inset(10)
            make.size.equalTo(CGSize(width: Constants.restaurantLogoImageSize, height: Constants.restaurantLogoImageSize))
        }

        restaurantNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(restaurantLogoImage.snp.trailing).inset(-10)
            make.top.equalTo(self.snp.top).inset(10)
            make.trailing.equalTo(self.snp.trailing).inset(10)
        }

        cuisinesLabel.snp.makeConstraints { make in
            make.leading.equalTo(restaurantLogoImage.snp.trailing).inset(-10)
            make.top.equalTo(restaurantNameLabel.snp.bottom).inset(-10)
            make.trailing.equalTo(self.snp.trailing).inset(10)
        }

        ratingView.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).inset(10)
            make.top.equalTo(restaurantLogoImage.snp.bottom).inset(-10)
            make.bottom.equalTo(self.snp.bottom).inset(10)
            make.width.equalTo(Constants.restaurantLogoImageSize)
        }
    }

}
