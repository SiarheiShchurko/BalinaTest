
import UIKit
import SDWebImage

final class DeveloperCell: UITableViewCell {
    
    // MARK: - Labels
    private let nameLabel = UniversalLabel(text: "",
                                           textColor: .black,
                                           font: .systemFont(ofSize: 22),
                                           textAlign: .left,
                                           autoresizingMask: false)
    
    private let idLabel = UniversalLabel(text: "",
                                         textColor: .black.withAlphaComponent(0.7),
                                         font: .systemFont(ofSize: 15),
                                         textAlign: .left,
                                         autoresizingMask: false)
    
    // MARK: - ImageView
    private let photoImg = SimpleImageView(imageName: "",
                                           contentMode: .scaleAspectFill,
                                           autoresizingMask: false)
    
    // MARK: Cell init
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style,
                   reuseIdentifier: "\(DeveloperCell.self)")
        // # 1
        backgroundColor = .white
        // # 2
        addSubviews()
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUI
extension DeveloperCell {
    func setDeveloper(cell: DeveloperModel) {
        DispatchQueue.main.async { [ weak self ] in
            // # 1
            guard let self else {
                return
            }
            // # 2
            idLabel.text = "id: \(cell.id)"
            nameLabel.text = "Name: \(cell.name)"
            // # 3
            if let developerPhoto = cell.image {
                photoImg.sd_setImage(with: URL(string: developerPhoto))
            } else {
                photoImg.image = UIImage(systemName: "camera")?.withTintColor(.black, renderingMode: .alwaysOriginal) ?? UIImage()
            }
        }
    }
}

// MARK: - AddSubviews
private extension DeveloperCell {
    func addSubviews() {
        contentView.addSubview(photoImg)
        contentView.addSubview(idLabel)
        contentView.addSubview(nameLabel)
    }
}

// MARK: - Constraints
private extension DeveloperCell {
    func constraints() {
        NSLayoutConstraint.activate([
            photoImg.centerYAnchor.constraint(equalTo: centerYAnchor),
            photoImg.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            photoImg.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3),
            photoImg.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.6),
            
            idLabel.topAnchor.constraint(equalTo: photoImg.topAnchor),
            idLabel.leadingAnchor.constraint(equalTo: photoImg.trailingAnchor, constant: 8),
            idLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: idLabel.bottomAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: photoImg.trailingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
        ])
        photoImg.layer.cornerRadius = 10
        photoImg.clipsToBounds = true
    }
}

