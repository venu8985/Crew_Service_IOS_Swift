//
//  AddProfileViewController.swift
//  CrewService
//
//  Created by Gaurav Gudaliya on 21/05/21.
//  Copyright © 2021 Gaurav Gudaliya R. All rights reserved.
//

import UIKit
import DropDown
import ActiveLabel
import AVFoundation
import AVKit
import Photos
import PhotosUI

class AddProfileViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate{
    
    @IBOutlet var collection:UICollectionView!
    @IBOutlet var progressBar:UIProgressView!
    @IBOutlet var lblTitle:ActiveLabel!
    
    var List:[ProviderModel] = []
    var object:CategoryModel = CategoryModel()
    var index = 0
    var isDisplay = false
    var isEdit = false
    var subCatagory:[SubCategoryModel] = []
    var isFromProfile = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDetails.shared.langauge == "ar"{
            self.lblTitle.textAlignment = .right
        }
        if self.isEdit || self.isDisplay{
            self.progressBar.isHidden = true
        }else{
            for t in self.subCatagory{
                let temp  = ProviderModel()
                temp.child_category_id = t.id
                temp.main_category_id = object.id
                temp.title = t.name
                temp.category_name = t.name
                self.List.append(temp)
            }
        }
        self.updateScreen()
    }
    func updateScreen(){
        if self.isEdit || self.isDisplay{
            self.title = List[self.index].category_name
            self.lblTitle.text = String(format: Language.get("About your %@ Service"), List[self.index].category_name)
            
            let customType = ActiveType.custom(pattern: "\\s\(List[self.index].category_name)\\b")
            self.lblTitle.enabledTypes.append(customType)
            self.lblTitle.customize { label in
                label.text = String(format: Language.get("About your %@ Service"), List[self.index].category_name)
                label.textColor = .black
                label.customColor[customType] = .appRed
                label.mentionColor = .black
            }
        }else{
            self.title = "\(self.index+1)/\(self.List.count)"+" "+List[self.index].title
            self.lblTitle.text = String(format: Language.get("About your %@ Service"), List[self.index].title)
            
            let customType = ActiveType.custom(pattern: "\\s\(List[self.index].title)\\b")
            self.lblTitle.enabledTypes.append(customType)
            self.lblTitle.customize { label in
                label.text = String(format: Language.get("About your %@ Service"), List[self.index].title)
                label.textColor = .black
                label.customColor[customType] = .appRed
                label.mentionColor = .black
            }
        }
        self.progressBar.trackTintColor = UIColor.appGreen.withAlphaComponent(0.5)
        self.progressBar.progressTintColor = UIColor.appGreen
        self.progressBar.setProgress(Float(self.index+1)/Float(self.List.count), animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return List.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddProfileCollectionCell", for: indexPath) as! AddProfileCollectionCell
        cell.isEdit = self.isEdit
        cell.isDisplay = self.isDisplay
        cell.setupData(model: self.List[indexPath.row])
        cell.addProfileComplitionHandler = { t in
            if self.isFromProfile && !self.isEdit{
                if let indexCatagory = UserDetails.shared.profiles.firstIndex(where: { (model) -> Bool in
                    return model.id == t.main_category_id
                }){
                    UserDetails.shared.profiles[indexCatagory].profiles.append(t)
                }
            }
            if self.isEdit{
                if let indexCatagory = UserDetails.shared.profiles.firstIndex(where: { (model) -> Bool in
                    return model.id == t.main_category_id
                }){
                    if let subindexCatagory = UserDetails.shared.profiles[indexCatagory].profiles.firstIndex(where: { (model) -> Bool in
                        return model.id == t.id
                    }){
                        UserDetails.shared.profiles[indexCatagory].profiles[subindexCatagory] = t
                    }
                }
            }else{
                UserDetails.shared.totalProfiles = indexPath.row+1
            }
            UserDetails.shared.saveToUserDefault()
            if indexPath.row+1 == self.List.count{
                if self.isEdit {
                   for controller in self.navigationController!.viewControllers as Array {
                       if controller.isKind(of: ProfileListViewController.self) {
                           self.navigationController!.popToViewController(controller, animated: true)
                           break
                       }
                   }
                }else if self.isFromProfile{
                    let vc = UIStoryboard.instantiateViewController(withViewClass: AfterAddedViewController.self)
                    main_category_id = t.main_category_id
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    AppDelegate.shared.SetTabBarMainView()
                } 
            }else{
                self.index = indexPath.row+1
                self.updateScreen()
                self.collection.scrollToItem(at: IndexPath(item: indexPath.row+1, section: indexPath.section), at: .centeredHorizontally, animated: true)
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: collection.contentOffset, size: collection.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let visibleIndexPath = collection.indexPathForItem(at: visiblePoint)
        self.index = visibleIndexPath?.row ?? 0
        self.updateScreen()
    }
}

class AddProfileCollectionCell:UICollectionViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate, PHPickerViewControllerDelegate{
    
    @IBOutlet var txtAbout:AGTextView!
    @IBOutlet var txtPrice:AGTextField!
    
    @IBOutlet var lblCountry:UILabel!
    @IBOutlet var lblCity:UILabel!
    @IBOutlet var saveView:UIView!
    
    @IBOutlet var txtLinked:UnderLineTextField!
    @IBOutlet var txtTwitter:UnderLineTextField!
    @IBOutlet var txtInsta:UnderLineTextField!
    @IBOutlet var txtYoutube:UnderLineTextField!
    @IBOutlet var txtFacebook:UnderLineTextField!
    @IBOutlet var txtSnapshot:UnderLineTextField!
    
    @IBOutlet var btnPriceType:AGButton!
    
    @IBOutlet var btnSave:AGButton!
    @IBOutlet var btnCountry:AGButton!
    @IBOutlet var btnCity:AGButton!
    
    @IBOutlet var collection:UICollectionView!
    @IBOutlet var tableArchiment:AGTableView!
    @IBOutlet var tableSpeciality:AGTableView!
    var addProfileComplitionHandler:((ProviderModel)->Void)?
    
    var object:ProviderModel = ProviderModel()
    var selctedCountry:CountryModel = CountryModel()
    var isDisplay = false
    var isEdit = false
    var cities:[CityModel] = []
    var typePrice = "PerDay"
    
    override func awakeFromNib() {
        if UserDetails.shared.langauge == "ar"{
            self.txtAbout.textAlignment = .right
            self.txtPrice.textAlignment = .right
        }
        self.txtPrice.placeholder = "500".PriceString()
        self.txtAbout.placeholder = Language.get("About Service")
        
        self.btnSave.action = {
            for i in 0..<self.object.achievements.count{
                if let cell = self.tableArchiment.cellForRow(at: IndexPath(item: i, section: 0)) as? AchievementsTableCell{
                    if cell.txtName.text! == ""{
                        cell.shake()
                        AppDelegate.shared.topViewController()?.displayAlertMsg(string: "Please enter achievement name")
                        return
                    }else{
                        self.object.achievements[i].achievement_name = cell.txtName.text!
                    }
                }
            }
            for i in 0..<self.object.specialities.count{
                if let cell = self.tableSpeciality.cellForRow(at: IndexPath(item: i, section: 0)) as? SpecialityTableCell{
                    if cell.txtName.text! == ""{
                        cell.shake()
                        AppDelegate.shared.topViewController()?.displayAlertMsg(string: "Please enter specialities name")
                        return
                    }else{
                        self.object.specialities[i].speciality_name = cell.txtName.text!
                    }
                }
            }
            var param:GGParameters = [:]
            param[CWeb.description] = self.txtAbout.text!
            param[CWeb.main_category_id] = self.object.main_category_id
            param[CWeb.child_category_id] = self.object.child_category_id
            param[CWeb.title] = self.object.title
            param[CWeb.charges] = self.txtPrice.text!
            param[CWeb.charges_unit] = self.typePrice
            param[CWeb.country_id] = self.object.country_id
            param[CWeb.city_id] = self.object.city_id
            param[CWeb.linkedin_link] = self.txtLinked.text!
            param[CWeb.twitter_link] = self.txtTwitter.text!
            param[CWeb.instagram_link] = self.txtInsta.text!
            param[CWeb.youtube_link] = self.txtYoutube.text!
            param[CWeb.facebook_link] = self.txtFacebook.text!
            param[CWeb.snapchat_link] = self.txtSnapshot.text!
            param[CWeb.achievement] = self.object.achievements.map({$0.achievement_name})
            param[CWeb.speciality] = self.object.specialities.map({$0.speciality_name})
            var gallery:[GGParameters] = []
            for v in self.object.gallery{
                var t:GGParameters = [:]
                t[CWeb.size] = v.size
                t[CWeb.extensions] = v.extensions
                t[CWeb.mime_type] = v.mime_type
                t[CWeb.filename] = v.filename
                t[CWeb.thumb] = v.thumb
                t[CWeb.duration] = v.duration
                gallery.append(t)
            }
            param[CWeb.gallery] = gallery
            if self.isEdit{
                param[CWeb.provider_profile_id] = self.object.id
                CommonAPI.shared.editprofile(parameters: param) { data in
                    var model = ProviderModel()
                    model <= data
                    model.title = self.object.category_name
                    model.category_name = self.object.category_name
                    self.addProfileComplitionHandler?(model)
                }
            }else{
                CommonAPI.shared.addprofile(parameters: param) { data in
                    var model = ProviderModel()
                    model <= data
                    model.title = self.object.category_name
                    model.category_name = self.object.category_name
                    self.addProfileComplitionHandler?(model)
                }
            }
        }
        self.btnPriceType.action = {
            AGAlertBuilder(withActionSheet: Language.get("Service Charges"), message: "", iPadOpen: .sourceView(self.btnPriceType))
                .addAction(with: Language.get("Day"), style: .default) { (action) in
                    self.typePrice = "PerDay"
                    self.btnPriceType.setTitle(self.typePrice.loadUnit(), for: .normal)
                }
                .addAction(with: Language.get("Hour"), style: .default) { (action) in
                    self.typePrice = "PerHour"
                    self.btnPriceType.setTitle(self.typePrice.loadUnit(), for: .normal)
                }
                .show()
        }
        self.btnCity.action = {
            if self.object.country_id == 0{
                AppDelegate.shared.topViewController()?.displayAlertMsg(string: "Please select country")
                return
            }
            let vc = UIStoryboard.instantiateViewController(withViewClass: CityListViewController.self)
            vc.arrAllCityList = self.cities
            vc.modalPresentationStyle = .overFullScreen
            vc.completetion = { t in
                self.lblCity.text = t.name
                self.object.city_id = t.id
            }
            AppDelegate.shared.topViewController()?.present(vc, animated: true, completion: {
                
            })
        }
        self.btnCountry.action = {
            let vc = UIStoryboard.instantiateViewController(withViewClass: CountryListViewController.self)
            vc.isCountrySelection = true
            vc.modalPresentationStyle = .overFullScreen
            vc.completetion = { t in
                self.lblCountry.text = t.local_name
                self.selctedCountry =  t
                self.object.country_id = self.selctedCountry.id
                CommonAPI.shared.city(parameters: [CWeb.country_id:self.object.country_id]) { (list) in
                    self.cities = list
                }
            }
            AppDelegate.shared.topViewController()?.present(vc, animated: true, completion: {
                
            })
        }
    }
    func setupData(model:ProviderModel){
        self.object = model
        if self.object.specialities.count == 0{
            self.object.specialities.append(SpecialitiesModel())
        }
        if self.object.achievements.count == 0{
            self.object.achievements.append(AchievementsModel())
        }
        if self.isDisplay{
            self.saveView.isHidden = true
            self.btnSave.isHidden = true
        }
        self.collection.reloadData()
        self.tableArchiment.reloadData()
        self.tableSpeciality.reloadData()
        if isEdit{
            self.btnSave.setTitle(Language.get("Save"), for: .normal)
        }
        if self.isDisplay || self.isEdit{
            self.txtAbout.text = self.object.descriptions
            self.txtPrice.text = self.object.charges
            self.typePrice = self.object.charges_unit
            self.btnPriceType.setTitle(self.typePrice.loadUnit(), for: .normal)
            self.txtLinked.text = self.object.linkedin_link
            self.txtTwitter.text = self.object.twitter_link
            self.txtInsta.text = self.object.instagram_link
            self.txtYoutube.text = self.object.youtube_link
            self.txtFacebook.text = self.object.facebook_link
            self.txtSnapshot.text = self.object.snapchat_link
            
            if let t = CommonAPI.shared.arrCountryList.first(where: { model in
                return model.id == self.object.country_id
            }){
                self.lblCountry.text = t.name
            }
            CommonAPI.shared.city(parameters: [CWeb.country_id:self.object.country_id]) { (list) in
                self.cities = list
                if  let tt = self.cities.first(where: { model in
                    return model.id == self.object.city_id
                }){
                    self.lblCity.text = tt.name
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.isDisplay{
            return self.object.gallery.count
        }
        return self.object.gallery.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == self.object.gallery.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addCell", for: indexPath)
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleyCollectionCell", for: indexPath) as! GalleyCollectionCell
            cell.setupData(model: self.object.gallery[indexPath.row])
            cell.deleteComplition = {
                self.object.gallery.remove(at: indexPath.row)
                self.collection.reloadData()
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 80, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == self.object.gallery.count {
            AGImagePickerController(with: self, allowsEditing: true, media: .both, iPadSetup: self.collection)
//            if #available(iOS 14, *) {
//
//                func checkPermission(){
//                    switch PHPhotoLibrary.authorizationStatus() {
//                    case .authorized:
//                        var config = PHPickerConfiguration()
//                        config.selectionLimit = 1
//                        config.filter = PHPickerFilter.any(of: [.images,.videos])
//
//                        let pickerViewController = PHPickerViewController(configuration: config)
//                        pickerViewController.delegate = self
//                        AppDelegate.shared.topViewController()?.present(pickerViewController, animated: true, completion: nil)
//                        break
//
//                    case .notDetermined:
//                        PHPhotoLibrary.requestAuthorization({ (status) in
//                            if status == .authorized{
//                                checkPermission()
//                            }
//                        })
//                        break
//
//                    default:
//                        AGAlertBuilder(withAlert: "App Permission Denied", message: "To re-enable, please go to Settings and turn on Photo Library Service for this app.")
//                            .addAction(with: "Setting", style: .default, handler: { _ in
//                                UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
//                            })
//                            .show()
//                        break
//                    }
//                }
//                checkPermission()
//            } else {
//                AGImagePickerController(with: self, allowsEditing: true, media: .both, iPadSetup: self.collection)
//            }
        }else{
            
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableSpeciality{
            if self.isDisplay{
                return self.object.specialities.count
            }
            return self.object.specialities.count + 1
        }else{
            if self.isDisplay{
                return self.object.achievements.count
            }
            return self.object.achievements.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableSpeciality{
            if self.object.specialities.count == indexPath.row{
                let cell = tableView.dequeueReusableCell(withIdentifier: "addCell")
                self.tableSpeciality.layoutSubviews()
                return cell!
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "SpecialityTableCell") as! SpecialityTableCell
                cell.txtName.accessibilityLabel = "specialities"
                cell.txtName.tag = indexPath.row
                cell.txtName.delegate = self
                cell.setupData(model: self.object.specialities[indexPath.row])
                cell.deleteComplition = {
                    self.object.specialities.remove(at: indexPath.row)
                    self.tableSpeciality.reloadData()
                }
                cell.btnRemove.isHidden = indexPath.row == 0
                self.tableSpeciality.layoutSubviews()
                return cell
            }
        }else{
            
            if self.object.achievements.count == indexPath.row{
                let cell = tableView.dequeueReusableCell(withIdentifier: "addCell")
                self.tableArchiment.layoutSubviews()
                return cell!
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "AchievementsTableCell") as! AchievementsTableCell
                cell.txtName.accessibilityLabel = "achievements"
                cell.txtName.tag = indexPath.row
                cell.txtName.delegate = self
                cell.setupData(model: self.object.achievements[indexPath.row])
                cell.deleteComplition = {
                    self.object.achievements.remove(at: indexPath.row)
                    self.tableArchiment.reloadData()
                }
                cell.btnRemove.isHidden = indexPath.row == 0
                self.tableArchiment.layoutSubviews()
                return cell
            }
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.accessibilityLabel == "achievements"{
            self.object.achievements[textField.tag].achievement_name = textField.text!
        }else{
            self.object.specialities[textField.tag].speciality_name = textField.text!
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tableSpeciality{
            if self.object.specialities.count == indexPath.row{
                self.object.specialities.append(SpecialitiesModel())
                self.tableSpeciality.reloadData()
            }else{
                
            }
        }else{
            if self.object.achievements.count == indexPath.row{
                self.object.achievements.append(AchievementsModel())
                self.tableArchiment.reloadData()
            }else{
                
            }
        }
    }
    
}
extension AddProfileCollectionCell: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @available(iOS 14.0, *)
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        for result in results {
            guard let typeIdentifier = result.itemProvider.registeredTypeIdentifiers.first,
                  let utType = UTType(typeIdentifier)
            else {
                AGAlertBuilder(withAlert: "Not Valid typeIdentifier", message: "")
                    .addAction(with: "Ok", style: .default, handler: { _ in
                    
                    })
                    .show()
                return }
            if utType.conforms(to: .image) {
                result.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { (object, error) in
                    if let image = object as? UIImage {
                        // Use UIImage
                        print("Selected image: \(image)")
                        
                        let imgData = Data(image.jpegData(compressionQuality: 1)!)
                        let imageSize: Int = imgData.count
                        let gallry:GalleryModel = GalleryModel()
                        gallry.extensions = "jpg"
                        gallry.size = (Double(imageSize) / 1000.0).description
                        gallry.mime_type = "image/jpg"
                        AWSUpload.shared.uploadFile(image: image, path: GGWebKey.image_Upload_gallery_path) { (path,name) in
                            gallry.filename = name
                            self.object.gallery.append(gallry)
                            DispatchQueue.main.async(execute: {
                                self.collection.reloadData()
                            })
                        }
                    }
                })
            } else if utType.conforms(to: .movie) {
                result.itemProvider.loadFileRepresentation(forTypeIdentifier: typeIdentifier) { url, error in
                    
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    
                    guard let url = url else {
                        AGAlertBuilder(withAlert: "Not Valid video url", message: "")
                            .addAction(with: "Ok", style: .default, handler: { _ in
                            
                            })
                            .show()
                        return }
                    
                    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
                    guard let videourl = documentsDirectory?.appendingPathComponent(url.lastPathComponent) else {
                        AGAlertBuilder(withAlert: "Not Valid saved video url", message: "")
                            .addAction(with: "Ok", style: .default, handler: { _ in
                            
                            })
                            .show()
                        return }
                    
                    do {
                        if FileManager.default.fileExists(atPath: videourl.path) {
                            try FileManager.default.removeItem(at: videourl)
                        }
                        try FileManager.default.copyItem(at: url, to: videourl)
                        let gallry:GalleryModel = GalleryModel()
                        gallry.size = (videourl.getMediaSize()).description
                        gallry.extensions = "mp4"
                        gallry.mime_type = "video/mp4"
                        gallry.duration = videourl.getMediaDuration().description
                        let asset = AVURLAsset(url: videourl)
                        
                        let generatorImage:AVAssetImageGenerator? = AVAssetImageGenerator(asset: asset)
                        generatorImage?.appliesPreferredTrackTransform = true
                        generatorImage?.requestedTimeToleranceAfter = CMTime.zero
                        generatorImage?.requestedTimeToleranceBefore = CMTime.zero
                        generatorImage?.generateCGImagesAsynchronously(forTimes: [NSValue(time: CMTime.zero)],completionHandler: { (_, image, _, _, error) in
                            guard let image = image else {
                                AGAlertBuilder(withAlert: "Not Valid video url thumb", message: "")
                                    .addAction(with: "Ok", style: .default, handler: { _ in
                                    
                                    })
                                    .show()
                                return
                            }
                            generatorImage?.cancelAllCGImageGeneration()
                            let uiimage = UIImage(cgImage: image)
                            AWSUpload.shared.uploadFile(image: uiimage, path: GGWebKey.image_Upload_gallery_path) { (path,name) in
                                gallry.thumb = name
                                AWSUpload.shared.uploadFileWithURL(url: videourl, path: GGWebKey.image_Upload_gallery_path,contentType:"video/mp4") { (path,name) in
                                    
                                    gallry.filename = name
                                    self.object.gallery.append(gallry)
                                    DispatchQueue.main.async(execute: {
                                        
                                        self.collection.reloadData()
                                    })
                                }
                            }
                        })
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            if let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String {
                if mediaType  == "public.image" {
                    if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                        
                        let imgData = Data(possibleImage.jpegData(compressionQuality: 1)!)
                        let imageSize: Int = imgData.count
                        let gallry:GalleryModel = GalleryModel()
                        gallry.extensions = "jpg"
                        gallry.size = (Double(imageSize) / 1000.0).description
                        gallry.mime_type = "image/jpg"
                        AWSUpload.shared.uploadFile(image: possibleImage, path: GGWebKey.image_Upload_gallery_path) { (path,name) in
                            gallry.filename = name
                            self.object.gallery.append(gallry)
                            DispatchQueue.main.async(execute: {
                                self.collection.reloadData()
                            })
                            
                        }
                        // self.updateprofilePic()
                    }
                }
                if mediaType == "public.movie" {
                    if let videourlLocal = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
                        
                        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
                        guard let videourl = documentsDirectory?.appendingPathComponent(videourlLocal.lastPathComponent) else {
                            AGAlertBuilder(withAlert: "Not Valid saved video url", message: "")
                                .addAction(with: "Ok", style: .default, handler: { _ in
                                
                                })
                                .show()
                            return }
                        
                        do {
                            if FileManager.default.fileExists(atPath: videourl.path) {
                                try FileManager.default.removeItem(at: videourl)
                            }
                            try FileManager.default.copyItem(at: videourlLocal, to: videourl)
                        }catch {
                            print(error.localizedDescription)
                        }
                        let gallry:GalleryModel = GalleryModel()
                        gallry.size = (videourl.getMediaSize()).description
                        gallry.extensions = "mp4"
                        gallry.mime_type = "video/mp4"
                        gallry.duration = videourl.getMediaDuration().description
                        let asset = AVURLAsset(url: videourl)
                        
                        let generatorImage:AVAssetImageGenerator? = AVAssetImageGenerator(asset: asset)
                        generatorImage?.appliesPreferredTrackTransform = true
                        generatorImage?.requestedTimeToleranceAfter = CMTime.zero
                        generatorImage?.requestedTimeToleranceBefore = CMTime.zero
                        generatorImage?.generateCGImagesAsynchronously(forTimes: [NSValue(time: CMTime.zero)],completionHandler: { (_, image, _, _, error) in
                            guard let image = image else {
                                return
                            }
                            DispatchQueue.main.async {
                                generatorImage?.cancelAllCGImageGeneration()
                                let uiimage = UIImage(cgImage: image)
                                AWSUpload.shared.uploadFile(image: uiimage, path: GGWebKey.image_Upload_gallery_path) { (path,name) in
                                    gallry.thumb = name
                                    AWSUpload.shared.uploadFileWithURL(url: videourl, path: GGWebKey.image_Upload_gallery_path,contentType:"video/mp4") { (path,name) in
                                        gallry.filename = name
                                        self.object.gallery.append(gallry)
                                        DispatchQueue.main.async(execute: {
                                            self.collection.reloadData()
                                        })
                                    }
                                }
                            }
                        })
                    }
                }
            }
            
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) { }
    }
    
}

class SpecialityTableCell:UITableViewCell{
    @IBOutlet var txtName:AGTextField!
    @IBOutlet var btnRemove:AGButton!
    var object:SpecialitiesModel = SpecialitiesModel()
    
    var deleteComplition:(()->Void)?
    override func awakeFromNib() {
        if UserDetails.shared.langauge == "ar"{
            self.txtName.textAlignment = .right
        }
        self.btnRemove.action = {
            self.deleteComplition?()
        }
    }
    func setupData(model:SpecialitiesModel){
        self.object = model
        self.txtName.text = self.object.speciality_name
    }
}

class AchievementsTableCell:UITableViewCell{
    @IBOutlet var txtName:AGTextField!
    @IBOutlet var btnRemove:AGButton!
    var object:AchievementsModel = AchievementsModel()
    
    var deleteComplition:(()->Void)?
    override func awakeFromNib() {
        if UserDetails.shared.langauge == "ar"{
            self.txtName.textAlignment = .right
        }
        self.btnRemove.action = {
            self.deleteComplition?()
        }
    }
    func setupData(model:AchievementsModel){
        self.object = model
        self.txtName.text = self.object.achievement_name
    }
}
class GalleyCollectionCell:UICollectionViewCell{
    
    @IBOutlet var btnRemove:AGButton!
    @IBOutlet var img:AGImageView!
    var object:GalleryModel = GalleryModel()
    var deleteComplition:(()->Void)?
    override func awakeFromNib() {
        self.btnRemove.action = {
            self.deleteComplition?()
        }
    }
    func setupData(model:GalleryModel){
        self.object = model
        if self.object.thumb == ""{
            self.img.setImage(url: self.object.filename.LoadGalleryImage(),placeholderImage: UIImage(named: "upload")!)
        }else{
            self.img.setImage(url: self.object.thumb.LoadGalleryImage(),placeholderImage: UIImage(named: "upload")!)
        }
    }
}

extension URL{
    func getMediaDuration() -> Float64{
        let asset : AVURLAsset = AVURLAsset(url: self) as AVURLAsset
        let duration : CMTime = asset.duration
        return CMTimeGetSeconds(duration)
    }
    func getMediaSize()->Double{
        let asset = AVAsset(url: self)
        let assetSizeBytes = asset.tracks(withMediaType: AVMediaType.video).first?.totalSampleDataLength
        return Double(assetSizeBytes ?? 0)*1000
    }
}
