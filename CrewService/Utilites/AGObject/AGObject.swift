//
//  Extension.swift
//  BaseProject
//
//  Created by Gauravkumar Gudaliya on 12/6/17.
//  Copyright © 2017 AshvinGudaliya. All rights reserved.
//

import UIKit
import SwiftyJSON

typealias AGDictionary = [String: AnyObject]

@objcMembers
public class AGObject: NSObject {
    
    override public init() {
        super.init()
        
    }
    
    public var agDescription: String {
        return String(describing: self.toDict)
    }
    
    required convenience public init(with responseDict: [String: AnyObject]){
        self.init()
        
        self.convert(dataWith: responseDict)
    }
    
    var NoLogIfNotAssing: [String] = []
    
    func convert(dataWith responseDict: [String: AnyObject]) {
        for children in self.property() {
            if let key = children.label {
                if key == "descriptions"{
                    if let value = responseDict["description"] {
                        self.findClassAndAssignSingleValue(with: children.value, newValue: value, forKey: key)
                    }
                    else{
                        if !NoLogIfNotAssing.contains(key) {
                            GGObjectLog.debug("[\(type(of: self))] Not Found:- \(key) in responseDict")
                        }
                    }
                    
                }else if key == "extensions"{
                    if let value = responseDict["extension"] {
                        self.findClassAndAssignSingleValue(with: children.value, newValue: value, forKey: key)
                    }
                    else{
                        if !NoLogIfNotAssing.contains(key) {
                            GGObjectLog.debug("[\(type(of: self))] Not Found:- \(key) in responseDict")
                        }
                    }
                    
                }else{
                    if let value = responseDict[key] {
                        self.findClassAndAssignSingleValue(with: children.value, newValue: value, forKey: key)
                    }
                    else{
                        if !NoLogIfNotAssing.contains(key) {
                            GGObjectLog.debug("[\(type(of: self))] Not Found:- \(key) in responseDict")
                        }
                    }
                }
            }
        }
    }
    
    func getDataFromUserDefault(){
        for children in self.property() {
            if let value = UserDefaults.standard.value(forKey: children.label!) {
                self.findClassAndAssignSingleValue(with: children.value, newValue: value as AnyObject, forKey: children.label!)
            }
            else{
                NSLog("[Userdetails] Not get in UserDefaults :- key \(children.label!) value \(children.value)")
            }
        }
    }
    
    func saveToUserDefault(){
        for children in self.property() {
            
            if children.value is Int{
                UserDefaults.standard.set(children.value as! Int, forKey: children.label!)
            }
            else if children.value is Float {
                UserDefaults.standard.set(children.value as! Float, forKey: children.label!)
            }
            else if children.value is Bool {
                UserDefaults.standard.set(children.value as! Bool, forKey: children.label!)
            }
            else if children.value is String{
                UserDefaults.standard.set(children.value as! String, forKey: children.label!)
            }
            else{
                NSLog("[Userdetails] Not set in UserDefaults :- key \(children.label!) value \(children.value)")
            }
        }
    }
    
    func findClassAndAssignSingleValue(with defaultValue: Any, newValue: AnyObject, forKey: String){
        
        let name = "\(type(of: defaultValue))"
        let isArrayType: Bool = name == "Array<\(name.realType)>"
        
        switch name {
        case String(describing: String.self):
            if let string = JSON(newValue).string {
                self.setValue(string, forKey: forKey)
                return
            }
        case String(describing: [String].self):
            var temp: [String]  = []
            temp = self.getArray(newValue)
            self.setValue(temp, forKey: forKey)
            return
        case String(describing: [Int].self):
            var temp: [Int]  = []
            temp = self.getArray(newValue)
            self.setValue(temp, forKey: forKey)
            return
        case String(describing: [[String]].self):
            var temp: [[String]]  = []
            temp = self.getArray(newValue)
            self.setValue(temp, forKey: forKey)
            return
        case String(describing: [Int:AnyObject].self):
            let t = newValue as? [String:AnyObject]
            self.setValue(JSON(t).dictionaryObject, forKey: forKey)
            return
        case String(describing: Int.self):
            self.setValue(JSON(newValue).intValue, forKey: forKey)
            return
        case String(describing: NSDictionary.self):
            self.setValue(JSON(newValue).dictionaryValue, forKey: forKey)
            return
        case String(describing: Bool.self):
            self.setValue(JSON(newValue).boolValue, forKey: forKey)
            return
            
        case String(describing: Float.self), String(describing: CGFloat.self):
            self.setValue(JSON(newValue).floatValue, forKey: forKey)
            return
            
        case String(describing: Double.self):
            self.setValue(JSON(newValue).doubleValue, forKey: forKey)
            return
            
        default:
            if let subModelClass = classWith(className: name.realType) {
                if isArrayType {
                    if let subDict =  newValue as? [[String : AnyObject]]{
                        let arraySubModels: [AnyObject] = subDict.map {
                            subModelClass.init(with: $0 as [String: AnyObject])
                        }
                        self.setValue(arraySubModels, forKey: forKey)
                        return
                    }else if forKey == "arrCountry"{
                        if let data = UserDefaults.standard.object(forKey: forKey) as? [String :[AnyObject]]{
                            var temp:[CountryModel] = []
                            temp <= data["arrCountry"] as? [[String:AnyObject]] ?? []
                            self.setValue(temp, forKey:forKey)
                            return
                        }
                    }
                }
                else{
                    if let dict =  newValue as? [String : AnyObject]{
                        self.setValue(subModelClass.init(with: dict), forKey: forKey)
                        return
                    }
                }
            }else{
                if isArrayType {
                    if forKey == "children"{
                        if let subDict =  newValue as? [[String : AnyObject]]{
                            if subDict.count > 0,subDict[0]["attribute_name"] != nil{
                                let arraySubModels: [AnyObject] = subDict.map {
                                    SubCategoryModel.init(with: $0 as [String: AnyObject])
                                }
                                self.setValue(arraySubModels, forKey: forKey)
                                return
                            }else{
                                let arraySubModels: [AnyObject] = subDict.map {
                                    SubCategoryModel.init(with: $0 as [String: AnyObject])
                                }
                                self.setValue(arraySubModels, forKey: forKey)
                                return
                            }
                        }
                        
                    }else if forKey == "arrCountry"{
                        if let data = UserDefaults.standard.object(forKey: forKey) as? [String :[AnyObject]]{
                            var temp:[CountryModel] = []
                            temp <= data["arrCountry"] as? [[String:AnyObject]] ?? []
                            self.setValue(temp, forKey:forKey)
                            return
                        }
                    }else if forKey == "cities"{
                        if let subDict =  newValue as? [[String : AnyObject]]{
                            let arraySubModels: [AnyObject] = subDict.map {
                                CityModel.init(with: $0 as [String: AnyObject])
                            }
                            self.setValue(arraySubModels, forKey: forKey)
                            return
                        }
                    }
                    else if forKey == "milestones"{
                        if let subDict =  newValue as? [[String : AnyObject]]{
                            let arraySubModels: [AnyObject] = subDict.map {
                                MilestonesModel.init(with: $0 as [String: AnyObject])
                            }
                            self.setValue(arraySubModels, forKey: forKey)
                            return
                        }
                    }
                    else if forKey == "slots"{
                        if let subDict =  newValue as? [[String : AnyObject]]{
                            let arraySubModels: [AnyObject] = subDict.map {
                                SlotsModel.init(with: $0 as [String: AnyObject])
                            }
                            self.setValue(arraySubModels, forKey: forKey)
                            return
                        }
                    }
                    else if forKey == "specialities"{
                        if let subDict =  newValue as? [[String : AnyObject]]{
                            let arraySubModels: [AnyObject] = subDict.map {
                                SpecialitiesModel.init(with: $0 as [String: AnyObject])
                            }
                            self.setValue(arraySubModels, forKey: forKey)
                            return
                        }
                    }
                    
                    else if forKey == "gallery"{
                        if let subDict =  newValue as? [[String : AnyObject]]{
                            let arraySubModels: [AnyObject] = subDict.map {
                                GalleryModel.init(with: $0 as [String: AnyObject])
                            }
                            self.setValue(arraySubModels, forKey: forKey)
                            return
                        }
                    }
                    else if forKey == "achievements"{
                        if let subDict =  newValue as? [[String : AnyObject]]{
                            let arraySubModels: [AnyObject] = subDict.map {
                                AchievementsModel.init(with: $0 as [String: AnyObject])
                            }
                            self.setValue(arraySubModels, forKey: forKey)
                            return
                        }
                    }
                    else if forKey == "profileSlots"{
                        if let subDict =  newValue as? [[String : AnyObject]]{
                            let arraySubModels: [AnyObject] = subDict.map {
                                ProfileSlotsModel.init(with: $0 as [String: AnyObject])
                            }
                            self.setValue(arraySubModels, forKey: forKey)
                            return
                        }
                    }
                    else if forKey == "shootingPlans"{
                        if let subDict =  newValue as? [[String : AnyObject]]{
                            let arraySubModels: [AnyObject] = subDict.map {
                                ShootingPlanModel.init(with: $0 as [String: AnyObject])
                            }
                            self.setValue(arraySubModels, forKey: forKey)
                            return
                        }
                    }
                    else if forKey == "profiles"{
                        if let subDict =  newValue as? [[String : AnyObject]]{
                            if subDict.count > 0,subDict[0]["category_name"] != nil{
                                let arraySubModels: [AnyObject] = subDict.map {
                                    ProviderModel.init(with: $0 as [String: AnyObject])
                                }
                                self.setValue(arraySubModels, forKey: forKey)
                                return
                            }else{
                                let arraySubModels: [AnyObject] = subDict.map {
                                    CategoryModel.init(with: $0 as [String: AnyObject])
                                }
                                self.setValue(arraySubModels, forKey: forKey)
                                return
                            }
                        }
                    }
                }else{
                    if forKey == "contracts"{
                        if let subDict =  newValue as? [String : AnyObject]{
                            self.setValue(ContractModel.init(with: subDict), forKey: forKey)
                            return
                        }
                    }
                }
            }
        }
        handleCustomKey(defaultValue: defaultValue, newValue: newValue, forKey: forKey)
    }
    
    func handleCustomKey(defaultValue: Any, newValue: Any, forKey: String) {
        let name = "\(type(of: defaultValue))"
        GGObjectLog.debug("Problem to assign value: key: \(forKey)-\(name),    newValue: \(newValue)-\(type(of: newValue))")
    }
}

extension NSObject{
    var className: String {
        return String(describing: type(of: self))
    }
    
    func property() -> Mirror.Children {
        return Mirror(reflecting: self).children
    }
    
    func propertyList() {
        
        for (name, value) in property() {
            guard let name = name else { continue }
            print("\(name): \(type(of: value)) = '\(value)'")
        }
    }
}

