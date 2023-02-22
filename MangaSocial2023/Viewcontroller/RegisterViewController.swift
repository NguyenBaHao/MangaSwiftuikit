//
//  SignUpViewController.swift
//  MangaSocial2023
//
//  Created by nguyenbahao on 31/01/2023.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var PhoneEmailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var ConfirmpasswordTextField: UITextField!
    
    @IBAction func BackApp(){
        self.dismiss(animated: true)
    }
    @IBAction func Dangnhap(){
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        layernameTextField()
        layerPhoneEmailTextField()
        layerpaswwordTextField()
        layerConfirmpasswordTextField()
        
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func SignUpClick(_ sender: UIButton) {
        if (PhoneEmailTextField.text?.contains(".")) == false{
            self.showAlert(title: "Alert", message:"Please Input Email")
            return
        }
        if (PhoneEmailTextField.text?.contains("@")) == false{
            self.showAlert(title: "Alert", message:"Please Input Email")
            return
        }
        if (nameTextField.text?.isEmpty)!{
            self.showAlert(title: "Alert", message:"Please Input Name")
            return
        }
        if (PhoneEmailTextField.text?.isEmpty)! {
            self.showAlert(title: "Alert", message:"Please Input Phone Number")
            return
        }
        if (passwordTextField.text?.isEmpty)! {
            self.showAlert(title: "Alert", message:"Please Input Password")
            return
        }
        if (ConfirmpasswordTextField.text?.isEmpty)!{
            self.showAlert(title: "Alert", message:"All fields are quired to fill in")
            return
        }
        guard let name = self.nameTextField.text else {return}
        guard let PhoneEmail = self.PhoneEmailTextField.text else {return}
        guard let password = self.passwordTextField.text else {return}
        guard let confirmpassword = self.ConfirmpasswordTextField.text else {return}
        if (password.count) < 4 && (password.count > 50) {
            self.showAlert(title: "Alert", message: "Password Must Less 4 Char")
            return
        }
        let register = RegisterModel(name: name, email: PhoneEmail, password: password)
        if password == confirmpassword {
            APIService.shared.PostRegister(register: register, completionHandler: {
                (isSuccess, str) in
                if isSuccess.code == 200{
                    self.showAlert(title: "Alert Verify", message: "Check Email For Verify")
                    let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                }else{
                    self.showAlert(title: "Alert", message: isSuccess.message)
                }
            })
        }else{
            self.showAlert(title: "Alert", message: "Confirm Password Input")
        }
    }
    func layernameTextField(){
        nameTextField.addLayer()
        nameTextField.leftViewMode = .always
        nameTextField.leftView = UIView(frame: CGRect(x:0,y:0,width:10,height:0))
    }
    func layerPhoneEmailTextField(){
        PhoneEmailTextField.addLayer()
        PhoneEmailTextField.leftViewMode = .always
        PhoneEmailTextField.leftView = UIView(frame: CGRect(x:0,y:0,width:10,height:0))
    }
    func layerpaswwordTextField(){
        passwordTextField.addLayer()
        passwordTextField.leftViewMode = .always
        passwordTextField.leftView = UIView(frame: CGRect(x:0,y:0,width:10,height:0))
    }
    func layerConfirmpasswordTextField(){
        ConfirmpasswordTextField.addLayer()
        ConfirmpasswordTextField.leftViewMode = .always
        ConfirmpasswordTextField.leftView = UIView(frame: CGRect(x:0,y:0,width:10,height:0))
    }
    
}
