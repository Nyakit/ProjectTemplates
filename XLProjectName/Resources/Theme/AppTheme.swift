import UIKit

public protocol AppTheme {
    func apply()

    // MARK: - Colors

    var white: UIColor { get }
    var black: UIColor { get }

    var alphaLightPurpure: UIColor { get }
    var alphaMiddlePurpure: UIColor { get }
    var alphaDarkPurpure: UIColor { get }
    var alphaRed: UIColor { get }
    var alphaBlue: UIColor { get }

    var defaultFont: AppFont? { get }
}

public struct MainTheme: AppTheme {
    public static var shared: AppTheme = MainTheme()

    public func apply() {
        self.configureNavBar()
        self.configureTextView()
        self.configureCollectionView()
    }

    func configureNavBar() {
        let navbar = UINavigationBar.appearance()
        navbar.isTranslucent = true
        navbar.isOpaque = false
        navbar.titleTextAttributes = [
            .foregroundColor: black,
            .font: UIFont.font(ofSize: 17, weight: .medium)
        ]
        navbar.barTintColor = self.white
        navbar.tintColor = black
    }

    func configureTextView() {
        UITextView.appearance().tintColor = self.black
        UITextField.appearance().tintColor = self.black
    }

    func configureCollectionView() {
        UICollectionView.appearance().isPrefetchingEnabled = false
    }

    // MARK: - Colors

    public var white: UIColor = .white
    public var black: UIColor = #colorLiteral(red: 0.0845035091, green: 0.1472642124, blue: 0.2198270559, alpha: 1)

    public var alphaBlue: UIColor = #colorLiteral(red: 0.5960784314, green: 0.7607843137, blue: 1, alpha: 1)
    public var alphaLightPurpure: UIColor = #colorLiteral(red: 0.3647058824, green: 0.3098039216, blue: 0.5215686275, alpha: 1)
    public var alphaMiddlePurpure: UIColor = #colorLiteral(red: 0.2078431373, green: 0.2117647059, blue: 0.4196078431, alpha: 1)
    public var alphaLightBlue: UIColor = #colorLiteral(red: 0.4823529412, green: 0.6745098039, blue: 0.937254902, alpha: 1)
    public var alphaDarkPurpure: UIColor = #colorLiteral(red: 0.1450980392, green: 0.1490196078, blue: 0.3058823529, alpha: 1)
    public var alphaRed: UIColor = #colorLiteral(red: 0.8901960784, green: 0.2039215686, blue: 0.3176470588, alpha: 1)

    // MARK: - Font

    public var defaultFont: AppFont? = nil
}
