
import UIKit

final class SimpleImageView: UIImageView {
    
    convenience init(imageName: String, contentMode: ContentMode, autoresizingMask: Bool) {
        self.init()
        configure(imageName: imageName, contentMode: contentMode ,autoresizingMask: autoresizingMask)
    }
    
    convenience init(image: UIImage, contentMode: ContentMode, autoresizingMask: Bool) {
        self.init()
        configure(image: image, contentMode: contentMode ,autoresizingMask: autoresizingMask)
    }
}

// MARK: - Private extension
private extension SimpleImageView {
    func configure(imageName: String, contentMode: ContentMode, autoresizingMask: Bool) {
        self.translatesAutoresizingMaskIntoConstraints = autoresizingMask
        self.contentMode = contentMode
        self.image = UIImage(named: imageName)
    }
    
    func configure(image: UIImage, contentMode: ContentMode, autoresizingMask: Bool) {
        self.translatesAutoresizingMaskIntoConstraints = autoresizingMask
        self.contentMode = contentMode
        self.image = image
    }
}
