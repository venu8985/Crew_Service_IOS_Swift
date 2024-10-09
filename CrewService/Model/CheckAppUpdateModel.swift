//
//  CheckAppUpdateModel.swift
//  TasmemcomUser
//
//  Created by Gaurav Gudaliya on 30/04/21.
//  Copyright © 2021 Gaurav Gudaliya R. All rights reserved.
//

public enum UpdateType: String {
    /// Major release available: A.b.c.d
    case major
    /// Minor release available: a.B.c.d
    case minor
    /// Patch release available: a.b.C.d
    case patch
    /// Revision release available: a.b.c.D
    case revision
    /// No information available about the update.
    case unknown
}
import Foundation
import UIKit
class CheckAppUpdateModel:NSObject{
    
    static var shared = CheckAppUpdateModel()
    let currentInstalledVersion = (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String)
    var completetionSuccessHandler:((Model)->Void)?
    var completetionErrorHandler:((String)->Void)?
    var model:Model?
    func checkAppUpdate(completetionSuccessHandler:((Model)->Void)?,completetionErrorHandler:((String)->Void)?){
        self.completetionSuccessHandler = completetionSuccessHandler
        self.completetionErrorHandler = completetionErrorHandler
        var components = URLComponents()
        components.scheme = "https"
        components.host = "itunes.apple.com"
        components.path = "/lookup"

        let items: [URLQueryItem] = [URLQueryItem(name: "bundleId", value: Bundle.main.bundleIdentifier)]
      //  let items: [URLQueryItem] = [URLQueryItem(name: "bundleId", value: " com.htf.TasmemcomUser")]
        
    //        let item = URLQueryItem(name: "country", value: "US")
    //        items.append(item)

        components.queryItems = items

        if let url = components.url{
            let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30)
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                URLCache.shared.removeCachedResponse(for: request)
                if let error = error {
                    debugPrint("Error retrieving App Store data as an error was returned\nAlso, the following system level error was returned: \(error)")
                } else {
                    guard let data = data else {
                        debugPrint("Error retrieving App Store data as an error was returned\nAlso, the following system level error was returned:")
                        return
                    }
                    do {
                        let apiModel = try JSONDecoder().decode(APIModel.self, from: data)
                        guard !apiModel.results.isEmpty else {
                            debugPrint("Error retrieving App Store data as the JSON results were empty. Is your app available in the US? If not, change the `countryCode` variable to fix this error.")
                            return
                        }
                        DispatchQueue.main.async {
                            self.validate(apiModel: apiModel)
                        }
                    } catch {
                      debugPrint("Error parsing App Store JSON data.\nAlso, the following system level error was returned: \(error)")
                    }
                }
            }.resume()
        }
    }
    /// Validates the parsed and mapped iTunes Lookup Model
    /// to guarantee all the relevant data was returned before
    /// attempting to present an alert.
    ///
    /// - Parameter apiModel: The iTunes Lookup Model.
    func validate(apiModel: APIModel) {
        // Check if the latest version is compatible with current device's version of iOS.
        guard isUpdateCompatibleWithDeviceOS(for: apiModel) else {
            self.completetionErrorHandler?("The version of iOS on the device is lower than that of the one required by the app version update.")
           // resultsHandler?(.failure(.appStoreOSVersionUnsupported))
            return
        }

        // Check and store the App ID .
        guard let results = apiModel.results.first,
            let appID = apiModel.results.first?.appID else {
            self.completetionErrorHandler?("Error retrieving trackId as the JSON does not contain a `trackId` key.")
            //resultsHandler?(.failure(.appStoreAppIDFailure))
            return
        }
        // Check and store the current App Store version.
        guard let currentAppStoreVersion = apiModel.results.first?.version else {
            self.completetionErrorHandler?("Error retrieving App Store verson number as the JSON does not contain a `version` key.")
           // resultsHandler?(.failure(.appStoreVersionArrayFailure))
            return
        }

        // Check if the App Store version is newer than the currently installed version.
        guard isAppStoreVersionNewer(installedVersion: currentInstalledVersion, appStoreVersion: currentAppStoreVersion) else {
            self.completetionErrorHandler?(" No new update available.")
            //resultsHandler?(.failure(.noUpdateAvailable))
            return
        }

        let updateType = parseForUpdate(forInstalledVersion: currentInstalledVersion,
                                                   andAppStoreVersion: currentAppStoreVersion)
        let model = Model(appID: appID,
                          currentVersionReleaseDate: results.currentVersionReleaseDate,
                          minimumOSVersion: results.minimumOSVersion,
                          releaseNotes: results.releaseNotes,
                          version: results.version, updateType: updateType)
        self.completetionSuccessHandler?(model)
    }
    func isUpdateCompatibleWithDeviceOS(for model: APIModel) -> Bool {
        guard let requiredOSVersion = model.results.first?.minimumOSVersion else {
            return false
        }

        let systemVersion = UIDevice.current.systemVersion

        guard systemVersion.compare(requiredOSVersion, options: .numeric) == .orderedDescending ||
            systemVersion.compare(requiredOSVersion, options: .numeric) == .orderedSame else {
                return false
        }

        return true
    }
    func isAppStoreVersionNewer(installedVersion: String?, appStoreVersion: String?) -> Bool {
        guard let installedVersion = installedVersion,
            let appStoreVersion = appStoreVersion,
            (installedVersion.compare(appStoreVersion, options: .numeric) == .orderedAscending) else {
                return false
        }

        return true
    }
    func parseForUpdate(forInstalledVersion installedVersion: String?,
                               andAppStoreVersion appStoreVersion: String?) -> UpdateType {
        guard let installedVersion = installedVersion,
            let appStoreVersion = appStoreVersion else {
                return .unknown
        }

        let oldVersion = split(version: installedVersion)
        let newVersion = split(version: appStoreVersion)

        guard let newVersionFirst = newVersion.first,
            let oldVersionFirst = oldVersion.first else {
            return .unknown
        }

        if newVersionFirst > oldVersionFirst { // A.b.c.d
            return .major
        } else if newVersion.count > 1 && (oldVersion.count <= 1 || newVersion[1] > oldVersion[1]) { // a.B.c.d
            return .minor
        } else if newVersion.count > 2 && (oldVersion.count <= 2 || newVersion[2] > oldVersion[2]) { // a.b.C.d
            return .patch
        } else if newVersion.count > 3 && (oldVersion.count <= 3 || newVersion[3] > oldVersion[3]) { // a.b.c.D
            return .revision
        } else {
            return .unknown
        }
    }
    func split(version: String) -> [Int] {
        return version.lazy.split {$0 == "."}.map { String($0) }.map {Int($0) ?? 0}
    }
}
public struct Model {
    /// The app's App ID.
    public let appID: Int

    /// The release date for the latest version of the app.
    public let currentVersionReleaseDate: String

    /// The minimum version of iOS that the current version of the app requires.
    public let minimumOSVersion: String

    /// The releases notes from the latest version of the app.
    public let releaseNotes: String?

    /// The latest version of the app.
    public let version: String
    public var updateType:UpdateType = .unknown
    /// The initializer for the `public` facing Model type.
    ///
    /// - Parameters:
    ///   - appID: The app's App ID.
    ///   - currentVersionReleaseDate: The release date for the latest version of the app.
    ///   - minimumOSVersion: The minimum version of iOS that the current version of the app requires.
    ///   - releaseNotes: The releases notes from the latest version of the app.
    ///   - version: The latest version of the app.
    init(appID: Int,
         currentVersionReleaseDate: String,
         minimumOSVersion: String,
         releaseNotes: String?,
         version: String,updateType:UpdateType) {
        self.appID = appID
        self.currentVersionReleaseDate = currentVersionReleaseDate
        self.minimumOSVersion = minimumOSVersion
        self.releaseNotes = releaseNotes
        self.version = version
        self.updateType = updateType
    }
    func launchAppStore() {
        if let url = URL(string: "https://itunes.apple.com/app/id\(appID)"){
            DispatchQueue.main.async {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
}

struct APIModel: Decodable {
    /// Codable Coding Keys for the Top-Level iTunes Lookup API JSON response.
    private enum CodingKeys: String, CodingKey {
        /// The results JSON key.
        case results
    }

    /// The array of results objects from the iTunes Lookup API.
    let results: [Results]

    /// The Results object from the the iTunes Lookup API.
    struct Results: Decodable {
        ///  Codable Coding Keys for the Results array in the iTunes Lookup API JSON response.
        private enum CodingKeys: String, CodingKey {
            /// The appID JSON key.
            case appID = "trackId"
            /// The current version release date JSON key.
            case currentVersionReleaseDate
            /// The minimum device iOS version compatibility JSON key.
            case minimumOSVersion = "minimumOsVersion"
            /// The release notes JSON key.
            case releaseNotes
            /// The current App Store version JSON key.
            case version
        }

        /// The app's App ID.
        let appID: Int

        /// The release date for the latest version of the app.
        let currentVersionReleaseDate: String

        /// The minimum version of iOS that the current version of the app requires.
        let minimumOSVersion: String

        /// The releases notes from the latest version of the app.
        let releaseNotes: String?

        /// The latest version of the app.
        let version: String
    }
}
