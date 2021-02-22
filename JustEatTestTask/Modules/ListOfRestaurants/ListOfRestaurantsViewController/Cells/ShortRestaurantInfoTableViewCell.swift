import UIKit

final class ShortRestaurantInfoTableViewCell: UITableViewCell {
    // MARK: — Public Properties
    var restaurant: Restaurant? {
        didSet {
            restaurantNameLabel.text = restaurant?.name
            restaurantLogoImage.image = restaurant?.logo.image ?? Constants.restaurantDefaultLogo
            ratingView.currentValue = restaurant?.rating ?? 0
            cuisinesLabel.text = restaurant?.transformCuisineTypesToString(array: restaurant?.cuisineTypes ?? [])
        }
    }

    // MARK: — Private Properties
    private struct Constants {
        static let restaurantLabelFont: CGFloat = 16
        static let restaurantLabelColor: UIColor = .black
        static let restaurantLogoImageSize: CGFloat = 60
        static let restaurantDefaultLogo = UIImage(systemName: "timelapse")
    }

    // MARK: — Internal Properties
    internal lazy var restaurantLogoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = Constants.restaurantDefaultLogo
        imageView.tintColor = .gray
        return imageView
    }()

    internal lazy var restaurantNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = Constants.restaurantLabelColor
        lbl.font = UIFont.boldSystemFont(ofSize: Constants.restaurantLabelFont)
        lbl.textAlignment = .left
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    internal lazy var ratingView: RatingView = {
        let view = RatingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    internal lazy var cuisinesLabel: UILabel = {
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

    override func prepareForReuse() {
        super.prepareForReuse()
        clean()
    }
    // MARK: — Public Methods

    func prepareForDraw() {
        guard let url = URL(string: restaurant?.logo.url ?? "") else {return}
        restaurantLogoImage.af.setImage(
            withURL: url,
            placeholderImage: Constants.restaurantDefaultLogo,
            filter: nil,
            imageTransition: .crossDissolve(0.2)
        )
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

    private func clean() {
        restaurantNameLabel.text = ""
        restaurantLogoImage.image = Constants.restaurantDefaultLogo
        ratingView.currentValue = 0
        cuisinesLabel.text = ""
    }
}
