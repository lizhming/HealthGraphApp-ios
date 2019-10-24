//
//  LoginViewController.swift
//  CRL Airport
//
//  Created by LeeJongMin on 17/01/2018.
//  Copyright © 2018 flymax. All rights reserved.
//

import UIKit
import KYDrawerController
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
import FirebaseAuth

class LoginViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    let fbLoginMgr = FBSDKLoginManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        GIDSignIn.sharedInstance().delegate=self
//        GIDSignIn.sharedInstance().uiDelegate=self

//        if GIDSignIn.sharedInstance().hasAuthInKeychain(){ //로그인 되었으면
//            if let user = GIDSignIn.sharedInstance().currentUser {
//                Log.debug(user.userID)
//                Log.debug(user.profile.name)
//            }
//            else{
//                GIDSignIn.sharedInstance().signIn()
//            }
//
//        }
        if let _ = UserDefaults.standard.string(forKey: "GDPR") {
            Log.debug("GDPR")
        }
        else {
            DispatchQueue.main.async {
                let storyBoard: UIStoryboard = UIStoryboard(name: "Login" , bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "TermsAndCondNavViewController")
                self.present(newViewController, animated:  true, completion: nil)
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickFacebook(_ sender: Any) {
        fbLoginMgr.logIn(withReadPermissions: ["email"], from: self) { (facebookResult: FBSDKLoginManagerLoginResult?, facebookError:Error?) in
            if facebookError != nil {
                print("Facebook login failed. Error \(facebookError)")
            } else if !(facebookResult?.isCancelled)!{
                let accessToken = FBSDKAccessToken.current().tokenString
                print("Successfully logged in with facebook. \(accessToken)")
            }
            }
    }
    @IBAction func onClickGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
        
    }
    
    //MARK:Google SignIn Delegate
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //completed sign In
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            
            Log.debug(email)
            Log.debug(GIDSignIn.sharedInstance().currentUser.profile.email)
            // ...
        } else {
            print("\(error.localizedDescription)")
        }
    }
    @IBAction func onClickSignin(_ sender: Any) {
        guard let email = txtEmail.text?.trim(), email.count > 0 else {
            Utils.msgBox(self, title: "Error", message: "Email is required.")
            return
        }
        guard Utils.isValidEmail(email) else {
            Utils.msgBox(self, title: "Error", message: "Invalid email!")
            return
        }
        guard let password = txtPassword.text?.trim(), password.count > 0 else{
            Utils.msgBox(self, title: "Error", message: "Password is required.")
            return
        }
        let user = UserInfo()
        user.email = email
        user.password = password
        ServerAPI.userLogin(user, success: { (operation, responseObj) in
            Log.debug(responseObj)
        })
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main" , bundle: nil)
        
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "KYDrawerController") as! KYDrawerController
        self.present(newViewController, animated:  true, completion: nil)
    }
    
    func signIn(_ userInfo: UserInfo){
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func segueLogin(segue: UIStoryboardSegue){
        Log.debug("segueLogin")
    }
}
