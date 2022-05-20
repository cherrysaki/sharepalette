//
//  TabBarViewController.swift
//  Original
//
//  Created by 神林沙希 on 2022/05/13.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //レンダリングモードをAlwaysOriginalでボタンの画像を登録する。
//               tabBar.items![0].image = UIImage(named: "day.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
//               tabBar.items![1].image = UIImage(named: "evening.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
//               tabBar.items![2].image = UIImage(named: "night.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
//        
//               //選択中のアイテムの画像はレンダリングモードを指定しない。
//               tabBar.items![0].selectedImage = UIImage(named: "day.png")
//               tabBar.items![1].selectedImage = UIImage(named: "evening.png")
//               tabBar.items![2].selectedImage = UIImage(named: "night.png")
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
