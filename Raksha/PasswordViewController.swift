//
//  PasswordViewController.swift
//  Raksha
//
//  Created by Admin on 17/06/16.
//  Copyright © 2016 maximus. All rights reserved.
//

import UIKit
import Alamofire

class PasswordViewController: UIViewController, UIAlertViewDelegate, UITextFieldDelegate {
let defaults = NSUserDefaults.standardUserDefaults()
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtPasswordConfirm: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtPassword.delegate = self
        txtPasswordConfirm.delegate = self
        // Do any additional setup after loading the view.
        if Reachability.isConnectedToNetwork() == true
        {
            print("Internet Connection OK")
        }
        else
        {
            print("Internet connection FAILED")
            let alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        
        if let mobileNo = defaults.stringForKey("mobileNo")
        {
            print("The user has a mobile number defined " + mobileNo)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func btnSubmitPasswordTapped(MobileNumber : String, Password : String)
    {
        Alamofire.request(.POST, "http://125.99.113.202:8777/Password", parameters: ["DeviceReferenceID":DeviceReferenceID,"MobileNumber":defaults.stringForKey("mobileNo")!,"Password":Password])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                let JSON = response.result.value
                print("JSON: \(JSON)")
                let string: NSString = JSON as! NSString
                print("string is " + (string as String))
        }
    }

    
    
    @IBAction func btnSubmitPassword(sender: AnyObject)
    {
        MyKeychain.mySetObject(self.txtPassword.text, forKey: kSecValueData)
        MyKeychain1.mySetObject(self.txtPasswordConfirm.text, forKey: kSecValueData)
        
        print(MyKeychain.myObjectForKey(kSecValueData)as! String)
        print(MyKeychain1.myObjectForKey(kSecValueData)as! String)
        
        btnSubmitPasswordTapped(defaults.stringForKey("mobileNo")!, Password: txtPassword.text!)
        
        if (txtPassword.text == "" || txtPasswordConfirm.text == "")
        {
            print(" please enter text")
            let alertView = UIAlertController(title: "Oops! A Problem", message: "Please enter some text." as String, preferredStyle:.Alert)
            let okAction = UIAlertAction(title: "Failed!", style: .Default, handler: nil)
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: true, completion: nil)
        }
        
        if (txtPassword.text?.characters.count != 4) {
            print("please enter atleast 4 characters as your password.")
        }

        
        if (txtPassword.text == txtPasswordConfirm.text)
        {
            print("passwords match")
            let next = self.storyboard?.instantiateViewControllerWithIdentifier("welcomePage") as! WelcomeViewController
            self.presentViewController(next, animated: true, completion: nil)
        }
        
        else
        {
            print("passwords dont match")

            let alertView = UIAlertController(title: "Oops! A Problem", message: "Please ensure that the passwords match." as String, preferredStyle:.Alert)
            let okAction = UIAlertAction(title: "Failed!", style: .Default, handler: nil)
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: true, completion: nil)
            
            return;

        }
    }

    
    
    @IBAction func btnCancelPassword(sender: AnyObject)
    {
     txtPassword.text = ""
        txtPasswordConfirm.text = ""
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}