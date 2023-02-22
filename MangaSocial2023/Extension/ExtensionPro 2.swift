//
//  ExtensionPro.swift
//  CollectionView2Lop
//
//  Created by nguyenhoang on 9/8/21.
//
import Foundation
import UIKit

let register_url = "https://api-dev-manga.tozi.vn/api/sign-up"
let login_url = "https://api-dev-manga.tozi.vn/api/login"
extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

extension UIViewController{
    func showAlert(title: String, message: String, action: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: action)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
