//
//  ForgotPasswordViewController.swift
//  CRL Airport
//
//  Created by LeeJongMin on 17/01/2018.
//  Copyright © 2018 flymax. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "btn-BackChevron")!.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.onClickBack(_:)))
    }
    @IBAction func onClickBack(_ sender: AnyObject) {
        dismiss(animated: false, completion: nil)
    }

    @IBAction func onClickReset(_ sender: Any) {
//        guard let email = txtEmail.text?.trim(), email.count > 0 else {
//            Utils.msgBox(self, title: "Error", message: "Email is required.")
//            return
//        }
//        guard Utils.isValidEmail(email) else {
//            Utils.msgBox(self, title: "Error", message: "Invalid email!")
//            return
//        }
//        ServerAPI.forgotPassword(email, success: {
//            (op, resObj) in
//            Utils.msgBox(self, message: Utils.string(resObj?["message"]), handler:{
//                action in
//                self.dismiss(animated: false, completion: nil)
//            })
//            
//        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
