//
//  ProfileViewController.swift
//  MangaSocial2023
//
//  Created by nguyenbahao on 06/02/2023.
//

import UIKit

class ProfileViewController: UIViewController{

    @IBOutlet weak var NameTextField: UITextField!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var Name2: UILabel!
    @IBOutlet weak var StackView: UIStackView!
    var info:[ProfileUserModel] = [ProfileUserModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        layernameTextField()
        layerPhoneEmailTextField()
        layerpaswwordTextField()
        dump(self.info)
        StackView.layer.cornerRadius = 20
//        self.Name2.text = self.info[0].name

        self.getInfoUser(){_,_ in

               }
        
        // Do any additional setup after loading the view.
    }

    func getInfoUser(andCompletion completion:@escaping (_ moviesResponse: [ProfileUserModel], _ error: Error?) -> ()) {
        APIService.shared.GetProfileuser{ (response, error) in
            if let listData = response{
                self.info = listData
                DispatchQueue.main.sync {
//                    dump(self.info)
                }
            }
            completion(self.info, error)
        }
    }
    func layernameTextField(){
        NameTextField.addLayer()

        NameTextField.leftViewMode = .always
        NameTextField.leftView = UIView(frame: CGRect(x:0,y:0,width:10,height:0))
    }
    func layerPhoneEmailTextField(){
        EmailTextField.addLayer()

        EmailTextField.leftViewMode = .always
        EmailTextField.leftView = UIView(frame: CGRect(x:0,y:0,width:10,height:0))
    }
    func layerpaswwordTextField(){
        passwordTextField.addLayer()

        passwordTextField.leftViewMode = .always
        passwordTextField.leftView = UIView(frame: CGRect(x:0,y:0,width:10,height:0))
    }

}
