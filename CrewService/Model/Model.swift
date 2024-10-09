//
//  NewsFeedCommentModel.swift
//  Alfayda
//
//  Created by Wholly-iOS on 20/09/18.
//  Copyright © 2018 Whollysoftware. All rights reserved.
//

import UIKit

class NotificationModel:AGObject{
    var attribute: String = ""
    var created_at: String = ""
    var read_at: String = ""
    var descriptions: String = ""
    var title: String = ""
    var is_read: Int = 0
    var id: Int = 0
    var notify_type: String = ""
    var value: Int = 0
}
class CountryModel: AGObject {
    var id: Int = 0
    var name: String = ""
    var alpha_2: String = ""
    var dial_code: String = ""
    var flag: String = ""
    var local_name: String{
        get { return self.name}
    }
}

class CityModel: AGObject {
    var country_id: Int = 0
    var id: Int = 0
    var name: String = ""
}

class NationalityModel: AGObject {
    var id: Int = 0
    var nationality_name: String = ""
}

class ReviewModel:AGObject{
    var rating: Double = 0.0
    var comment: String = ""
    var name: String = ""
    var created_at: String = ""
}

class AboutsUsModel:AGObject{
    var descriptions: String = ""
    var en_description: String = ""
    var en_title:String = ""
    var title:String = ""
    var id:Int = 0
    var instagram_link:String = ""
    var snapchat_link:String = ""
    var twitter_link:String = ""
    var video_link_1:String = ""
    var video_link_2:String = ""
    var youtube_link:String = ""
    var facebook_link:String = ""
    var linkedin_link:String = ""
    var phone_number:String = ""
    var email_address:String = ""
    var local_descriptions: String{
        get { if (UserDetails.shared.langauge == "en"){return en_description}else{ return self.descriptions}}
    }
    var local_title: String{
        get { if (UserDetails.shared.langauge == "en"){return en_title}else{ return self.title}}
    }
}

class CategoryModel:AGObject{
    var id:Int = 0
    var image: String = ""
    var is_hire: String = ""
    var is_talent: String = ""
    var max_selection_allowed: Int = 0
    var name: String = ""
    var notify_audition: String = ""
    var resume_required: String = ""
    var children: [SubCategoryModel] = []
    var profiles: [ProviderModel] = []
}
class SubCategoryModel:AGObject{
    var id:Int = 0
    var name: String = ""
}

class AchievementsModel:AGObject{
    var id:Int = 0
    var achievement_name: String = ""
}
class SpecialitiesModel:AGObject{
    var id:Int = 0
    var speciality_name: String = ""
}
class GalleryModel:AGObject{
    var id:Int = 0
    var filename: String = ""
    var thumb: String = ""
    var extensions: String = ""
    var mime_type: String = ""
    var duration: String = ""
    var size: String = ""
}
class ProviderModel:AGObject{
    var id:Int = 0
    var provider_id:Int = 0
    var main_category_id:Int = 0
    var child_category_id:Int = 0
    var category_name: String = ""
    var title: String = ""
    var descriptions: String = ""
    var charges: String = ""
    var charges_unit: String = ""
    var country_id:Int = 0
    var city_id:Int = 0
    var linkedin_link: String = ""
    var twitter_link: String = ""
    var instagram_link: String = ""
    var youtube_link: String = ""
    var facebook_link: String = ""
    var snapchat_link: String = ""
    var achievements: [AchievementsModel] = []
    var specialities: [SpecialitiesModel] = []
    var gallery: [GalleryModel] = []
    var total_rated:Int = 0
    var total_rating:Int = 0
    var total_reviews:Int = 0
}
class Booking:AGObject{
    var id: Int = 0
    var charges: String = ""
    var charges_unit: String = ""
    var child_category: String = ""
    var created_at: String = ""
    var days: Int = 0
    var descriptions: String = ""
    var end_at: String = ""
    var feedback: String = ""
    var latitude: Double = 0.0
    var location:String = ""
    var longitude: Double = 0.0
    var name: String = ""
    var paid_amount: String = ""
    var profile_image: String = ""
    var project_id: Int = 0
    var project_name: String = ""
    var project_status: String = ""
    var provider_id: Int = 0
    var provider_profile_id: Int = 0
    var provider_review_id: Int = 0
    var rating: String = ""
    var remaining_amount: String = ""
    var start_at: String = ""
    var status: String = ""
    var total_amount: String = ""
    var user_id: Int = 0
    var contracts: ContractModel = ContractModel()
    var milestones: [MilestonesModel] = []
    var slots: [SlotsModel] = []
}
class SlotsModel:AGObject{
    var id:Int = 0
    var end_at: String = ""
    var days:Int = 0
    var start_at: String = ""
}
class ContractModel:AGObject{
    var id:Int = 0
    var agency_signature: String = ""
    var contract_description: String = ""
    var contract_name: String = ""
    var contract_number: String = ""
    var created_at: String = ""
    var days: Int = 0
    var end_at: String = ""
    var pdf_file: String = ""
    var provider_signature: String = ""
    var start_at: String = ""
    var status: String = ""
}
class MilestonesModel:AGObject{
    var id:Int = 0
    var created_at: String = ""
    var descriptions: String = ""
    var milestone_amount: String = ""
    var milestone_date: String = ""
    var paid_at: String = ""
    var pdf_file: String = ""
    var status: String = ""
    var title: String = ""
}
class ShootingPlanModel:AGObject{
    var id:Int = 0
    var hire_resource_id:Int = 0
    var project_id:Int = 0
    var shooting_plan_id:Int = 0
    var latitude: Double = 0.0
    var location: String = ""
    var longitude: Double = 0.0
    var project_name: String = ""
    var reschedule_date: String = ""
    var shooting_date: String = ""
}
class AuditionModel:AGObject{
    var id:Int = 0
    var user_id:Int = 0
    var project_id:Int = 0
    var latitude: Double = 0.0
    var location: String = ""
    var longitude: Double = 0.0
    var project_name: String = ""
    var project_status: String = ""
    var status: String = ""
    var audition_date: String = ""
}
class AvailibilityDetailModel:AGObject{
    var id:Int = 0
    var hire_resource_id:Int = 0
    var project_id:Int = 0
    var shooting_plan_id:Int = 0
    var latitude: Double = 0.0
    var location: String = ""
    var longitude: Double = 0.0
    var project_name: String = ""
    var reschedule_date: String = ""
    var shooting_date: String = ""
    var busySlots: [String] = []
    var profileSlots: [ProfileSlotsModel] = []
    var shootingPlans: [ShootingPlanModel] = []
}
class ProfileSlotsModel:AGObject{
    var shooting_plan_id:Int = 0
    var id:Int = 0
    var end_date: String = ""
    var start_date: String = ""
    var created_at: String = ""
}
