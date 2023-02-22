//
//  ExtensionPro.swift
//  CollectionView2Lop
//
//  Created by nguyenhoang on 9/8/21.
//
import Foundation
import UIKit

let register_url = ""
let login_url = "https://api-dev-manga.tozi.vn/api/login"
let Verufyaccount_url  = "https://api-dev-manga.tozi.vn/api/send-verify"
let logout_url  = "https://api-dev-manga.tozi.vn/api/logout"
let info_url = "https://api-dev-manga.tozi.vn/api/info"
let UpdateName_url  = "https://api-dev-manga.tozi.vn/api/user/update-profile"
let ChangePassword_url = "https://api-dev-manga.tozi.vn/api/user/change-password"
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
    func addLayer() {
        layer.cornerRadius = 24
        layer.borderWidth = 1
        layer.borderColor = UIColor(red: 0.039, green: 0.576, blue: 0.588, alpha: 1).cgColor
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
