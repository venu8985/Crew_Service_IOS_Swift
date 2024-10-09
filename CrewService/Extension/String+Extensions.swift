//
//  String+Extensions.swift
//  Alfayda
//
//  Created by Wholly-iOS on 22/08/18.
//  Copyright © 2018 Whollysoftware. All rights reserved.
//

import UIKit

extension String {
    public var isNull: Bool    {
        return self.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty
    }
    
    public var isNotNull: Bool    {
        return !self.isNull
    }
    
    func or(_ defaultValue: String) -> String {
        return self.isNull ? defaultValue : self
    }
    
    var isValidEmail: Bool {
        if (self.isNull) { return false }
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    var isValidPhone : Bool {
        return Double(self) != nil
    }
}
extension String{
    func LoadUserImage()->String{
        return GGWebKey.image_users_path+self
    }
    func LoadBannerImage()->String{
        return GGWebKey.image_banners_path+self
    }
    func LoadCategoriesImage()->String{
        return GGWebKey.image_categories_path+self
    }
    func LoadCrn_filesImage()->String{
        return GGWebKey.image_crn_files_path+self
    }
    func LoadSignaturesImage()->String{
        return GGWebKey.image_signatures_path+self
    }
    func LoadProjectsImage()->String{
        return GGWebKey.image_projects_path+self
    }
    func LoadProvidersImage()->String{
        return GGWebKey.image_providers_path+self
    }
    func LoadGalleryImage()->String{
        return GGWebKey.image_gallery_path+self
    }
    func LoadContractsImage()->String{
        return GGWebKey.image_contracts_path+self
    }
    func LoadMilestonesImage()->String{
        return GGWebKey.image_milestones_path+self
    }
    func LoadProposalsImage()->String{
        return GGWebKey.image_proposals_path+self
    }
    func LoadIDProffImage()->String{
        return GGWebKey.image_id_cards_path+self
    }
    func loadUnit()->String{
        if self == "PerDay"{
            return Language.get("Day")
        }else{
            return Language.get("Hour")
        }
    }
    func PriceString()->String{
        if UserDetails.shared.langauge == "en"{
            return "SAR " + self.replacingOccurrences(of: ".00", with: "")
        }else{
           return "ر.س " + self.replacingOccurrences(of: ".00", with: "")
        }
    }
    func ProjectStatusColor()->UIColor{
        if self == "Ongoing"{
            return UIColor(hex: 0xF08536)
        }else if self == "Completed"{
            return UIColor(hex: 0x13B161)
        }else if self == "Cancelled"{
            return UIColor(hex: 0xD70225)
        }else if self == "Awarded"{
            return UIColor(hex: 0x0936C5)
        }else{
            return .black
        }
    }
    func StrickLineString()->NSMutableAttributedString{
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
}
