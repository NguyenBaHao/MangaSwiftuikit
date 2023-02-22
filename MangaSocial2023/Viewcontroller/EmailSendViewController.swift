//
//  EmailSendViewController.swift
//  MangaSocial2023
//
//  Created by nguyenbahao on 31/01/2023.
//

import UIKit

class EmailSendViewController: UIViewController {

    @IBOutlet weak var emailSendTextField: UITextField!
    @IBAction func BackApp(){
        self.dismiss(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        layeremailSendTextField()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func SendEmail(_ sender: Any) {
        guard let email = emailSendTextField.text else {return}
        let verufyaccount = Verufyaccount(email: email)
        APIService.shared.PostVerufyaccount(verufyaccount: verufyaccount) { (result) in
            switch result{
            case .success(let json):
                print(json as AnyObject)
                self.showAlert(title: "Alert", message: "Kiểm tra Email")

            case .failure(let err):
                print(err.localizedDescription)
        }
    }

    }
    
    func layeremailSendTextField(){
        emailSendTextField.addLayer()
        emailSendTextField.leftViewMode = .always
        emailSendTextField.leftView = UIView(frame: CGRect(x:0,y:0,width:10,height:0))
    }
}
