import Foundation
import UIKit
import SnapKit

final class RatingView: UIView {
    
    // MARK: — Public Properties
    var currentValue: Double = Constants.defaultValue {
        didSet {
            starValueLabel.text = String(currentValue)
        }
    }
    
    // MARK: — Private Properties
    private struct Constants {
        static let cityLabelFont: CGFloat = 14
        static let cityLabelColor: UIColor = .black
        static let defaultValue: Double = 0.0
        static let starImage: UIImage = UIImage(systemName: "star.fill") ?? UIImage()
    }
    
    private var starImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = Constants.starImage
        image.tintColor = .gray
        return image
    }()
    
    private var starValueLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = Constants.cityLabelColor
        lbl.font = UIFont.boldSystemFont(ofSize: Constants.cityLabelFont)
        lbl.textAlignment = .left
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    // MARK: — Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
        defaultSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: — Private Methods
    private func setUpView() {
        addSubview(starImage)
        addSubview(starValueLabel)
        
        starImage.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading)
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        
        starValueLabel.snp.makeConstraints { make in
            make.leading.equalTo(starImage.snp.trailing).inset(-10)
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom)
            make.trailing.equalTo(self.snp.trailing)
        }
    }
    
    private func defaultSetup() {
        starValueLabel.text = String(Constants.defaultValue)
    }
}
