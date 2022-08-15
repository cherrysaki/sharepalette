//
//  ViewController.swift
//  Original
//
//  Created by 神林沙希 on 2021/12/18.
//

import UIKit


class CameraViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    //    キャンセルされたかどうか
    var isCancelled: Bool = false
    
    var CollectionImage: UIImage!
    
    override func viewWillAppear(_ animated: Bool) {
        //        self.tabBarController?.tabBar.isHidden = false
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            if isCancelled == false {
                
                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.delegate = self
                
                picker.allowsEditing = true
                
                present(picker, animated: true,completion: nil)
            }else {
                isCancelled = false
            }
            
        }else{
            print("error")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // アプリの使用中に位置情報サービスを使用する許可をリクエストする
    }

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isCancelled = true
        picker.dismiss(animated: true, completion: nil)
        
        let previousViewController = tabBarController?.viewControllers?[0]
        tabBarController?.selectedViewController = previousViewController
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            CollectionImage = image
            // ユーザーの位置情報を1度リクエストする
            picker.dismiss(animated: true, completion: nil)
            //写真confirm画面へ遷移
            self.performSegue(withIdentifier: "photoConfirm", sender: self)
            
        } else {
            picker.dismiss(animated: true, completion: nil)
            
            
            
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //        segueのIDを確認して特定のsegueの時のみ動作させる
        if segue.identifier == "photoConfirm" {
            isCancelled = true
            //遷移先のViewControllerを獲得
            let PickColorViewController: PickColorViewController = segue.destination as! PickColorViewController
            
            //遷移先の変数に値を渡す
            PickColorViewController.image = self.CollectionImage
        }
    }
}
