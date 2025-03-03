//
//  ViewController.swift
//  TodoWithFirebase
//
//  Created by Tomoya Kuroda on 2019/07/26.
//  Copyright © 2019 Group8. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ViewController: UIViewController {

    @IBOutlet weak var textEmail: UITextField!
    
    @IBOutlet weak var textPassword: UITextField!
    var uid: String = ""
    var user = User(uid: "", email: "", password: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Reset the input whenever user come to this view
        textEmail.text = ""
        textPassword.text = ""
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Reset the input whenever user come to this view
        textEmail.text = ""
        textPassword.text = ""
    }

    
    
    @IBAction func signinAction(_ sender: Any) {
        // Assign the value from input
        self.user.email = textEmail.text!
        self.user.password = textPassword.text!
        if self.user.email == "" || self.user.password == "" {
            //Alert to tell the user that there was an error because they didn't fill anything in the textfields because they didn't fill anything in
            let alertController = UIAlertController(title: "Oops", message: "Please enter an email and password.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            // Authenticate with given credential information
            Auth.auth().signIn(withEmail: self.user.email, password: self.user.password) { (result, error) in
                if error == nil {
                    // If there is no error, go to Todo List
                    self.user.uid = (result?.user.uid)!
                    self.performSegue(withIdentifier: "loginSegue", sender: self)
                } else {
                    //Tells the user that there is an error and then gets firebase to tell them the error
                    let alertController = UIAlertController(title: "Oops", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is UINavigationController {
        // Pass the userID to TodoView Controller
        let navigation = segue.destination as! UINavigationController
        let todoVC = navigation.topViewController as! TodoView
        todoVC.userID = user.uid
        }
    }
}

