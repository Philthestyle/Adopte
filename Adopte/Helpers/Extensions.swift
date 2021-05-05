//
//  Extensions.swift
//  Maya
//
//  Created by Ptitin on 10/11/2020.
//  Copyright © 2020 Faustin Veyssiere. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation



extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}

extension Int64 {
    var toDate: Date {
        return Date(milliseconds: self)
    }
}


extension UICollectionView {
    var visibleCurrentCellIndexPath: IndexPath? {
        for cell in self.visibleCells {
            let indexPath = self.indexPath(for: cell)
            return indexPath
        }
        
        return nil
    }
}






// MARK: - Date

extension Int64 {
    func dateDuJour(givenDate: Date) -> String {
        let aujourdHui = givenDate
        let formatDate = DateFormatter()
        formatDate.dateStyle = .short
        formatDate.timeStyle = .short
        formatDate.locale = Locale(identifier: "FR.fr")
        print ( "aujourd'hui : ",formatDate.string(from:aujourdHui))
        formatDate.locale = Locale.autoupdatingCurrent
        print ( "aujourd'hui : ",formatDate.string(from:aujourdHui))
        return formatDate.string(from:aujourdHui)
    }
    func dateDuJourCourt(givenDate: Date) -> String {
        let aujourdHui = givenDate
        let formatDate = DateFormatter()
        formatDate.dateStyle = .medium
        formatDate.timeStyle = .short
        formatDate.locale = Locale(identifier: "FR.fr")
        print ( "aujourd'hui : ",formatDate.string(from:aujourdHui))
        formatDate.locale = Locale.autoupdatingCurrent
        print ( "aujourd'hui : ",formatDate.string(from:aujourdHui))
        return formatDate.string(from:aujourdHui)
    }
}


extension Double {
    func getDateStringFromUTC() -> String {
        let date = Date(timeIntervalSince1970: self)
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateStyle = .medium
        
        return dateFormatter.string(from: date)
    }
}

extension Int {
    var boolValue: Bool {
        return self != 0
    }
}


extension Double {
    func asString(style: DateComponentsFormatter.UnitsStyle) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second, .nanosecond]
        formatter.unitsStyle = style
        guard let formattedString = formatter.string(from: self) else { return "" }
        return formattedString
    }
    
}
extension Date {
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}


extension UIImage {

    func resize(maxWidthHeight : Double)-> UIImage? {

        let actualHeight = Double(size.height)
        let actualWidth = Double(size.width)
        var maxWidth = 0.0
        var maxHeight = 0.0

        if actualWidth > actualHeight {
            maxWidth = maxWidthHeight
            let per = (100.0 * maxWidthHeight / actualWidth)
            maxHeight = (actualHeight * per) / 100.0
        }else{
            maxHeight = maxWidthHeight
            let per = (100.0 * maxWidthHeight / actualHeight)
            maxWidth = (actualWidth * per) / 100.0
        }

        let hasAlpha = true
        let scale: CGFloat = 0.0

        UIGraphicsBeginImageContextWithOptions(CGSize(width: maxWidth, height: maxHeight), !hasAlpha, scale)
        self.draw(in: CGRect(origin: .zero, size: CGSize(width: maxWidth, height: maxHeight)))

        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage
    }

}


extension Date {
    func toString() -> String {
        /* Get current date */
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy h:mm a"
        let result: String = formatter.string(from: self)
        return result
    }
    
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
}




// MARK: - Dictionnary
extension Dictionary {
    var JSON: Data {
        do {
            return try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
        } catch {
            return Data()
        }
    }
}


// MARK: String
extension String {
    /* String --> to 'Date' */
    func toDate(withFormat format: String = "yyyy-MM-dd") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        guard let date = dateFormatter.date(from: self) else {
            preconditionFailure("Take a look to your format")
        }
        return date
    }
    /* String --> to 'Double' */
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
    
    func toInt() -> Int? {
        return NumberFormatter().number(from: self)?.intValue
    }
    
    
    /* String --> barrer la string */
    func strikeThroughAttributedStr() -> NSAttributedString {
        let attributeString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0,attributeString.length))
        return attributeString
    }
    
    /* String --> barrer la string */
    func strikeThrough() -> String {
        var struck = ""
        let strikeChar: Character = "\u{0336}"
        self.forEach { (char) in
            var xchar = UnicodeScalarView(char.unicodeScalars)
            xchar.append(strikeChar.unicodeScalars.first!)
            struck.append(String(xchar))
        }
        return struck
    }
}




// MARK: - UIButton
extension UIButton {
    func show() {
        self.isHidden = false
    }
    func hide() {
        self.isHidden = true
    }
}


// MARK: - UIView
extension UIView {
    /* CornerRadius */
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    /* borderWidth */
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    /* borderColor */
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    
    
    func enableZoom() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(startZooming(_:)))
        isUserInteractionEnabled = true
        addGestureRecognizer(pinchGesture)
    }
    @objc private func startZooming(_ sender: UIPinchGestureRecognizer) {
        let scaleResult = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)
        guard let scale = scaleResult, scale.a > 1, scale.d > 1 else { return }
        sender.view?.transform = scale
        sender.scale = 1
    }
}


// MARK: - UIColor
extension UIColor {
    func colorFromHexString (_ hex:String) -> UIColor {
        var colorString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (colorString.hasPrefix("#")) {
            colorString.remove(at: colorString.startIndex)
        }
        if ((colorString.count) != 6) {
            return UIKit.UIColor.gray
        }
        var rgbValue:UInt32 = 0
        Scanner(string: colorString).scanHexInt32(&rgbValue)
        return UIKit.UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
}



// MARK: - IMAGE
extension UIImage {
    class func colorForNavBar(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    class func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1)
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0.0)
        
        color.setFill()
        UIRectFill(rect)
        let image : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    func tint(with fillColor: UIColor) -> UIImage? {
        let image = withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        fillColor.set()
        image.draw(in: CGRect(origin: .zero, size: size))
        
        guard let imageColored = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        
        UIGraphicsEndImageContext()
        return imageColored
    }
}











// MARK: - iPhones Sizes
extension UIDevice {
    var iPhoneX: Bool { UIScreen.main.nativeBounds.height == 2436 }
    var iPhone: Bool { UIDevice.current.userInterfaceIdiom == .phone }
    var iPad: Bool { UIDevice().userInterfaceIdiom == .pad }
    enum ScreenType: String {
        case iPhones_4_4S = "iPhone 4 or iPhone 4S"
        case iPhones_5_5s_5c_SE = "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE"
        case iPhones_6_6s_7_8 = "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8"
        case iPhones_6Plus_6sPlus_7Plus_8Plus = "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus"
        case iPhones_X_XS = "iPhone X or iPhone XS"
        case iPhone_XR_11 = "iPhone XR or iPhone 11"
        case iPhone_XSMax_ProMax = "iPhone XS Max or iPhone Pro Max"
        case iPhone_11Pro = "iPhone 11 Pro"
        case iPhone_12_Mini = "iPhone 12 Mini"
        case unknown
    }
    var screenType: ScreenType {
        switch UIScreen.main.nativeBounds.height {
        case 1136:
            return .iPhones_5_5s_5c_SE
        case 1334:
            return .iPhones_6_6s_7_8
        case 1792:
            return .iPhone_XR_11
        case 1920, 2208:
            return .iPhones_6Plus_6sPlus_7Plus_8Plus
        case 2426:
            return .iPhone_11Pro
        case 2436:
            return .iPhones_X_XS
        case 2688:
            return .iPhone_XSMax_ProMax
        case 2340:
            return .iPhone_12_Mini
        default:
            return .unknown
        }
    }
    
}

// MARK: - Double
extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}


extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        self.clipsToBounds = true  // add this to maintain corner radius
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
            let colorImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.setBackgroundImage(colorImage, for: forState)
        }
    }
}


// Image extension
extension UIImage {

    func updateImageOrientionUpSide() -> UIImage? {
        if self.imageOrientation == .up {
            return self
        }

        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        if let normalizedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return normalizedImage
        }
        UIGraphicsEndImageContext()
        return nil
    }
}


extension String {

    static func random(length: Int = 20) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        var randomString: String = ""

        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
}


extension UIView {
    
    func addInstaGradientCircle(_ width: CGFloat) {
        let gradient = CAGradientLayer()
        gradient.frame =  CGRect(origin: CGPoint.zero, size: bounds.size)
//        let colors: [CGColor] = [#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.6707143988, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.6707143988, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.1108577115, blue: 0.35177223, alpha: 1), #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 1, green: 0.6666666667, blue: 0, alpha: 1)]
        
//        let colors: [CGColor] = [#colorLiteral(red: 0.4241917189, green: 0.3793904327, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.6914889536, green: 0.2075678417, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 1, green: 0.5436540512, blue: 0, alpha: 1)]
        
        let colors: [CGColor] = [#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.4901960784, green: 0.4784313725, blue: 1, alpha: 1), #colorLiteral(red: 0.4366561525, green: 0.4936778611, blue: 1, alpha: 1), #colorLiteral(red: 0.428403765, green: 0.5393776298, blue: 1, alpha: 1)]
        gradient.colors = colors
        gradient.startPoint = CGPoint(x: 1.5, y: 0.5)
        gradient.endPoint = CGPoint(x: 0.0, y: 0.5)
        
//        gradient.startPoint = CGPoint(x: 0.5, y: 0.5)
//        gradient.endPoint = CGPoint(x: 0.0, y: 0.5)
        
        let cornerRadius = frame.size.width / 2
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        
        let shape = CAShapeLayer()
        let path = UIBezierPath(ovalIn: bounds)
        
        shape.lineWidth = width
        shape.path = path.cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor // clear
        gradient.mask = shape
        
        layer.insertSublayer(gradient, below: layer)
    }
    
    func addInstagramStyleRainbowCircle(_ width: CGFloat) {
        let gradient = CAGradientLayer()
        gradient.frame =  CGRect(origin: CGPoint.zero, size: bounds.size)
        let colors: [CGColor] = [#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.6707143988, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.6707143988, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.1108577115, blue: 0.35177223, alpha: 1), #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 1, green: 0.6666666667, blue: 0, alpha: 1)]
        gradient.colors = colors
        gradient.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradient.endPoint = CGPoint(x: 0.0, y: 0.5)
        let cornerRadius = frame.size.width / 2
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        let shape = CAShapeLayer()
        let path = UIBezierPath(ovalIn: bounds)
        shape.lineWidth = width
        shape.path = path.cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor // clear
        gradient.mask = shape
        layer.insertSublayer(gradient, below: layer)
    }
    
    
    
    
}


extension UIApplication {
    var isBackground: Bool {
        return UIApplication.shared.applicationState == .background
    }
}


extension Int {
    
    var toCGFloat: CGFloat {
        return CGFloat(self)
    }
    
}


extension UIButton {
    var withShadow: UIButton {
        
        let buttonWithShadow: UIButton = self
        buttonWithShadow.layer.borderWidth = 0.5
        buttonWithShadow.layer.borderColor = UIColor.gray.cgColor
        buttonWithShadow.layer.shadowColor = UIColor.black.cgColor
        buttonWithShadow.layer.shadowOffset = CGSize(width: 0, height: 2)
        buttonWithShadow.layer.shadowOpacity = 1.0
        buttonWithShadow.layer.shadowRadius = 0
        buttonWithShadow.layer.masksToBounds = false
        
        return buttonWithShadow
    }
    
}


extension UIView {
    func setAllSideShadow(shadowShowSize: CGFloat = 1.0) { // this method adds shadow to allsides
        let shadowSize : CGFloat = shadowShowSize
        let shadowPath = UIBezierPath(rect: CGRect(x: -shadowSize / 2,
                                                   y: -shadowSize / 2,
                                                   width: self.frame.size.width + shadowSize,
                                                   height: self.frame.size.height + shadowSize))
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.darkGray.withAlphaComponent(0.8).cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowPath = shadowPath.cgPath
    }
}


extension CGRect
{
    /** Creates a rectangle with the given center and dimensions
    - parameter center: The center of the new rectangle
    - parameter size: The dimensions of the new rectangle
     */
    init(center: CGPoint, size: CGSize)
    {
        self.init(x: center.x - size.width / 2, y: center.y - size.height / 2, width: size.width, height: size.height)
    }
    
    /** the coordinates of this rectangles center */
    var center: CGPoint
        {
        get { return CGPoint(x: centerX, y: centerY) }
        set { centerX = newValue.x; centerY = newValue.y }
    }
    
    /** the x-coordinate of this rectangles center
    - note: Acts as a settable midX
    - returns: The x-coordinate of the center
     */
    var centerX: CGFloat
        {
        get { return midX }
        set { origin.x = newValue - width * 0.5 }
    }
    
    /** the y-coordinate of this rectangles center
     - note: Acts as a settable midY
     - returns: The y-coordinate of the center
     */
    var centerY: CGFloat
        {
        get { return midY }
        set { origin.y = newValue - height * 0.5 }
    }
    
    // MARK: - "with" convenience functions
    
    /** Same-sized rectangle with a new center
    - parameter center: The new center, ignored if nil
    - returns: A new rectangle with the same size and a new center
     */
    func with(center: CGPoint?) -> CGRect
    {
        return CGRect(center: center ?? self.center, size: size)
    }
    
    /** Same-sized rectangle with a new center-x
    - parameter centerX: The new center-x, ignored if nil
    - returns: A new rectangle with the same size and a new center
     */
    func with(centerX: CGFloat?) -> CGRect
    {
        return CGRect(center: CGPoint(x: centerX ?? self.centerX, y: centerY), size: size)
    }

    /** Same-sized rectangle with a new center-y
    - parameter centerY: The new center-y, ignored if nil
    - returns: A new rectangle with the same size and a new center
     */
    func with(centerY: CGFloat?) -> CGRect
    {
        return CGRect(center: CGPoint(x: centerX, y: centerY ?? self.centerY), size: size)
    }
    
    /** Same-sized rectangle with a new center-x and center-y
    - parameter centerX: The new center-x, ignored if nil
    - parameter centerY: The new center-y, ignored if nil
    - returns: A new rectangle with the same size and a new center
     */
    func with(centerX: CGFloat?, centerY: CGFloat?) -> CGRect
    {
        return CGRect(center: CGPoint(x: centerX ?? self.centerX, y: centerY ?? self.centerY), size: size)
    }
}


extension CAShapeLayer {
    func drawCircleAtLocation(location: CGPoint, withRadius radius: CGFloat, andColor color: UIColor, filled: Bool) {
        fillColor = filled ? color.cgColor : UIColor.white.cgColor
        strokeColor = color.cgColor
        let origin = CGPoint(x: location.x - radius, y: location.y - radius)
        path = UIBezierPath(ovalIn: CGRect(origin: origin, size: CGSize(width: radius * 2, height: radius * 2))).cgPath
    }
}



extension UIDevice {
    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}


extension String {
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
//        ^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$
       
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
}


extension UIView {
    func addBlurEffect(style: UIBlurEffect.Style) {
        let blurEffectObject = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffectObject)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 1.0
        self.addSubview(blurEffectView)
    }
}


extension Notification.Name {
    static let historyVCCollectionHasScrolled = Notification.Name("historyVCCollectionHasScrolled")
    static let appHasBeenKilled = Notification.Name("appKilled")
    static let historyRunCommentsVCCollectionViewHasScrolled = Notification.Name("historyRunCommentsVCCollectionViewHasScrolled")
}





extension UITextField
{
    open override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = 3.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.red.cgColor
        self.layer.masksToBounds = true
    }
}

extension Date {
    func toFrenchClassicString() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.dateFormat = "d/MM à HH:mm"
        let stringToBeReturned: String = formatter.string(from: self)
        return stringToBeReturned
    }
}














//MARK: A */

//MARK: B */

//MARK: C */

//MARK: D */

//MARK: E */

//MARK: F */

//MARK: G */

//MARK: H */

//MARK: I */

//MARK: J */

//MARK: K */

//MARK: L */
    
//MARK: M */

//MARK: N */

//MARK: O */

//MARK: P */

//MARK: Q */

//MARK: R */

//MARK: S */

//MARK: T */

//MARK: U */


//MARK: V */

//MARK: W */

//MARK: X */

//MARK: Y */

//MARK: Z */


extension UICollectionView {
    func scrollToLastWithOffset(offsetEnPlus: CGFloat) {
        guard numberOfSections > 0 else {
            return
        }

        let contentHeight: CGFloat = self.contentSize.height
        let heightAfterInserts: CGFloat = self.frame.size.height - (self.contentInset.top + self.contentInset.bottom)
        if contentHeight > heightAfterInserts {
            self.setContentOffset(CGPoint(x: 0, y: self.contentSize.height - self.frame.size.height + offsetEnPlus), animated: false)
           
        }
    }
    
    func scrollToBottomClassic(isAnimated: Bool) {
        guard numberOfSections > 0 else {
            return
        }

        let contentHeight: CGFloat = self.contentSize.height
        let heightAfterInserts: CGFloat = self.frame.size.height - (self.contentInset.top + self.contentInset.bottom)
        if contentHeight > heightAfterInserts {
            self.setContentOffset(CGPoint(x: 0, y: self.contentSize.height - self.frame.size.height), animated: isAnimated)
            
        }
    }
}


extension UIView {

    /// Returns a collection of constraints to anchor the bounds of the current view to the given view.
    ///
    /// - Parameter view: The view to anchor to.
    /// - Returns: The layout constraints needed for this constraint.
    func constraintsForAnchoringTo(boundsOf view: UIView) -> [NSLayoutConstraint] {
        return [
            topAnchor.constraint(equalTo: view.topAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor)
        ]
    }
}


class TextField: UITextField {

    var padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}


extension Date {
    func toStringFR() -> String {
        /* Get current date */
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.dateFormat = "d MMM à HH:mm"
        let result: String = formatter.string(from: self)
        return result
    }
}


extension String {
    func capitalizingFirstLetter() -> String {
      return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
      self = self.capitalizingFirstLetter()
    }
}


// MARK:- Notification names
extension Notification.Name {
    /// Notification when user successfully sign in using Google
    static var signInGoogleCompleted: Notification.Name {
        return .init(rawValue: #function)
    }
}
