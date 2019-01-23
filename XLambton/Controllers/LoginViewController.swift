//
//  ViewController.swift
//  XLambton
//
//  Created by user143339 on 8/3/18.
//  Copyright © 2018 user143339. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        emailAddress.delegate = self
        password.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Text Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //txtRestName.resignFirstResponder()
        textField.resignFirstResponder() // resign the text that called the function (parameter)
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{ // recognizes enter key in keyboard
            textView.resignFirstResponder()
            return false
        }
        return true
    }

    @IBAction func submitLogIn(_ sender: Any) {
        let userEmail = emailAddress.text
        let userPassword = password.text
        
        let userEmailStored = UserDefaults.standard.value(forKey: "userEmail") as? String
        let userPasswordStored = UserDefaults.standard.value(forKey: "userPassword") as? String
        
        if (userEmail == "admin" && userPassword == "admin") || (userEmail == userEmailStored && userPassword == userPasswordStored){
            
            UserDefaults.standard.set(true, forKey: "userLoggedIn")
            UserDefaults.standard.synchronize()
            
            self.dismiss(animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Alert", message: "Email and/or password not match! Please enter again.", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return;
        }
    }
    
    //MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
    }
    
    //MARK: Actions
    @IBAction func backToLogin(unwindSegue: UIStoryboardSegue){
        print("> Login !!! <")
    }
}

