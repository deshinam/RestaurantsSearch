import UIKit

final class ShortRestaurantInfoTableViewCell: UITableViewCell {
    // MARK: — Public Properties
    var restaurant: Restaurant? {
        didSet {
            restaurantNameLabel.text = restaurant?.name
            restaurantLogoImage.image = restaurant?.logo.image
            ratingView.currentValue = restaurant?.rating ?? 0
        }
    }

    // MARK: — Private Properties
    private struct Constants {
        static let cityLabelFont: CGFloat = 16
        static let cityLabelColor: UIColor = .black
        static let restaurantLogoImageSize: CGFloat = 50
    }

    lazy private var restaurantLogoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    lazy private var restaurantNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = Constants.cityLabelColor
        lbl.font = UIFont.boldSystemFont(ofSize: Constants.cityLabelFont)
        lbl.textAlignment = .left
        lbl.translatesAutoresizingMaskIntoConstraints = false
    return lbl
    }()

    lazy private var ratingView: RatingView = {
        let view = RatingView()
        view.translatesAutoresizingMaskIntoConstraints = false
    return view
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

        restaurantLogoImage.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).inset(10)
            make.top.equalTo(self.snp.top).inset(10)
            make.bottom.equalTo(self.snp.bottom).inset(10)
            make.size.equalTo(CGSize(width: Constants.restaurantLogoImageSize, height: Constants.restaurantLogoImageSize))
        }

        restaurantNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(restaurantLogoImage.snp.trailing).inset(-10)
            make.top.equalTo(self.snp.top).inset(10)
            make.trailing.equalTo(self.snp.trailing).inset(10)
        }

        ratingView.snp.makeConstraints { make in
            make.leading.equalTo(restaurantLogoImage.snp.trailing).inset(-10)
            make.top.equalTo(restaurantNameLabel.snp.bottom).inset(10)
            make.bottom.equalTo(self.snp.bottom).inset(10)
            make.trailing.equalTo(self.snp.trailing).inset(10)
        }
    }

}
