import UIKit

extension UIBezierPath {

    class func rect(_ rect: CGRect, cornerRadius: CGFloat = 0) -> UIBezierPath {

        return UIBezierPath.init(roundedRect: rect, cornerRadius: cornerRadius)
    }
}
