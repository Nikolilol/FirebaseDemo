//
//  Spinner.swift
//  JanssenCare
//
//  Created by Niko on 8/6/18.
//  Copyright © 2018 Ambrose Silveira. All rights reserved.
//

import UIKit

extension UIViewController{
    /**
     Delegate method for handling touch events outside the keyboard to dismiss it.
     */
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) //NOSONAR
    {
        //to handle sonar cube error. Display number of touches required to dismiss the keybaord
        print("Keyboard Dismissed with touch:\(sender.numberOfTouches)")
        self.view.endEditing(true)
    }
    
    /**
     Extension method for UIActivity indicator to show spinner on multiple controllers.
     */
    func showActivityIndicator(_ message: String? = nil) {
        
        let coverView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        coverView.backgroundColor = .clear
        coverView.tag = 100001
        
        if message == nil {
            //kept for further enhnacement and scalability
            print("No message")
        }
        
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 75, height: 75))
        activityIndicator.backgroundColor = UIColor(white: 0, alpha: 0.6)
        activityIndicator.layer.cornerRadius = 15.0
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.startAnimating()
        //UIApplication.shared.beginIgnoringInteractionEvents()
        activityIndicator.tag = 100
        
        for subview in view.subviews {
            if subview.tag == 100 {
                print("already added")
                return
            }
        }
        
        coverView.addSubview(activityIndicator)
        view.addSubview(coverView)
    }
    
    /**
     Extension method for UIActivity indicator to stop/remove spinner on multiple controllers.
     */
    func hideActivityIndicator() {
        let activityIndicator = view.viewWithTag(100) as? UIActivityIndicatorView
        activityIndicator?.stopAnimating()
        activityIndicator?.removeFromSuperview()
        let coverView = view.viewWithTag(100001)
        coverView?.removeFromSuperview()
        //UIApplication.shared.endIgnoringInteractionEvents()
    }
}

extension UIResponder {
    /// wait with your own animated images
    @discardableResult
    func pleaseWaitWithImages(_ imageNames: Array<UIImage>, timeInterval: Int) -> UIWindow{
        return Spinner.wait(imageNames, timeInterval: timeInterval)
    }
    // api changed from v3.3
    @discardableResult
    func spinnerTop(_ text: String, autoClear: Bool = true, autoClearTime: Int = 1) -> UIWindow{
        return Spinner.spinnerOnStatusBar(text, autoClear: autoClear, autoClearTime: autoClearTime)
    }
    
    // new apis from v3.3
    /**
     The method is used to display error message with the spinner.
     - parameter text: The success message to be shown with the spinner
     - parameter autoClear: Boolean value set to true to clear automatically the error message displayed on the spinner.
     - parameter autoClearTime: Time in integer before the message automatically disappears from the spinner.
     - returns: returns UIWindow to display the spinner with message
     */
    @discardableResult
    func spinnerSuccess(_ text: String, autoClear: Bool = false, autoClearTime: Int = 3) -> UIWindow{
        return Spinner.showSpinnerWithText(SpinnerType.success, text: text, autoClear: autoClear, autoClearTime: autoClearTime)
    }
    /**
     The method is used to display error message with the spinner.
     - parameter text: The error message to be shown
     - parameter autoClear: Boolean value set to true to clear automatically the error message displayed on the spinner.
     - parameter autoClearTime: Time in integer before the message automatically disappears from the spinner.
     - returns: returns UIWindow to display the spinner with message
     */
    @discardableResult
    func spinnerError(_ text: String, autoClear: Bool = false, autoClearTime: Int = 3) -> UIWindow{
        return Spinner.showSpinnerWithText(SpinnerType.error, text: text, autoClear: autoClear, autoClearTime: autoClearTime)
    }
    /**
     The method is used to display error message with the spinner.
     - parameter text: The message to be shown
     - parameter autoClear: Boolean value set to true to clear automatically the error message displayed on the spinner.
     - parameter autoClearTime: Time in integer before the message automatically disappears from the spinner.
     - returns: returns UIWindow to display the spinner with message
     */
    @discardableResult
    func spinnerInfo(_ text: String, autoClear: Bool = false, autoClearTime: Int = 3) -> UIWindow{
        return Spinner.showSpinnerWithText(SpinnerType.info, text: text, autoClear: autoClear, autoClearTime: autoClearTime)
    }
    
    // old apis
    @discardableResult
    func successSpinner(_ text: String, autoClear: Bool = true) -> UIWindow{
        return Spinner.showSpinnerWithText(SpinnerType.success, text: text, autoClear: autoClear, autoClearTime: 3)
    }
    @discardableResult
    func errorSpinner(_ text: String, autoClear: Bool = true) -> UIWindow{
        return Spinner.showSpinnerWithText(SpinnerType.error, text: text, autoClear: autoClear, autoClearTime: 3)
    }
    @discardableResult
    func infoSpinner(_ text: String, autoClear: Bool = true) -> UIWindow{
        return Spinner.showSpinnerWithText(SpinnerType.info, text: text, autoClear: autoClear, autoClearTime: 3)
    }
    @discardableResult
    func spinner(_ text: String, type: SpinnerType, autoClear: Bool, autoClearTime: Int = 3) -> UIWindow{
        return Spinner.showSpinnerWithText(type, text: text, autoClear: autoClear, autoClearTime: autoClearTime)
    }
    @discardableResult
    func pleaseWait() -> UIWindow{
        return Spinner.wait()
    }
    @discardableResult
    func spinnerOnlyText(_ text: String) -> UIWindow{
        return Spinner.showText(text)
    }
    func clearAllSpinner() {
        Spinner.clear()
    }
}

/**
 The values sets the spinner type to either success, error or just information message for the particular action at the app side.
 */
enum SpinnerType{
    case success
    case error
    case info
}

class Spinner: NSObject {
    
    static var windows = Array<UIWindow?>()
    static let rv = UIApplication.shared.keyWindow?.subviews.first as UIView?
    static var timer: DispatchSource!
    static var timerTimes = 0
    
    /*
     just for iOS 8
     --Comment by Ambrose--Are we supporting iOS 8? This code is not required.
     */
    static var degree: Double {
        get {
            return [0, 0, 180, 270, 90][UIApplication.shared.statusBarOrientation.hashValue] as Double
        }
    }
    
    static func clear() {
        self.cancelPreviousPerformRequests(withTarget: self)
        if let _ = timer {
            timer.cancel()
            timer = nil
            timerTimes = 0
        }
        windows.removeAll(keepingCapacity: false)
    }
    
    @discardableResult
    static func spinnerOnStatusBar(_ text: String, autoClear: Bool, autoClearTime: Int) -> UIWindow{
        let frame = UIApplication.shared.statusBarFrame
        let window = UIWindow()
        window.backgroundColor = UIColor.clear
        let view = UIView()
        view.backgroundColor = UIColor(red: 0x6a/0x100, green: 0xb4/0x100, blue: 0x9f/0x100, alpha: 1)
        
        let label = UILabel(frame: frame.height > 20 ? CGRect(x: frame.origin.x, y: frame.origin.y + frame.height - 17, width: frame.width, height: 20) : frame)
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.white
        label.text = text
        view.addSubview(label)
        
        window.frame = frame
        view.frame = frame
        
        if let version = Double(UIDevice.current.systemVersion),
            version < 9.0 {
            // change center
            var array = [UIScreen.main.bounds.width, UIScreen.main.bounds.height]
            array = array.sorted(by: <)
            let screenWidth = array[0]
            let screenHeight = array[1]
            let x = [0, screenWidth/2, screenWidth/2, 10, screenWidth-10][UIApplication.shared.statusBarOrientation.hashValue] as CGFloat
            let y = [0, 10, screenHeight-10, screenHeight/2, screenHeight/2][UIApplication.shared.statusBarOrientation.hashValue] as CGFloat
            window.center = CGPoint(x: x, y: y)
            
            // change direction
            window.transform = CGAffineTransform(rotationAngle: CGFloat(degree * Double.pi / 180))
        }
        
        window.windowLevel = UIWindowLevelStatusBar
        window.isHidden = false
        window.addSubview(view)
        windows.append(window)
        
        var origPoint = view.frame.origin
        origPoint.y = -(view.frame.size.height)
        let destPoint = view.frame.origin
        view.tag = 1001
        
        view.frame = CGRect(origin: origPoint, size: view.frame.size)
        UIView.animate(withDuration: 0.3, animations: {
            view.frame = CGRect(origin: destPoint, size: view.frame.size)
        }, completion: { b in
            if autoClear {
                self.perform(.hideNotice, with: window, afterDelay: TimeInterval(autoClearTime))
            }
        })
        return window
    }
    
    @discardableResult
    static func wait(_ imageNames: Array<UIImage> = Array<UIImage>(), timeInterval: Int = 0) -> UIWindow {
        let frame = CGRect(x: 0, y: 0, width: 78, height: 78)
        let window = UIWindow()
        window.backgroundColor = UIColor.clear
        let mainView = UIView()
        mainView.layer.cornerRadius = 12
        mainView.backgroundColor = UIColor(red:0, green:0, blue:0, alpha: 0.8)
        
        if imageNames.count > 0 {
            if imageNames.count > timerTimes {
                let iv = UIImageView(frame: frame)
                iv.image = imageNames.first!
                iv.contentMode = UIViewContentMode.scaleAspectFit
                mainView.addSubview(iv)
                timer = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags(rawValue: UInt(0)), queue: DispatchQueue.main) as! DispatchSource
                timer.schedule(deadline: DispatchTime.now(), repeating: DispatchTimeInterval.milliseconds(timeInterval))
                timer.setEventHandler(handler: { () -> Void in
                    let name = imageNames[timerTimes % imageNames.count]
                    iv.image = name
                    timerTimes += 1
                })
                timer.resume()
            }
        } else {
            let ai = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
            ai.frame = CGRect(x: 21, y: 21, width: 36, height: 36)
            ai.startAnimating()
            mainView.addSubview(ai)
        }
        
        window.frame = frame
        mainView.frame = frame
        window.center = rv!.center
        
        if let version = Double(UIDevice.current.systemVersion),
            version < 9.0 {
            // change center
            window.center = getRealCenter()
            // change direction
            window.transform = CGAffineTransform(rotationAngle: CGFloat(degree * Double.pi / 180))
        }
        
        window.windowLevel = UIWindowLevelAlert
        window.isHidden = false
        window.addSubview(mainView)
        windows.append(window)
        
        mainView.alpha = 0.0
        UIView.animate(withDuration: 0.2, animations: {
            mainView.alpha = 1
        })
        return window
    }
    
    @discardableResult
    static func showText(_ text: String, autoClear: Bool=true, autoClearTime: Int=2) -> UIWindow {
        let window = UIWindow()
        window.backgroundColor = UIColor.clear
        let mainView = UIView()
        mainView.layer.cornerRadius = 12
        mainView.backgroundColor = UIColor(red:0, green:0, blue:0, alpha: 0.8)
        //label to hold text on the spinner
        let label = UILabel()
        label.text = text
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.white
        let size = label.sizeThatFits(CGSize(width: UIScreen.main.bounds.width-82, height: CGFloat.greatestFiniteMagnitude))
        label.bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        mainView.addSubview(label)
        
        let superFrame = CGRect(x: 0, y: 0, width: label.frame.width + 50 , height: label.frame.height + 30)
        window.frame = superFrame
        mainView.frame = superFrame
        //align/position the label on the center of window.
        label.center = mainView.center
        window.center = rv!.center
        
        if let version = Double(UIDevice.current.systemVersion),
            version < 9.0 {
            // change center
            window.center = getRealCenter()
            // change direction
            window.transform = CGAffineTransform(rotationAngle: CGFloat(degree * Double.pi / 180))
        }
        
        window.windowLevel = UIWindowLevelAlert
        window.isHidden = false
        window.addSubview(mainView)
        windows.append(window)
        
        if autoClear {
            self.perform(.hideNotice, with: window, afterDelay: TimeInterval(autoClearTime))
        }
        return window
    }
    
    //Display spinner with informative text
    @discardableResult
    static func showSpinnerWithText(_ type: SpinnerType,text: String, autoClear: Bool, autoClearTime: Int) -> UIWindow {
        let frame = CGRect(x: 0, y: 0, width: 90, height: 90)
        let window = UIWindow()
        window.backgroundColor = UIColor.clear
        let mainView = UIView()
        mainView.layer.cornerRadius = 10
        mainView.backgroundColor = UIColor(red:0, green:0, blue:0, alpha: 0.7)
        
        var image = UIImage()
        switch type {
        case .success:
            image = SwiftNoticeSDK.imageOfCheckmark
        case .error:
            image = SwiftNoticeSDK.imageOfCross
        case .info:
            image = SwiftNoticeSDK.imageOfInfo
        }
        let checkmarkView = UIImageView(image: image)
        checkmarkView.frame = CGRect(x: 27, y: 15, width: 36, height: 36)
        mainView.addSubview(checkmarkView)
        
        let label = UILabel(frame: CGRect(x: 0, y: 60, width: 90, height: 16))
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.white
        label.text = text
        label.textAlignment = NSTextAlignment.center
        mainView.addSubview(label)
        
        window.frame = frame
        mainView.frame = frame
        window.center = rv!.center
        
        if let version = Double(UIDevice.current.systemVersion),
            version < 9.0 {
            // change center
            window.center = getRealCenter()
            // change direction
            window.transform = CGAffineTransform(rotationAngle: CGFloat(degree * Double.pi / 180))
        }
        
        window.windowLevel = UIWindowLevelAlert
        window.center = rv!.center
        window.isHidden = false
        window.addSubview(mainView)
        windows.append(window)
        
        mainView.alpha = 0.0
        UIView.animate(withDuration: 0.2, animations: {
            mainView.alpha = 1
        })
        
        if autoClear {
            self.perform(.hideNotice, with: window, afterDelay: TimeInterval(autoClearTime))
        }
        return window
    }
    
    // just for iOS 8
    static func getRealCenter() -> CGPoint {
        if UIApplication.shared.statusBarOrientation.hashValue >= 3 {
            return CGPoint(x: rv!.center.y, y: rv!.center.x)
        } else {
            return rv!.center
        }
    }
}

class SwiftNoticeSDK {
    struct Cache {
        static var imageOfCheckmark: UIImage?
        static var imageOfCross: UIImage?
        static var imageOfInfo: UIImage?
    }
    class func draw(_ type: SpinnerType) {
        let checkmarkShapePath = UIBezierPath()
        
        // draw circle
        checkmarkShapePath.move(to: CGPoint(x: 36, y: 18))
        checkmarkShapePath.addArc(withCenter: CGPoint(x: 18, y: 18), radius: 17.5, startAngle: 0, endAngle: CGFloat(Double.pi*2), clockwise: true)
        checkmarkShapePath.close()
        
        switch type {
            // draw checkmark
        case .success:
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 18))
            checkmarkShapePath.addLine(to: CGPoint(x: 16, y: 24))
            checkmarkShapePath.addLine(to: CGPoint(x: 27, y: 13))
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 18))
            checkmarkShapePath.close()
            // draw X
        case .error:
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 10))
            checkmarkShapePath.addLine(to: CGPoint(x: 26, y: 26))
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 26))
            checkmarkShapePath.addLine(to: CGPoint(x: 26, y: 10))
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 10))
            checkmarkShapePath.close()
            //informative message
        case .info:
            checkmarkShapePath.move(to: CGPoint(x: 18, y: 6))
            checkmarkShapePath.addLine(to: CGPoint(x: 18, y: 22))
            checkmarkShapePath.move(to: CGPoint(x: 18, y: 6))
            checkmarkShapePath.close()
            
            UIColor.white.setStroke()
            checkmarkShapePath.stroke()
            
            let checkmarkShapePath = UIBezierPath()
            checkmarkShapePath.move(to: CGPoint(x: 18, y: 27))
            checkmarkShapePath.addArc(withCenter: CGPoint(x: 18, y: 27), radius: 1, startAngle: 0, endAngle: CGFloat(Double.pi*2), clockwise: true)
            checkmarkShapePath.close()
            
            UIColor.white.setFill()
            checkmarkShapePath.fill()
        }
        
        UIColor.white.setStroke()
        checkmarkShapePath.stroke()
    }
    class var imageOfCheckmark: UIImage {
        if (Cache.imageOfCheckmark != nil) {
            return Cache.imageOfCheckmark!
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 36, height: 36), false, 0)
        
        SwiftNoticeSDK.draw(SpinnerType.success)
        
        Cache.imageOfCheckmark = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfCheckmark!
    }
    class var imageOfCross: UIImage {
        if (Cache.imageOfCross != nil) {
            return Cache.imageOfCross!
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 36, height: 36), false, 0)
        
        SwiftNoticeSDK.draw(SpinnerType.error)
        
        Cache.imageOfCross = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfCross!
    }
    class var imageOfInfo: UIImage {
        if (Cache.imageOfInfo != nil) {
            return Cache.imageOfInfo!
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 36, height: 36), false, 0)
        
        SwiftNoticeSDK.draw(SpinnerType.info)
        
        Cache.imageOfInfo = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfInfo!
    }
}

//extension to hide spinner on the new window.
extension UIWindow{
    func hide(){
        Spinner.hideNotice(self)
    }
}

fileprivate extension Selector {
    static let hideNotice = #selector(Spinner.hideNotice(_:))
}

@objc extension Spinner {
    //hide the spinner
    static func hideNotice(_ sender: AnyObject) {
        if let window = sender as? UIWindow {
            
            if let v = window.subviews.first {
                UIView.animate(withDuration: 0.2, animations: {
                    
                    if v.tag == 1001 {
                        v.frame = CGRect(x: 0, y: -v.frame.height, width: v.frame.width, height: v.frame.height)
                    }
                    v.alpha = 0
                }, completion: { b in
                    
                    if let index = windows.index(where: { (item) -> Bool in
                        return item == window
                    }) {
                        windows.remove(at: index)
                    }
                })
            }
            
        }
    }
    
}
