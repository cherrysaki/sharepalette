//
//  LoginViewController.swift
//  Original
//
//  Created by 神林沙希 on 2022/05/06.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var registerEmailTextField: UITextField!
    @IBOutlet var registerPasswordTextField: UITextField!
    @IBOutlet var registerNameTextField: UITextField!
    @IBOutlet var loginEmailTextField: UITextField!
    @IBOutlet var loginPasswordTextField: UITextField!
    
    
    override func viewDidLoad() {
        registerEmailTextField.delegate = self
        registerPasswordTextField.delegate = self
        registerNameTextField.delegate = self
        loginEmailTextField.delegate = self
        loginPasswordTextField.delegate = self
        super.viewDidLoad()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func tapRegisterButton(_ sender: Any) {
        if let email = registerEmailTextField.text,
           let password = registerPasswordTextField.text,
           let name = registerNameTextField.text {
            // ①FirebaseAuthにemailとpasswordでアカウントを作成する
            Auth.auth().createUser(withEmail: email, password: password, completion: { (result, error) in
                if let user = result?.user {
                    print("ユーザー作成完了 uid:" + user.uid)
                    // ②FirestoreのUsersコレクションにdocumentID = ログインしたuidでデータを作成する
                    Firestore.firestore().collection("users").document(user.uid).setData([
                        "name": name
                    ], completion: { error in
                        if let error = error {
                            // ②が失敗した場合
                            print("Firestore 新規登録失敗 " + error.localizedDescription)
                            let dialog = UIAlertController(title: "新規登録失敗", message: error.localizedDescription, preferredStyle: .alert)
                            dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(dialog, animated: true, completion: nil)
                        } else {
                            print("ユーザー作成完了 name:" + name)
                            // ③成功した場合はTodo一覧画面に画面遷移を行う
                            let storyboard: UIStoryboard = self.storyboard!
                            let next = storyboard.instantiateViewController(withIdentifier: "TabBarViewController")
                            self.present(next, animated: true, completion: nil)
                        }
                    })
                } else if let error = error {
                    // ①が失敗した場合
                    print("Firebase Auth 新規登録失敗 " + error.localizedDescription)
                    let dialog = UIAlertController(title: "新規登録失敗", message: error.localizedDescription, preferredStyle: .alert)
                    dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(dialog, animated: true, completion: nil)
                }
            })
        }
    }
    
    
    
    //@IBAction func tapLoginButton(_ sender: Any) {
    @IBAction func tapLoginButton(_ sender: Any){
        if let email = loginEmailTextField.text,
           let password = loginPasswordTextField.text {
            // ①FirebaseAuthにemailとpasswordでログインを行う
            Auth.auth().signIn(withEmail: email, password: password, completion: { (result, error) in
                if let user = result?.user {
                    print("ログイン完了 uid:" + user.uid)
                    // ②成功した場合はTodo一覧画面に画面遷移を行う
                    let storyboard: UIStoryboard = self.storyboard!
                    let next = storyboard.instantiateViewController(withIdentifier: "TabBarViewController")
                    self.present(next, animated: true, completion: nil)
                } else if let error = error {
                    // ①が失敗した場合
                    print("ログイン失敗 " + error.localizedDescription)
                    let dialog = UIAlertController(title: "ログイン失敗", message: error.localizedDescription, preferredStyle: .alert)
                    dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(dialog, animated: true, completion: nil)
                }
            })
        }
    }
    
}

