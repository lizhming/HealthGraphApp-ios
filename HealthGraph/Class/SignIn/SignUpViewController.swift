//
//  SignUpViewController.swift
//  CRL Airport
//
//  Created by LeeJongMin on 17/01/2018.
//  Copyright © 2018 flymax. All rights reserved.
//

import UIKit

enum Gender {
    case male
    case female
}

class SignUpViewController: UIViewController {

    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirm: UITextField!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    var countryCode = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "btn-BackChevron")!.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.onClickBack(_:)))
        navigationItem.rightBarButtonItem = nil
    }
    @IBAction func onClickBack(_ sender: AnyObject) {
        dismiss(animated: false, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickSignUp(_ sender: Any) {
//        guard let firstName = txtFirstName.text?.trim(), firstName.count > 0 else {
//            Utils.msgBox(self, title: "Error", message: "First Name is required.")
//            return
//        }
//        guard let lastName = txtLastName.text?.trim(), lastName.count > 0 else {
//            Utils.msgBox(self, title: "Error", message: "Last Name is required.")
//            return
//        }
//        guard let email = txtEmail.text?.trim(), email.count > 0 else {
//            Utils.msgBox(self, title: "Error", message: "Email is required.")
//            return
//        }
//        guard Utils.isValidEmail(email) else {
//            Utils.msgBox(self, title: "Error", message: "Invalid email!")
//            return
//        }
//        
//        guard let password = txtPassword.text, password.count > 0 else {
//            Utils.msgBox(self, title: "Error", message: "Password is required.")
//            return
//        }
//        guard password.count >= 8 else {
//            Utils.msgBox(self, title: "Error", message: "Please type 8+ characters.")
//            return
//        }
//        guard Utils.isValidPasswordOneNumberOneSpec(password) else {
//            Utils.msgBox(self, title: "Error", message: "Please at least 1 number and at least 1 special character.")
//            return
//        }
//        guard Utils.isValidExceptChar(password) else {
//            Utils.msgBox(self, title: "Error", message: "Invalid special character : <,>,(,),#,',/,|")
//            return
//        }
//        guard let confirm = txtConfirm.text, password == confirm else {
//            Utils.msgBox(self, title: "Error", message: "Password mismatch")
//            return
//        }
//        let user = UserInfo()
//        user.firstName = firstName
//        user.lastName = lastName
//        user.email = email
//        user.password = password
//        user.country = lblCountry.text! == "Country" ? "" : lblCountry.text!
//        user.gender = lblGender.text! == "Gender" ? "" : lblGender.text!
//        user.countryCode = countryCode
//        
//        UserData.setUserInfo(user)
//        ServerAPI.userRegister(user, success: {
//            (op, responseObj ) in
//            if let responseObj = responseObj as? [String: Any]{
//                Log.debug(responseObj["status"])
//                if (responseObj["status"] as! String  == "Success"){
//                    Utils.msgBox(self, message: responseObj["message"] as! String, handler:{
//                        (action) in
//                        self.dismiss(animated: false, completion: nil)
//                    })
//                }
//                Utils.msgBox(self, message: responseObj["message"] as! String)
//            }
//            UserData.setUserInfo(UserInfo())
//        }, failure: { session, error in
//            UserData.setUserInfo(UserInfo())
//        })
    }
    func setGender(_ gender: Gender){
        DispatchQueue.main.async {
            switch gender {
            case .male:
                self.lblGender.text = "Male"
            default:
                self.lblGender.text = "Female"
            }
        }
    }
    @IBAction func onClickGender(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Please select a gender", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction.init(title: "Male", style: UIAlertActionStyle.default, handler: { (action) in
            self.setGender(.male)
        }))
        actionSheet.addAction(UIAlertAction.init(title: "Female", style: UIAlertActionStyle.default, handler: { (action) in
            self.setGender(.female)
        }))
        actionSheet.addAction(UIAlertAction.init(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {(action) in }))
        
//        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
//            NSLog("The \"OK\" alert occured.")
//        }))
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    @IBAction func segueSignup(segue: UIStoryboardSegue){
        //
        if let source = segue.source as? CountryTableViewController {
            lblCountry.text = source.country
            countryCode = source.code
//            Log.debug(source.country)
        }
        
    }
    // MARK: - Navigation
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        Log.debug(sender.debugDescription)
    }*/

}
