//
//  LoginViewController.swift
//  HealthGraph
//
//  Created by LeeJongMin on 21/02/2018.
//  Copyright © 2018 flymax. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI

import FirebaseGoogleAuthUI
//import FirebaseFacebookAuthUI
//import FirebaseTwitterAuthUI
//import FirebasePhoneAuthUI

class LoginViewController: UIViewController, FUIAuthDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
  
        let authUI = FUIAuth.defaultAuthUI()
        // You need to adopt a FUIAuthDelegate protocol to receive callback
        authUI?.delegate = self
        let providers: [FUIAuthProvider] = [
            FUIGoogleAuth(),
//            FUIFacebookAuth(),
//            FUITwitterAuth(),
//            FUIPhoneAuth(authUI:FUIAuth.defaultAuthUI()!),
            ]
        authUI?.providers = providers
        DispatchQueue.main.async {
            let authViewController = authUI?.authViewController()
            self.present(authViewController!, animated: true, completion: nil)
        }
        
    }
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        print(Auth.auth().currentUser?.email)
        if let user = Auth.auth().currentUser {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main" , bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "MainTabViewController")
        self.present(newViewController, animated:  true, completion: nil)
        }
        else {
            exit(0)
        }
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
