//
//  SkillListViewController.swift
//  CrewService
//
//  Created by Gaurav Gudaliya on 21/05/21.
//  Copyright © 2021 Gaurav Gudaliya R. All rights reserved.
//

import UIKit

class SkillListViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    @IBOutlet var collection:UICollectionView!

    @IBOutlet var btnNext:AGButton!
    var List:[CategoryModel] = []
    var PrevoiusList:[CategoryModel] = []
    var isFromProfile = false
    var selectedIndex = -1
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Language.get("Add your skills/itmes")
        self.btnNext.action = {
            if self.selectedIndex == -1{return}
            let vc = UIStoryboard.instantiateViewController(withViewClass: TelentListViewController.self)
            vc.isFromProfile = self.isFromProfile
            if let object  = self.PrevoiusList.first(where: { (model) -> Bool in
                return model.id == self.List[self.selectedIndex].id
            }){
                vc.object = object
                vc.object.children = self.List[self.selectedIndex].children
            }else{
                vc.object = self.List[self.selectedIndex]
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        self.btnNext.setTitleColor(.appOffGray, for: .normal)
        self.btnNext.backgroundColor = .appOffWhite
        CommonAPI.shared.category(parameters: [:]) { data in
            self.List <= data
            debugPrint(data)
            self.collection.reloadData()
//            for i in 0..<self.List.count{
//                self.List[i].max_selection_allowed = 3
//            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return List.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SkillCollectionCell", for: indexPath) as! SkillCollectionCell
        cell.setupData(model: self.List[indexPath.row])
        if selectedIndex == indexPath.row{
            cell.viewBG.borderColor = .appRed
        }else{
            cell.viewBG.borderColor = .lightGray
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width-20)/3, height: (collectionView.frame.size.width-20)/3)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.btnNext.setTitleColor(.white, for: .normal)
        self.btnNext.backgroundColor = .appRed
        self.selectedIndex = indexPath.row
        collection.reloadData()
    }
}

class SkillCollectionCell:UICollectionViewCell{
    @IBOutlet var lblSkill:AGLabel!
    @IBOutlet var imgSkill:AGImageView!
    @IBOutlet var viewBG:AGView!
    var object:CategoryModel = CategoryModel()

    override func awakeFromNib() {
       
    }
    func setupData(model:CategoryModel){
        self.object = model
        self.lblSkill.text = self.object.name
        self.imgSkill.setImage(url: self.object.image.LoadCategoriesImage())
    }
}

