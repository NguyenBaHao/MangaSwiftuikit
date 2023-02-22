//
//  LoginViewController.swift
//  MangaSocial2023
//
//  Created by nguyenbahao on 31/01/2023.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    
    @IBAction func Dangki(){
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func QuyenMatKhau(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "EmailSendViewController") as! EmailSendViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        layerEmailTextField()
        layerPasswordTextfield()
        if PasswordTextField.text?.count == 0 ||
        EmailTextField.text?.count == 0{
            loginButton.isEnabled = false
        }
        EmailTextField.delegate = self
        PasswordTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func LoginClicked(_ sender: UIButton) {
        guard let email = EmailTextField.text else {return}
        guard let password = PasswordTextField.text else {return}
        if password.count < 8 {
            self.showAlert(title: "Alert", message: "Password must less 8 char")
            return
        }
        let modelLogin = LoginModel(email: email, password: password)
        APIService.shared.PostLoginAPI(login: modelLogin) { (result,error ) in
            if result.code == 200{
                print(result.code)
                let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "UITabBarController") as! UITabBarController
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
                
            }else{
                self.showAlert(title: "Alert", message: result.message)
                return
            }
            
        }
    }
    @IBAction func ClickSavePassword(_ sender: Any) {
        
    }
    @IBAction func GoogleLogin(_ sender: Any) {
        
        
    }
    
    
    @IBAction func FacebookLogin(_ sender: Any) {
        
        
    }
    func layerEmailTextField(){
        EmailTextField.addLayer()
        EmailTextField.leftViewMode = .always
        EmailTextField.leftView = UIView(frame: CGRect(x:0,y:0,width:10,height:0))
        
    }
    func layerPasswordTextfield(){
        PasswordTextField.addLayer()
        PasswordTextField.leftViewMode = .always
        PasswordTextField.leftView = UIView(frame: CGRect(x:0,y:0,width:10,height:0))
    }
    
}
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        loginButton.isEnabled = true
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        loginButton.isEnabled = true
        return true
    }
}
