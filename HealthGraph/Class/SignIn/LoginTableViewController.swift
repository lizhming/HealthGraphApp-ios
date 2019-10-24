//
//  LoginTableViewController.swift
//  CRL Airport
//
//  Created by LeeJongMin on 04/02/2018.
//  Copyright © 2018 flymax. All rights reserved.
//

import UIKit

import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
import FirebaseAuth
//import KYDrawerController
import Firebase

class LoginTableViewController: UITableViewController , GIDSignInDelegate, GIDSignInUIDelegate {
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    let fbLoginMgr = FBSDKLoginManager()
    let firebaseAuth = Auth.auth()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().delegate=self
        GIDSignIn.sharedInstance().uiDelegate=self
//        DispatchQueue.main.async {
//            if UserData.getUserInfo().userId != "" {
//                self.gotoMain(UserData.getUserInfo())
//            }
//        }
        
//        fbLoginMgr.logOut()
//        if GIDSignIn.sharedInstance().hasAuthInKeychain(){ //로그인 되었으면
//            if let user = GIDSignIn.sharedInstance().currentUser {
//                Log.debug(user.userID)
//                Log.debug(user.profile.name)
//            }
//            else{
//                GIDSignIn.sharedInstance().signIn()
//            }
//
//            //GIDSignIn.sharedInstance().signOut()
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickFacebook(_ sender: Any) {
        fbLoginMgr.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (facebookResult: FBSDKLoginManagerLoginResult?, facebookError:Error?) in
            if facebookError != nil {
//                print("Facebook login failed. Error \(facebookError)")
//                Log.error(facebookError.debugDescription)
            } else if !(facebookResult?.isCancelled)!{
//                let accessToken = FBSDKAccessToken.current().tokenString
//                Log.info(accessToken)
//                print("Successfully logged in with facebook. \(accessToken)")
//                Log.info(facebookResult?.grantedPermissions)
                
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                Auth.auth().signIn(with: credential, completion: { (user, error) in
                    if let error = error{
                        return
                    }
                    self.signIn(source: "facebook", userId: FBSDKAccessToken.current().userID)
//                    Log.debug("-------------" + ()!)
                })
                //self.facebookUserProfile()
            }
        }
    }
    func facebookUserProfile() {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email, id, first_name,last_name,picture{url}"])
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            if ((error) != nil) {
//                print("Error took place: \(error)")
//                Log.error(error.debugDescription)
            }
            else if let result = result as? Dictionary<String, Any>{
//                let userInfo = UserInfo()
//
//                userInfo.firstName = result["first_name"] as! String
//                userInfo.lastName = result["last_name"] as! String
//                if let email = result["email"] as? String{
//                    userInfo.email = email
//                }
//                userInfo.source = "facebook"
//                userInfo.socialId = result["id"] as! String
//                userInfo.tokenId = FBSDKAccessToken.current().tokenString
//
//
//                if let profilePictureObj = result["picture"] as? Dictionary<String, Any> {
//                    let data = profilePictureObj["data"] as! Dictionary<String, Any>
//                    let pictureUrlString  = data["url"] as! String
//                    userInfo.imageUrl = pictureUrlString
//                }
//                self.signInSocial(userInfo)
            }
        })
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
//            let userInfo = UserInfo()
//            userInfo.firstName = user.profile.givenName
//            userInfo.lastName = user.profile.familyName
//            userInfo.email = user.profile.email
//            userInfo.source = "google"
//            userInfo.socialId = user.userID
//            userInfo.tokenId = user.authentication.idToken
//            guard let authentication = user.authentication else {return}
//            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
//            Auth.auth().signIn(with: credential){ (user1, error) in
//                if let error = error{
//                    Log.debug(error)
//                    return
//                }
//                self.signIn(source: "google", userId: user.userID)
////                Log.debug(user.debugDescription)
//            }
            //self.signInSocial(userInfo)
        } else {
            print("\(error.localizedDescription)")
        }
    }
    @IBAction func onClickSignin(_ sender: Any) {
//        guard let email = txtEmail.text?.trim(), email.count > 0 else {
//            Utils.msgBox(self, title: "Error", message: "Email is required.")
//            return
//        }
//        guard Utils.isValidEmail(email) else {
//            Utils.msgBox(self, title: "Error", message: "Invalid email!")
//            return
//        }
//        guard let password = txtPassword.text?.trim(), password.count > 0 else{
//            Utils.msgBox(self, title: "Error", message: "Password is required.")
//            return
//        }
//        let user = UserInfo()
//        user.email = email
//        user.password = password
//        UserData.setUserInfo(user)
//        ServerAPI.userLogin(user, success: { (op, resObj) in
//            Log.debug(resObj)
//            if let resObj = resObj{
//                if resObj["status"] as! String == "Success", let data = resObj["data"] as? Array<[String:Any]> {
//                    //first, get user info.
//                    user.userId = Utils.string(data[0]["userId"])
//                    let names = Utils.string(data[0]["displayName"]).components(separatedBy: " ")
//                    user.firstName = names[0]
//                    if names.count > 1 {
//                        user.lastName = names[1]
//                    }
//                    self.txtPassword.text = ""
//                    self.gotoMain(user)
//                    return
//                }
//                UserData.setUserInfo(UserInfo())
//                //if failure, print the message.
//                Utils.msgBox(self, message: resObj["message"] as! String)
//            }
//        }, failure: { (session, e) in
//            UserData.setUserInfo(UserInfo())
//        })
    }
    func signIn(source: String, userId: String){
        if let user = Auth.auth().currentUser {
//            let userInfo = UserInfo()
//            let names = user.displayName?.components(separatedBy: " ")
//            userInfo.firstName = names![0]
//            userInfo.lastName = ""
//            if let count = names?.count, count > 1 {
//                if let last = names?[1]{
//                    userInfo.lastName = last
//                }
//            }
//            userInfo.email = user.email!
//            userInfo.source = source
//            userInfo.socialId = userId
//            userInfo.tokenId = user.refreshToken!
//            signInSocial(userInfo)
        }
    }
    func signInSocial(_ userInfo: UserInfo){
//        ServerAPI.userSocialSignin(userInfo, success: {
//            (op, resObj) in
//            if let resObj = resObj{
//                if resObj["status"] as! String == "Success" {
//                    //first, get user info.
//                    if let data = resObj["data"] as? NSArray, let info = data[0] as? [String: Any]{
//                        userInfo.userId = "\(info["userId"] as! Int)"
//                    }
//                    self.gotoMain(userInfo)
//                    return
//                }
//                //if failure, print the message.
//                Utils.msgBox(self, message: resObj["message"] as! String)
//            }
//
//        })
    }
    
    func gotoMain(_ userInfo: UserInfo){
//        UserData.setUserInfo(userInfo)
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main" , bundle: nil)
//        let newViewController = storyBoard.instantiateViewController(withIdentifier: "KYDrawerController") as! KYDrawerController
//        self.present(newViewController, animated:  true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
