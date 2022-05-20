//
//  ViewController3.swift
//  Original
//
//  Created by 神林沙希 on 2022/01/16.
//

import UIKit

class CollectionViewController: UIViewController {
    
    @IBOutlet var parentStackView: UIStackView!
            var colors: [Data] = []
            var saveData: UserDefaults = UserDefaults.standard
            var images: [Data] = []
            var image = UIImage()
            
            override func viewDidLoad() {
                super.viewDidLoad()

                if saveData.object(forKey: "color") != nil {
                    colors = saveData.object(forKey: "color") as! [Data]
                    images = saveData.object(forKey: "image") as! [Data]
                    setLayout()
                }
                print(colors)
                
            }
            
            func setLayout() {
                for num in 0...colors.count - 1 {
                    if num % 4 == 0 {
                        let w = self.view.frame.width - 100
                        let stackView = UIStackView()
                        stackView.axis = .horizontal
                        stackView.spacing = 20
                        stackView.widthAnchor.constraint(equalToConstant: parentStackView.frame.width).isActive = true
                        stackView.heightAnchor.constraint(equalToConstant: w / 4).isActive = true
                        print(stackView.layer.bounds.width)
                        parentStackView.addArrangedSubview(stackView)
                        parentStackView.spacing = 20
                        for i in 0...3 {
                            if num + i <= colors.count - 1 {
                                let colorButton = UIButton(type: .custom)
                                colorButton.widthAnchor.constraint(equalToConstant: w / 4).isActive = true
                                colorButton.heightAnchor.constraint(equalToConstant: w / 4).isActive = true
                                colorButton.layer.cornerRadius = w / 8
                                colorButton.backgroundColor = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(colors[num + i]) as? UIColor
                                colorButton.tag = num + i + 1
                                colorButton.addTarget(self, action: #selector(toVC(_:)), for: .touchUpInside)
                                stackView.addArrangedSubview(colorButton)
                            } else {
                                let colorButton = UIButton(type: .custom)
                                colorButton.widthAnchor.constraint(equalToConstant: w / 4).isActive = true
                                colorButton.heightAnchor.constraint(equalToConstant: w / 4).isActive = true
                                colorButton.layer.cornerRadius = w / 8
                                colorButton.backgroundColor = .white
                                colorButton.tag = num + 1
                                stackView.addArrangedSubview(colorButton)
                            }
                        }
                    }
                }
            }
            
            @objc func toVC(_ sender: UIButton) {
                print(sender.tag)
                image = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(images[sender.tag - 1]) as! UIImage
                self.performSegue(withIdentifier: "toVC4", sender: self)
            }
            
            override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
             //segueのIDを確認して特定のsegueの時のみ動作させる
                 if segue.identifier == "toVC4" {
                     //遷移先のViewControllerを獲得
                     var viewController4: ViewController4 = segue.destination as! ViewController4
                     
                     //遷移先の変数に値を渡す
                     viewController4.image = self.image
                     
                     
                 }
             }
                
        }
