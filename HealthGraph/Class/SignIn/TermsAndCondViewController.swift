//
//  TermsAndCondViewController.swift
//  CRL Airport
//
//  Created by LeeJongMin on 17/01/2018.
//  Copyright © 2018 flymax. All rights reserved.
//

import UIKit
import WebKit

class TermsAndCondViewController: UIViewController , WKUIDelegate {
    
    var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        
        
        let jscript = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);"
        let userScript = WKUserScript(source: jscript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let wkUController = WKUserContentController()
        wkUController.addUserScript(userScript)
        //        let wkWebConfig = WKWebViewConfiguration()
        webConfiguration.userContentController = wkUController
        //        let yourWebView = WKWebView(frame: self.view.bounds, configuration: wkWebConfig)
        
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "btn-menu")!.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.onClickMenu(_:)))
        navigationItem.leftBarButtonItem?.isEnabled = false
        navigationItem.titleView = UIImageView(image: UIImage(named: "img-Charlerol_Logo")!)
        
        
        let url = URL(string: "https://crl.project-airwafi.com/privacypolicy.html")
        webView.load(URLRequest(url: url!))
    }
    @objc func onClickMenu(_ sender: Any){
        
    }
    @IBAction func onClickBack(_ sender: AnyObject) {
        dismiss(animated: false, completion: nil)
    }
    @IBAction func onClickDeny(_ sender: Any) {
        exit(0)
    }
    @IBAction func onClickAccept(_ sender: Any) {
        UserDefaults.standard.set("true", forKey: "GDPR")
        dismiss(animated: false, completion: nil)
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
