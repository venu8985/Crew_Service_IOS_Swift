//
//  WebKey.swift
//  BaseProject
//
//  Created by Gauravkumar Gudaliya on 12/6/17.
//  Copyright © 2017 AshvinGudaliya. All rights reserved.
//

import UIKit

enum GGWebKey {
#if DEBUG
    static let domain = "https://development.htf.sa/crew/"
//    static let domain = "https://crew-sa.com/"
#else
    static let domain = "https://crew-sa.com/"
#endif
    static let BaseUrl = domain+"api/v1/provider/"
    static let AWSFilePath = "http://crew.sa.s3.amazonaws.com/"
    static let image_users_path = AWSFilePath+"uploads/users/"
    static let image_banners_path = AWSFilePath+"uploads/banners/"
    static let image_invoices_path = AWSFilePath+"uploads/invoices/"
    static let image_country_flags_path = AWSFilePath+"uploads/country_flags/"
    static let image_crn_files_path = AWSFilePath+"uploads/crn_files/"
    static let image_signatures_path = AWSFilePath+"uploads/signatures/"
    static let image_categories_path = AWSFilePath+"uploads/categories/"
    static let image_projects_path = AWSFilePath+"uploads/projects/"
    static let image_providers_path = AWSFilePath+"uploads/providers/"
    static let image_gallery_path = AWSFilePath+"uploads/gallery/"
    static let image_contracts_path = AWSFilePath+"uploads/contracts/"
    static let image_milestones_path = AWSFilePath+"uploads/milestones/"
    static let image_proposals_path = AWSFilePath+"uploads/proposals/"
    static let image_id_cards_path = AWSFilePath+"uploads/id_cards/"
    
    static let image_Upload_users_path = "uploads/users/"
    static let image_Upload_banners_path = "uploads/banners/"
    static let image_Upload_invoices_path = "uploads/invoices/"
    static let image_Upload_country_flags_path = "uploads/country_flags/"
    static let image_Upload_crn_files_path = "uploads/crn_files/"
    static let image_Upload_signatures_path = "uploads/signatures/"
    static let image_Upload_categories_path = "uploads/categories/"
    static let image_Upload_projects_path = "uploads/projects/"
    static let image_Upload_providers_path = "uploads/providers/"
    static let image_Upload_gallery_path = "uploads/gallery/"
    static let image_Upload_contracts_path = "uploads/contracts/"
    static let image_Upload_milestones_path = "uploads/milestones/"
    static let image_Upload_proposals_path = "uploads/proposals/"
    static let image_Upload_id_cards_path = "uploads/id_cards/"
    
    case internalsettings
    case appsettings
    case country
    case city
    case termsconditions
    case privacypolicy
    case login
    case resendotp
    case verifyotp
    case refreshtoken
    case updatefcmtoken
    case logout
    case completeprofile
    case getprofile
    case updateprofile
    case updateprofileimage
    case updatesignature
    case notifications
    case deletenotification
    case submitfeedback
    case changepassword
    case aboutus
    case category
    case addprofile
    case editprofile
    case deleteprofile
    case forgotpassword
    case verifyforgotpasswordotp
    case updatenewpassword
    case completeprofilewithoutpassword
    case hireresourcerequests
    case hireresourcerequestdetails
    case hireresourceacceptrequest
    case hireresourcerejectrequest
    case hireresourceacceptcontract
    case hireresourcerejectcontract
    case milestonepaymentreceived
    case milestonepaymentnotreceived
    case milestonepaymentreminder
    case shootingplans
    case rescheduleshootingplan
    case auditions
    case acceptaudition
    case rejectaudition
    case getcalenderdata
    case deletebusyslot
    case addbusyslot
    case nationality
   case activatetrial
    var relative: String {
        return "\(GGWebKey.BaseUrl)\(self.value)"
    }
    
    private var value: String {
        switch self {
        case .internalsettings: return "internal/settings"
        case .appsettings: return "app/settings"
        case .country: return "country"
        case .city: return "city"
        case .termsconditions: return "terms-conditions"
        case .privacypolicy: return "privacy-policy"
        case .login: return "login"
        case .resendotp: return "resend/otp"
        case .verifyotp: return "verify/otp"
        case .refreshtoken: return "refresh/token"
        case .updatefcmtoken: return "update/fcm/token"
        case .logout: return "logout"
        case .completeprofile: return "complete/profile"
        case .getprofile: return "get/profile"
        case .updateprofile: return "update/profile"
        case .updateprofileimage: return "update/profile/image"
        case .updatesignature: return "update/signature"
        case .notifications: return "notifications"
        case .deletenotification: return "delete/notification"
        case .submitfeedback: return "submit/feedback"
        case .changepassword: return "change/password"
        case .aboutus: return "about-us"
        case .category: return "category"
        case .addprofile: return "add/profile"
        case .editprofile: return "edit/profile"
        case .deleteprofile: return "delete/profile"
        case .forgotpassword: return "forgot/password"
        case .verifyforgotpasswordotp: return "verify/forgot/password/otp"
        case .updatenewpassword: return "update/new/password"
        case .completeprofilewithoutpassword: return "complete/profile/without/password"
        case .hireresourcerequests: return "hire/resource/requests"
        case .hireresourcerequestdetails: return "hire/resource/request/details"
        case .hireresourceacceptrequest: return "hire/resource/accept/request"
        case .hireresourcerejectrequest: return "hire/resource/reject/request"
        case .hireresourceacceptcontract: return "hire/resource/accept/contract"
        case .hireresourcerejectcontract: return "hire/resource/reject/contract"
        case .milestonepaymentreceived: return "milestone/payment/received"
        case .milestonepaymentnotreceived: return "milestone/payment/not/received"
        case .milestonepaymentreminder: return "milestone/payment/reminder"
        case .shootingplans: return "shooting/plans"
        case .rescheduleshootingplan: return "reschedule/shooting/plan"
        case .auditions: return "auditions"
        case .acceptaudition: return "accept/audition"
        case .rejectaudition: return "reject/audition"
        case .getcalenderdata: return "get/calender/data"
        case .deletebusyslot: return "delete/busy/slot"
        case .addbusyslot: return "add/busy/slot"
        case .nationality: return "nationality"
        case .activatetrial: return "activate/trial"
        
        }
    }
}


struct CWeb {
    
    static let device_type_ios = "ios"
    static let locale = "locale"
    static let device_id = "device_id"
    static let device_type = "device_type"
    static let hash_token = "hash_token"
    static let page = "page"
    static let current_version = "current_version"
    static let login_mode = "login_mode"
    static let dial_code = "dial_code"
    static let mobile = "mobile"
    static let password = "password"
    static let fcm_id = "fcm_id"
    static let id = "id"
    static let otp = "otp"
    static let name = "name"
    static let email = "email"
    static let confirm_password = "confirm_password"
    static let profile_image = "profile_image"
    static let signature_file = "signature_file"
    static let order_by = "order_by"
    static let created_at = "created_at"
    static let notification_id = "notification_id"
    static let message = "message"
    static let old_password = "old_password"
    static let main_category_id = "main_category_id"
    static let child_category_id = "child_category_id"
    static let title = "title"
    static let description = "description"
    static let charges = "charges"
    static let charges_unit = "charges_unit"
    static let country_id = "country_id"
    static let city_id = "city_id"
    static let linkedin_link = "linkedin_link"
    static let twitter_link = "twitter_link"
    static let instagram_link = "instagram_link"
    static let youtube_link = "youtube_link"
    static let facebook_link = "facebook_link"
    static let snapchat_link = "snapchat_link"
    static let achievement = "achievement"
    static let speciality = "speciality"
    static let gallery = "gallery"
    static let filename = "filename"
    static let extensions = "extension"
    static let mime_type = "mime_type"
    static let size = "size"
    static let thumb = "thumb"
    static let provider_profile_id = "provider_profile_id"
    static let type = "type"
    static let hire_resource_id = "hire_resource_id"
    static let contract_id = "contract_id"
    static let contract_milestone_id = "contract_milestone_id"
    static let shooting_plan_resource_id = "shooting_plan_resource_id"
    static let reschedule_date = "reschedule_date"
    static let audition_id = "audition_id"
    static let profile_slot_id = "profile_slot_id"
    static let start_date = "start_date"
    static let end_date = "end_date"
    static let duration = "duration"
    static let category_id = "category_id"
    static let id_number = "id_number"
    static let id_card_image = "id_card_image"
    static let nationality_id = "nationality_id"
}
