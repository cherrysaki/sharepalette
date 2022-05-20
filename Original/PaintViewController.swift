//
//  ViewController5.swift
//  Original
//
//  Created by 神林沙希 on 2022/04/01.
//

import UIKit


class PaintViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var StackView:UIStackView!
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    
    
    
    var color: UIColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
    var colors: [Data] = []
    var saveData: UserDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if saveData.object(forKey: "color") != nil {
            colors = saveData.object(forKey: "color") as! [Data]
            setButton()
        }
        //      color = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(colors[2]) as! UIColor
        //        collectionView.sizeThatFits(CGSize(width: , height: <#T##CGFloat#>))
        print(colors)
    }
    
    //
    func setButton(){
        let w = self.view.frame.width - 100
        // StackView.heightAnchor.constraint(equalToConstant: w / 4).isActive = true
        print(StackView.layer.bounds.width)
        let  colorButton1 = UIButton(type: .custom)
        colorButton1.widthAnchor.constraint(equalToConstant: w / 4).isActive = true
        colorButton1.heightAnchor.constraint(equalToConstant: w / 4).isActive = true
        colorButton1.layer.cornerRadius = w / 8
        colorButton1.backgroundColor = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(colors[0]) as! UIColor
        colorButton1.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        colorButton1.tag = 1
        StackView.addArrangedSubview(colorButton1)
        
        let  colorButton2 = UIButton(type: .custom)
        colorButton2.widthAnchor.constraint(equalToConstant: w / 4).isActive = true
        colorButton2.heightAnchor.constraint(equalToConstant: w / 4).isActive = true
        colorButton2.layer.cornerRadius = w / 8
        colorButton2.backgroundColor = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(colors[1]) as! UIColor
        colorButton2.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        colorButton2.tag = 2
        StackView.addArrangedSubview(colorButton2)
        
        let  colorButton3 = UIButton(type: .custom)
        colorButton3.widthAnchor.constraint(equalToConstant: w / 4).isActive = true
        colorButton3.heightAnchor.constraint(equalToConstant: w / 4).isActive = true
        colorButton3.layer.cornerRadius = w / 8
        colorButton3.backgroundColor = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(colors[2]) as! UIColor
        colorButton3.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        colorButton3.tag = 3
        StackView.addArrangedSubview(colorButton3)
        
        let  colorButton4 = UIButton(type: .custom)
        colorButton4.widthAnchor.constraint(equalToConstant: w / 4).isActive = true
        colorButton4.heightAnchor.constraint(equalToConstant: w / 4).isActive = true
        colorButton4.layer.cornerRadius = w / 8
        colorButton4.backgroundColor = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(colors[3]) as! UIColor
        colorButton4.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        colorButton4.tag = 4
        StackView.addArrangedSubview(colorButton4)
    }
    @objc func buttonTapped(sender:UIButton){
        print(color)
        color = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(colors[sender.tag - 1]) as! UIColor
    }
    
    
    //セルの数を設定
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 625
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize:CGFloat = self.view.bounds.width/25
        print(cellSize)
        return CGSize(width: cellSize, height: cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as UICollectionViewCell
        cell.backgroundColor = color
        return cell
    }
    
    //選択したcellを選んだカラーにする
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = color
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0 , left: 0 , bottom: 0 , right: 0 )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}




//    //colorボタン
//    @IBAction func color1(){
//       color = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(colors[0]) as! UIColor
//    }
//
//    @IBAction func color2(){
//        color = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(colors[1]) as! UIColor
//    }
//
//    @IBAction func color3(){
//        color = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(colors[2]) as! UIColor
//    }
//
//    @IBAction func color4(){
//        color = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(colors[3]) as! UIColor
//    }





