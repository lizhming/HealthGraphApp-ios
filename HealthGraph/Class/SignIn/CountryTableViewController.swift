    //
//  CountryTableViewController.swift
//  CRL Airport
//
//  Created by LeeJongMin on 17/01/2018.
//  Copyright © 2018 flymax. All rights reserved.
//

import UIKit

class CountryTableViewController: UITableViewController {
    var countryList : Array<[String: String]> = []
    var searchResult : Array<[String: String]> = []
    var textFieldInsideSearchBar : UITextField?
    var country = ""
    var code = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        createSearchbar()
        
//        ServerAPI.getCountries(success:{
//            (op, responseObj) in
//            if let responseObj = responseObj as? [String: Any] {
//                self.countryList = responseObj["data"] as! Array<[String : String]>
//                self.reloadTable()
//            }
//        })
    }
    func createSearchbar(){
        let searchBar = UISearchBar.init(frame: CGRect.init(origin: .zero, size: CGSize.init(width: UIScreen.main.bounds.width, height: (navigationController?.navigationBar.frame.size.height)!)))
        searchBar.barTintColor = UIColor.red
        textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.backgroundColor = UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.2)
        textFieldInsideSearchBar?.textColor = UIColor.white
        textFieldInsideSearchBar?.placeholder = "Search"
        textFieldInsideSearchBar?.addTarget(self, action: #selector(self.searchTextDidChange(_:)), for: .editingChanged)
//        textFieldInsideSearchBar?.placeHolderColor = UIColor.init(red: 188/255, green: 190/255, blue: 192/255, alpha: 1.0)
        textFieldInsideSearchBar?.clearButtonMode = .never
        if let textFieldInsideSearchBar = textFieldInsideSearchBar,
            let glassIconView = textFieldInsideSearchBar.leftView as? UIImageView {
            //Magnifying glass
            glassIconView.image = glassIconView.image?.withRenderingMode(.alwaysTemplate)
            glassIconView.tintColor = .white
            if let searchTextField = searchBar.value(forKey:"searchField") as? UITextField, let clearButton = searchTextField.value(forKey:"clearButton") as? UIButton {
                clearButton.setImage(UIImage(named:"ic_clear"), for: .normal)
                clearButton.tintColor = .white
                clearButton.setTitleColor(.red, for: .normal)
            }
        }
        
//        if let iconView = textFieldInsideSearchBar?.leftView as? UIImageView {
//            iconView.image = iconView.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
//            iconView.tintColor = UIColor.red
//        }
        navigationItem.titleView = searchBar
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "btn-BackChevron")!.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(CountryTableViewController.onClickBack(_:)))
    }
    @objc func searchTextDidChange(_ textField: UITextField){
        reloadTable()
    }
    func reloadTable(){
        if let searchStr = textFieldInsideSearchBar?.text{
            if searchStr.count == 0{
                searchResult = countryList
            }
            else{
//                searchResult = countryList.filter{
//                    $0["name_en"]!.contains(findIgnoringCase: searchStr)
//                }
            }
        }
        tableView.reloadData()
    }
    @IBAction func onClickBack(_ sender: AnyObject) {
        
        //self.performSegue(withIdentifier: "segueSignup", sender: self)
        dismiss(animated: false, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchResult.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        }
        cell?.textLabel?.text = searchResult[indexPath.row]["name_en"] //as? String
        // Configure the cell...

        return cell!
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        country = searchResult[indexPath.row]["name_en"]!
        code = searchResult[indexPath.row]["terminalCode"]!
        //segueSignUp
        
        self.performSegue(withIdentifier: "segueSignUp", sender: self)
//        self.dismiss(animated: false, completion: nil)
    }

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
