//
//  User.swift
//  BitMEX
//
//  Created by Behnam Karimi on 6/20/1398 AP.
//  Copyright © 1398 AP Behnam Karimi. All rights reserved.
//

import Foundation

class User {
    //MARK: Constants
    static let endpoint = "/user"
    static let endpoint_affiliateStatus = "/user/affiliateStatus"
    static let endpoint_cancelWithdrawal = "/user/cancelWithdrawal"
    static let endpoint_checkReferralCode = "/user/checkReferralCode"
    static let endpoint_commission = "/user/commission"
    static let endpoint_communicationToken = "/user/communicationToken"
    static let endpoint_confirmEmail = "/user/confirmEmail"
    static let endpoint_confirmWithdrawal = "/user/confirmWithdrawal"
    static let endpoint_depositAddress = "/user/depositAddress"
    static let endpoint_executionHistory = "/user/executionHistory"
    static let endpoint_logout = "/user/logout"
    static let endpoint_margin = "/user/margin"
    static let endpoint_minWithdrawalFee = "/user/minWithdrawalFee"
    static let endpoint_preferences = "/user/preferences"
    static let endpoint_quoteFillRatio = "/user/quoteFillRatio"
    static let endpoint_requestWithdrawal = "/user/requestWithdrawal"
    static let endpoint_wallet = "/user/wallet"
    static let endpoint_walletHistory = "/user/walletHistory"
    static let endpoint_walletSummary = "/user/walletSummary"
    
    
    //MARK: Properties
    var id: Double?
    var ownerId: Double?
    var firstname: String?
    var lastname: String?
    var username: String
    var email: String
    var phone: String?
    var created: String?
    var lastUpdated: String?
    var preferences: UserPreferences?
    var restrictedEngineFields: Any?
    var TFAEnabled: String?
    var affiliateID: String?
    var pgpPubKey: String?
    var country: String?
    var geoipCountry: String?
    var geoipRegion: String?
    var typ: String?
    
    
    //MARK: Initialization
    private init(id: Double?, ownerId: Double?, firstname: String?, lastname: String?, username: String, email: String, phone: String?, created: String?, lastUpdated: String?, preferences: UserPreferences?, restrictedEngineFields: Any?, TFAEnabled: String?, affiliateID: String?, pgpPubKey: String?, country: String?, geoipCountry: String?, geoipRegion: String?, typ: String?) {
        self.id = id
        self.ownerId = ownerId
        self.firstname = firstname
        self.lastname = lastname
        self.username = username
        self.email = email
        self.phone = phone
        self.created = created
        self.lastUpdated = lastUpdated
        self.preferences = preferences
        self.restrictedEngineFields = restrictedEngineFields
        self.TFAEnabled = TFAEnabled
        self.affiliateID = affiliateID
        self.pgpPubKey = pgpPubKey
        self.country = country
        self.geoipCountry = geoipCountry
        self.geoipRegion = geoipRegion
        self.typ = typ
    }
    
    
    
    //MARK: Types
    struct Columns {
        static let id = "id"
        static let ownerId = "ownerId"
        static let firstname = "firstname"
        static let lastname = "lastname"
        static let username = "username"
        static let email = "email"
        static let phone = "phone"
        static let created = "created"
        static let lastUpdated = "lastUpdated"
        static let preferences = "preferences"
        static let restrictedEngineFields = "restrictedEngineFields"
        static let TFAEnabled = "TFAEnabled"
        static let affiliateID = "affiliateID"
        static let pgpPubKey = "pgpPubKey"
        static let country = "country"
        static let geoipCountry = "geoipCountry"
        static let geoipRegion = "geoipRegion"
        static let typ = "typ"
    }
    
    //MARK: Static Methods
    static func GET(authentication: Authentication, completion: @escaping (User?, URLResponse?, Error?) -> Void) {
        
        let scheme = "https"
        let host = "www.bitmex.com"
        let path = "/api/v1" + endpoint
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        
        let headers = authentication.getHeaders(for: request)
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(nil, response, error)
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    completion(nil, response, nil)
                }
            } else {
                completion(nil, response, nil)
                return
            }
            guard let data = data else {
                completion(nil, response, nil)
                return
            }
            do {
                if let item = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    let id: Double? = item["id"] as? Double
                    let ownerId: Double? = item["ownerId"] as? Double
                    let firstname: String? = item["firstname"] as? String
                    let lastname: String? = item["lastname"] as? String
                    let username: String = item["username"] as! String
                    let email: String = item["email"] as! String
                    let phone: String? = item["phone"] as? String
                    let created: String? = item["created"] as? String
                    let lastUpdated: String? = item["lastUpdated"] as? String
                    let preferencesData: Data? = item["preferences"] as? Data
                    var preferences: UserPreferences? = nil
                    if let prefData = preferencesData {
                        if let item2 = try JSONSerialization.jsonObject(with: prefData, options: []) as? [String: Any] {
                            let alertOnLiquidations: Bool? = item2["alertOnLiquidations"] as? Bool
                            let animationsEnabled: Bool? = item2["animationsEnabled"] as? Bool
                            let announcementsLastSeen: String? = item2["announcementsLastSeen"] as? String
                            let chatChannelID: Double? = item2["chatChannelID"] as? Double
                            let colorTheme: String? = item2["colorTheme"] as? String
                            let currency: String? = item2["currency"] as? String
                            let debug: Bool? = item2["debug"] as? Bool
                            let disableEmails: [String]? = item2["disableEmails"] as? [String]
                            let disablePush: [String]? = item2["disablePush"] as? [String]
                            let hideConfirmDialogs: [String]? = item2["hideConfirmDialogs"] as? [String]
                            let hideConnectionModal: Bool? = item2["hideConnectionModal"] as? Bool
                            let hideFromLeaderboard: Bool? = item2["hideFromLeaderboard"] as? Bool
                            let hideNameFromLeaderboard: Bool? = item2["hideNameFromLeaderboard"] as? Bool
                            let hideNotifications: [String]? = item2["hideNotifications"] as? [String]
                            let locale: String? = item2["locale"] as? String
                            let msgsSeen: [String]? = item2["msgsSeen"] as? [String]
                            let orderBookBinning: Any? = item2["orderBookBinning"]
                            let orderBookType: String? = item2["orderBookType"] as? String
                            let orderClearImmediate: Bool? = item2["orderClearImmediate"] as? Bool
                            let orderControlsPlusMinus: Bool? = item2["orderControlsPlusMinus"] as? Bool
                            let showLocaleNumbers: Bool? = item2["showLocaleNumbers"] as? Bool
                            let sounds: [String]? = item2["sounds"] as? [String]
                            let strictIPCheck: Bool? = item2["strictIPCheck"] as? Bool
                            let strictTimeout: Bool? = item2["strictTimeout"] as? Bool
                            let tickerGroup: String? = item2["tickerGroup"] as? String
                            let tickerPinned: Bool? = item2["tickerPinned"] as? Bool
                            let tradeLayout: String? = item2["tradeLayout"] as? String
                            preferences = UserPreferences(alertOnLiquidations: alertOnLiquidations, animationsEnabled: animationsEnabled, announcementsLastSeen: announcementsLastSeen, chatChannelID: chatChannelID, colorTheme: colorTheme, currency: currency, debug: debug, disableEmails: disableEmails, disablePush: disablePush, hideConfirmDialogs: hideConfirmDialogs, hideConnectionModal: hideConnectionModal, hideFromLeaderboard: hideFromLeaderboard, hideNameFromLeaderboard: hideNameFromLeaderboard, hideNotifications: hideNotifications, locale: locale, msgsSeen: msgsSeen, orderBookBinning: orderBookBinning, orderBookType: orderBookType, orderClearImmediate: orderClearImmediate, orderControlsPlusMinus: orderControlsPlusMinus, showLocaleNumbers: showLocaleNumbers, sounds: sounds, strictIPCheck: strictIPCheck, strictTimeout: strictTimeout, tickerGroup: tickerGroup, tickerPinned: tickerPinned, tradeLayout: tradeLayout)
                        }
                    }
                    let restrictedEngineFields: Any? = item["restrictedEngineFields"]
                    let TFAEnabled: String? = item["TFAEnabled"] as? String
                    let affiliateID: String? = item["affiliateID"] as? String
                    let pgpPubKey: String? = item["pgpPubKey"] as? String
                    let country: String? = item["country"] as? String
                    let geoipCountry: String? = item["geoipCountry"] as? String
                    let geoipRegion: String? = item["geoipRegion"] as? String
                    let typ: String? = item["typ"] as? String
                    let user = User(id: id, ownerId: ownerId, firstname: firstname, lastname: lastname, username: username, email: email, phone: phone, created: created, lastUpdated: lastUpdated, preferences: preferences, restrictedEngineFields: restrictedEngineFields, TFAEnabled: TFAEnabled, affiliateID: affiliateID, pgpPubKey: pgpPubKey, country: country, geoipCountry: geoipCountry, geoipRegion: geoipRegion, typ: typ)
                    completion(user, response, nil)
                } else {
                    completion(nil, response, nil)
                }
            } catch {
                completion(nil, response, nil)
            }
            
        }
        task.resume()
    }
    
    
    static func GET_AffiliateStatus(authentication: Authentication, completion: @escaping (Affiliate?, URLResponse?, Error?) -> Void) {
        
        let scheme = "https"
        let host = "www.bitmex.com"
        let path = "/api/v1" + endpoint_affiliateStatus
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        
        let headers = authentication.getHeaders(for: request)
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(nil, response, error)
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    completion(nil, response, nil)
                }
            } else {
                completion(nil, response, nil)
                return
            }
            guard let data = data else {
                completion(nil, response, nil)
                return
            }
            do {
                if let item = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    let account: Double = item["account"] as! Double
                    let currency: String = item["currency"] as! String
                    let prevPayout: Double? = item["prevPayout"] as? Double
                    let prevTurnover: Double? = item["prevTurnover"] as? Double
                    let prevComm: Double? = item["prevComm"] as? Double
                    let prevTimestamp: String? = item["prevTimestamp"] as? String
                    let execTurnover: Double? = item["execTurnover"] as? Double
                    let execComm: Double? = item["execComm"] as? Double
                    let totalReferrals: Double? = item["totalReferrals"] as? Double
                    let totalTurnover: Double? = item["totalTurnover"] as? Double
                    let totalComm: Double? = item["totalComm"] as? Double
                    let payoutPcnt: Double? = item["payoutPcnt"] as? Double
                    let pendingPayout: Double? = item["pendingPayout"] as? Double
                    let timestamp: String? = item["timestamp"] as? String
                    let referrerAccount: Double? = item["referrerAccount"] as? Double
                    let referralDiscount: Double? = item["referralDiscount"] as? Double
                    let affiliatePayout: Double? = item["affiliatePayout"] as? Double
                    let aff = Affiliate(account: account, currency: currency, prevPayout: prevPayout, prevTurnover: prevTurnover, prevComm: prevComm, prevTimestamp: prevTimestamp, execTurnover: execTurnover, execComm: execComm, totalReferrals: totalReferrals, totalTurnover: totalTurnover, totalComm: totalComm, payoutPcnt: payoutPcnt, pendingPayout: pendingPayout, timestamp: timestamp, referrerAccount: referrerAccount, referralDiscount: referralDiscount, affiliatePayout: affiliatePayout)
                    completion(aff, response, nil)
                } else {
                    completion(nil, response, nil)
                }
            } catch {
                completion(nil, response, nil)
            }
            
        }
        task.resume()
    }
    
    
    static func POST_CancelWithdrawal(authentication: Authentication, token: String, completion: @escaping (Transaction?, URLResponse?, Error?) -> Void) {
        
        let scheme = "https"
        let host = "www.bitmex.com"
        let path = "/api/v1" + endpoint_cancelWithdrawal
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "POST"
        
        var parameters: [String: Any] = [:]
        
        parameters["token"] = token
        
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
        } catch let err {
            completion(nil, nil, err)
            return
        }
        
        
        let headers = authentication.getHeaders(for: request)
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(nil, response, error)
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    completion(nil, response, nil)
                }
            } else {
                completion(nil, response, nil)
                return
            }
            guard let data = data else {
                completion(nil, response, nil)
                return
            }
            do {
                if let item = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    let transactID: String = item["transactID"] as! String
                    let account: Double? = item["account"] as? Double
                    let currency: String? = item["currency"] as? String
                    let transactType: String? = item["transactType"] as? String
                    let amount: Double? = item["amount"] as? Double
                    let fee: Double? = item["fee"] as? Double
                    let transactStatus: String? = item["transactStatus"] as? String
                    let address: String? = item["address"] as? String
                    let tx: String? = item["tx"] as? String
                    let text: String? = item["text"] as? String
                    let transactTime: String? = item["transactTime"] as? String
                    let timestamp: String? = item["timestamp"] as? String
                    let trans = Transaction(transactID: transactID, account: account, currency: currency, transactType: transactType, amount: amount, fee: fee, transactStatus: transactStatus, address: address, tx: tx, text: text, transactTime: transactTime, timestamp: timestamp)
                    completion(trans, response, nil)
                } else {
                    completion(nil, response, nil)
                }
            } catch {
                completion(nil, response, nil)
            }
            
        }
        task.resume()
    }
    
    static func GET_CheckReferralCode(referralCode: String, completion: @escaping (Bool?, URLResponse?, Error?) -> Void) {
        
        let scheme = "https"
        let host = "www.bitmex.com"
        let path = "/api/v1" + endpoint_checkReferralCode
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        
        var queryItems = [URLQueryItem]()
        
        queryItems.append(URLQueryItem(name: "referralCode", value: referralCode))
        
        
        if !queryItems.isEmpty {
            urlComponents.queryItems = queryItems
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(nil, response, error)
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    completion(true, response, nil)
                } else if httpResponse.statusCode == 404 || httpResponse.statusCode == 451 {
                    completion(false, response, nil)
                } else {
                    completion(nil, response, nil)
                }
            } else {
                completion(nil, response, nil)
                return
            }
            
        }
        task.resume()
    }
    
    
    
    
    
    
    
    static func GET_Commission(authentication: Authentication, completion: @escaping (UserCommission?, URLResponse?, Error?) -> Void) {
        let scheme = "https"
        let host = "www.bitmex.com"
        let path = "/api/v1" + endpoint_commission
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        
        let headers = authentication.getHeaders(for: request)
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(nil, response, error)
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    completion(nil, response, nil)
                }
            } else {
                completion(nil, response, nil)
                return
            }
            guard let data = data else {
                completion(nil, response, nil)
                return
            }
            do {
                if let item = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    let dd = item["__symbol__"] as? Data
                    if let dd = dd {
                        if let item2 = try JSONSerialization.jsonObject(with: dd, options: []) as? [String: Any] {
                            let makerFee: Double? = item2["makerFee"] as? Double
                            let takerFee: Double? = item2["takerFee"] as? Double
                            let settlementFee: Double? = item2["settlementFee"] as? Double
                            let maxFee: Double? = item2["maxFee"] as? Double
                            let userCommission = UserCommission(makerFee: makerFee, takerFee: takerFee, settlementFee: settlementFee, maxFee: maxFee)
                            completion(userCommission, response, nil)
                            return
                        }
                    }
                    completion(nil, response, nil)
                } else {
                    completion(nil, response, nil)
                }
            } catch {
                completion(nil, response, nil)
            }
            
        }
        task.resume()
    }
    
    
    static func POST_CommunicationToken(authentication: Authentication, token: String, platformAgent: String, completion: @escaping ([CommunicationToken]?, URLResponse?, Error?) -> Void) {
        
        let scheme = "https"
        let host = "www.bitmex.com"
        let path = "/api/v1" + endpoint_communicationToken
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "POST"
        
        var parameters: [String: Any] = [:]
        
        parameters["token"] = token
        parameters["platformAgent"] = platformAgent
        
        
        
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
        } catch let err {
            completion(nil, nil, err)
            return
        }
        
        let headers = authentication.getHeaders(for: request)
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(nil, response, error)
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    completion(nil, response, nil)
                }
            } else {
                completion(nil, response, nil)
                return
            }
            guard let data = data else {
                completion(nil, response, nil)
                return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    var result = [CommunicationToken]()
                    for item in json {
                        let id: String = item["id"] as! String
                        let userId: Double = item["userId"] as! Double
                        let deviceToken: String = item["deviceToken"] as! String
                        let channel: String = item["channel"] as! String
                        let comToken = CommunicationToken(id: id, userId: userId, deviceToken: deviceToken, channel: channel)
                        result.append(comToken)
                    }
                    completion(result, response, nil)
                } else {
                    completion(nil, response, nil)
                }
            } catch {
                completion(nil, response, nil)
            }
            
        }
        task.resume()
    }
    
    
    static func POST_ConfirmEmail(authentication: Authentication, token: String, completion: @escaping (AccessToken?, URLResponse?, Error?) -> Void) {
        
        let scheme = "https"
        let host = "www.bitmex.com"
        let path = "/api/v1" + endpoint_confirmEmail
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "POST"
        
        var parameters: [String: Any] = [:]
        parameters["token"] = token
        
        
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
        } catch let err {
            completion(nil, nil, err)
            return
        }
        
        let headers = authentication.getHeaders(for: request)
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(nil, response, error)
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    completion(nil, response, nil)
                }
            } else {
                completion(nil, response, nil)
                return
            }
            guard let data = data else {
                completion(nil, response, nil)
                return
            }
            do {
                if let item = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    let id: String = item["id"] as! String
                    let ttl: Double? = item["ttl"] as? Double
                    let created: String? = item["created"] as? String
                    let userId: Double? = item["userId"] as? Double
                    let accessToken = AccessToken(id: id, ttl: ttl, created: created, userId: userId)
                    completion(accessToken, response, nil)
                } else {
                    completion(nil, response, nil)
                }
            } catch {
                completion(nil, response, nil)
            }
            
        }
        task.resume()
    }
    
    
    
    static func POST_ConfirmWithdrawal(authentication: Authentication, token: String, completion: @escaping (Transaction?, URLResponse?, Error?) -> Void) {
        
        let scheme = "https"
        let host = "www.bitmex.com"
        let path = "/api/v1" + endpoint_confirmWithdrawal
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "POST"
        
        var parameters: [String: Any] = [:]
        parameters["token"] = token
        
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
        } catch let err {
            completion(nil, nil, err)
            return
        }
        
        let headers = authentication.getHeaders(for: request)
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(nil, response, error)
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    completion(nil, response, nil)
                }
            } else {
                completion(nil, response, nil)
                return
            }
            guard let data = data else {
                completion(nil, response, nil)
                return
            }
            do {
                if let item = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    let transactID: String = item["transactID"] as! String
                    let account: Double? = item["account"] as? Double
                    let currency: String? = item["currency"] as? String
                    let transactType: String? = item["transactType"] as? String
                    let amount: Double? = item["amount"] as? Double
                    let fee: Double? = item["fee"] as? Double
                    let transactStatus: String? = item["transactStatus"] as? String
                    let address: String? = item["address"] as? String
                    let tx: String? = item["tx"] as? String
                    let text: String? = item["text"] as? String
                    let transactTime: String? = item["transactTime"] as? String
                    let timestamp: String? = item["timestamp"] as? String
                    let trans = Transaction(transactID: transactID, account: account, currency: currency, transactType: transactType, amount: amount, fee: fee, transactStatus: transactStatus, address: address, tx: tx, text: text, transactTime: transactTime, timestamp: timestamp)
                    completion(trans, response, nil)
                } else {
                    completion(nil, response, nil)
                }
            } catch {
                completion(nil, response, nil)
            }
            
        }
        task.resume()
    }
    
    
    
    
    
    static func GET_DepositAddress(authentication: Authentication, currency: String, completion: @escaping (String?, URLResponse?, Error?) -> Void) {
        
        let scheme = "https"
        let host = "www.bitmex.com"
        let path = "/api/v1" + endpoint_depositAddress
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        
        var queryItems = [URLQueryItem]()
        
        queryItems.append(URLQueryItem(name: "currency", value: currency))
        
        
        if !queryItems.isEmpty {
            urlComponents.queryItems = queryItems
        }
        
        let headers = authentication.getHeaders(for: request)
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(nil, response, error)
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    completion(nil, response, nil)
                }
            } else {
                completion(nil, response, nil)
                return
            }
            
            guard let data = data else {
                completion(nil, response, nil)
                return
            }
            if let resp = String(data: data, encoding: .utf8) {
                completion(resp, response, nil)
            } else {
                completion(nil, response, nil)
            }
        }
        task.resume()
    }
    
    
    static func GET_ExecutionHistory(authentication: Authentication, symbol: String? = nil, timestamp: String? = nil, completion: @escaping (String?, URLResponse?, Error?) -> Void) {
        
        let scheme = "https"
        let host = "www.bitmex.com"
        let path = "/api/v1" + endpoint_executionHistory
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        
        var queryItems = [URLQueryItem]()
        if let symbol = symbol {
            queryItems.append(URLQueryItem(name: "symbol", value: symbol))
        }
        if let timestamp = timestamp {
            queryItems.append(URLQueryItem(name: "timestamp", value: timestamp))
        }
        
        if !queryItems.isEmpty {
            urlComponents.queryItems = queryItems
        }
        
        let headers = authentication.getHeaders(for: request)
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(nil, response, error)
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    completion(nil, response, nil)
                }
            } else {
                completion(nil, response, nil)
                return
            }
            
            guard let data = data else {
                completion(nil, response, nil)
                return
            }
            if let resp = String(data: data, encoding: .utf8) {
                completion(resp, response, nil)
            } else {
                completion(nil, response, nil)
            }
        }
        task.resume()
    }
    
    static func POST_Logout(authentication: Authentication, completion: @escaping (Bool?, URLResponse?, Error?) -> Void) {
        
        let scheme = "https"
        let host = "www.bitmex.com"
        let path = "/api/v1" + endpoint_logout
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "POST"
        
        
        let headers = authentication.getHeaders(for: request)
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(nil, response, error)
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    completion(true, response, nil)
                } else {
                    completion(false, response, nil)
                }
            } else {
                completion(nil, response, nil)
                return
            }
            
        }
        task.resume()
    }
    
    
    
    
    static func GET_Margin(authentication: Authentication, currency: String, completion: @escaping (Margin?, URLResponse?, Error?) -> Void) {
        
        let scheme = "https"
        let host = "www.bitmex.com"
        let path = "/api/v1" + endpoint_margin
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        
        var queryItems = [URLQueryItem]()
        
        queryItems.append(URLQueryItem(name: "currency", value: currency))
        
        
        if !queryItems.isEmpty {
            urlComponents.queryItems = queryItems
        }
        
        let headers = authentication.getHeaders(for: request)
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(nil, response, error)
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    completion(nil, response, nil)
                }
            } else {
                completion(nil, response, nil)
                return
            }
            
            guard let data = data else {
                completion(nil, response, nil)
                return
            }
            
            do {
                if let items = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    let margin = Margin(item: items[0])
                    completion(margin, response, nil)

                } else {
                    completion(nil, response, nil)
                }
            } catch {
                completion(nil, response, nil)
            }
            
        }
        task.resume()
    }
    
    
    
    static func GET_MinimmumWithdrawalFee(currency: String, completion: @escaping (String?, URLResponse?, Error?) -> Void) {
        
        let scheme = "https"
        let host = "www.bitmex.com"
        let path = "/api/v1" + endpoint_minWithdrawalFee
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "currency", value: currency))
        
        if !queryItems.isEmpty {
            urlComponents.queryItems = queryItems
        }
        
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(nil, response, error)
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    completion(nil, response, nil)
                }
            } else {
                completion(nil, response, nil)
                return
            }
            
            guard let data = data else {
                completion(nil, response, nil)
                return
            }
            if let resp = String(data: data, encoding: .utf8) {
                completion(resp, response, nil)
            } else {
                completion(nil, response, nil)
            }
        }
        task.resume()
    }
    
    
    
    static func POST_Preferences(authentication: Authentication, prefs: String, overwrite: Bool? = nil, completion: @escaping (UserPreferences?, URLResponse?, Error?) -> Void) {
        
        let scheme = "https"
        let host = "www.bitmex.com"
        let path = "/api/v1" + endpoint_preferences
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "POST"
        
        var parameters: [String: Any] = [:]
        parameters["prefs"] = prefs

        if let overwrite = overwrite {
            parameters["overwrite"] = overwrite
        }
        
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
        } catch let err {
            completion(nil, nil, err)
            return
        }
        
        let headers = authentication.getHeaders(for: request)
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(nil, response, error)
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    completion(nil, response, nil)
                }
            } else {
                completion(nil, response, nil)
                return
            }
            guard let data = data else {
                completion(nil, response, nil)
                return
            }
            do {
                if let item2 = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    let alertOnLiquidations: Bool? = item2["alertOnLiquidations"] as? Bool
                    let animationsEnabled: Bool? = item2["animationsEnabled"] as? Bool
                    let announcementsLastSeen: String? = item2["announcementsLastSeen"] as? String
                    let chatChannelID: Double? = item2["chatChannelID"] as? Double
                    let colorTheme: String? = item2["colorTheme"] as? String
                    let currency: String? = item2["currency"] as? String
                    let debug: Bool? = item2["debug"] as? Bool
                    let disableEmails: [String]? = item2["disableEmails"] as? [String]
                    let disablePush: [String]? = item2["disablePush"] as? [String]
                    let hideConfirmDialogs: [String]? = item2["hideConfirmDialogs"] as? [String]
                    let hideConnectionModal: Bool? = item2["hideConnectionModal"] as? Bool
                    let hideFromLeaderboard: Bool? = item2["hideFromLeaderboard"] as? Bool
                    let hideNameFromLeaderboard: Bool? = item2["hideNameFromLeaderboard"] as? Bool
                    let hideNotifications: [String]? = item2["hideNotifications"] as? [String]
                    let locale: String? = item2["locale"] as? String
                    let msgsSeen: [String]? = item2["msgsSeen"] as? [String]
                    let orderBookBinning: Any? = item2["orderBookBinning"]
                    let orderBookType: String? = item2["orderBookType"] as? String
                    let orderClearImmediate: Bool? = item2["orderClearImmediate"] as? Bool
                    let orderControlsPlusMinus: Bool? = item2["orderControlsPlusMinus"] as? Bool
                    let showLocaleNumbers: Bool? = item2["showLocaleNumbers"] as? Bool
                    let sounds: [String]? = item2["sounds"] as? [String]
                    let strictIPCheck: Bool? = item2["strictIPCheck"] as? Bool
                    let strictTimeout: Bool? = item2["strictTimeout"] as? Bool
                    let tickerGroup: String? = item2["tickerGroup"] as? String
                    let tickerPinned: Bool? = item2["tickerPinned"] as? Bool
                    let tradeLayout: String? = item2["tradeLayout"] as? String
                    let preferences = UserPreferences(alertOnLiquidations: alertOnLiquidations, animationsEnabled: animationsEnabled, announcementsLastSeen: announcementsLastSeen, chatChannelID: chatChannelID, colorTheme: colorTheme, currency: currency, debug: debug, disableEmails: disableEmails, disablePush: disablePush, hideConfirmDialogs: hideConfirmDialogs, hideConnectionModal: hideConnectionModal, hideFromLeaderboard: hideFromLeaderboard, hideNameFromLeaderboard: hideNameFromLeaderboard, hideNotifications: hideNotifications, locale: locale, msgsSeen: msgsSeen, orderBookBinning: orderBookBinning, orderBookType: orderBookType, orderClearImmediate: orderClearImmediate, orderControlsPlusMinus: orderControlsPlusMinus, showLocaleNumbers: showLocaleNumbers, sounds: sounds, strictIPCheck: strictIPCheck, strictTimeout: strictTimeout, tickerGroup: tickerGroup, tickerPinned: tickerPinned, tradeLayout: tradeLayout)
                    completion(preferences, response, nil)
                } else {
                    completion(nil, response, nil)
                }
            } catch {
                completion(nil, response, nil)
            }
            
        }
        task.resume()
    }
    
    
    static func GET_QuoteFillRatio(authentication: Authentication, completion: @escaping (QuoteFillRatio?, URLResponse?, Error?) -> Void) {
        
        let scheme = "https"
        let host = "www.bitmex.com"
        let path = "/api/v1" + endpoint_quoteFillRatio
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        
        let headers = authentication.getHeaders(for: request)
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(nil, response, error)
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    completion(nil, response, nil)
                }
            } else {
                completion(nil, response, nil)
                return
            }
            guard let data = data else {
                completion(nil, response, nil)
                return
            }
            do {
                if let item = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    let date: String = item["date"] as! String
                    let account: Double? = item["account"] as? Double
                    let quoteCount: Double? = item["quoteCount"] as? Double
                    let dealtCount: Double? = item["dealtCount"] as? Double
                    let quotesMavg7: Double? = item["quotesMavg7"] as? Double
                    let dealtMavg7: Double? = item["dealtMavg7"] as? Double
                    let quoteFillRatioMavg7: Double? = item["quoteFillRatioMavg7"] as? Double
                    let qfr = QuoteFillRatio(date: date, account: account, quoteCount: quoteCount, dealtCount: dealtCount, quotesMavg7: quotesMavg7, dealtMavg7: dealtMavg7, quoteFillRatioMavg7: quoteFillRatioMavg7)
                    completion(qfr, response, nil)

                } else {
                    completion(nil, response, nil)
                }
            } catch {
                completion(nil, response, nil)
            }
            
        }
        task.resume()
    }
    
    static func POST_RequestWithdrawal(authentication: Authentication, otpToken: String? = nil, currency: String,amount: Double, address: String, fee: Double? = nil, text: String? = nil, completion: @escaping (Transaction?, URLResponse?, Error?) -> Void) {
        
        let scheme = "https"
        let host = "www.bitmex.com"
        let path = "/api/v1" + endpoint_requestWithdrawal
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "POST"
        
        var parameters: [String: Any] = [:]

        if let otpToken = otpToken {
            parameters["otpToken"] = otpToken
        }
        
        parameters["currency"] = currency
        parameters["amount"] = amount
        parameters["address"] = address

        if let fee = fee {
            parameters["fee"] = fee
        }
        if let text = text {
            parameters["text"] = text
        }
        
        
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
        } catch let err {
            completion(nil, nil, err)
            return
        }
        
        let headers = authentication.getHeaders(for: request)
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(nil, response, error)
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    completion(nil, response, nil)
                }
            } else {
                completion(nil, response, nil)
                return
            }
            guard let data = data else {
                completion(nil, response, nil)
                return
            }
            do {
                if let item = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    let transactID: String = item["transactID"] as! String
                    let account: Double? = item["account"] as? Double
                    let currency: String? = item["currency"] as? String
                    let transactType: String? = item["transactType"] as? String
                    let amount: Double? = item["amount"] as? Double
                    let fee: Double? = item["fee"] as? Double
                    let transactStatus: String? = item["transactStatus"] as? String
                    let address: String? = item["address"] as? String
                    let tx: String? = item["tx"] as? String
                    let text: String? = item["text"] as? String
                    let transactTime: String? = item["transactTime"] as? String
                    let timestamp: String? = item["timestamp"] as? String
                    let trans = Transaction(transactID: transactID, account: account, currency: currency, transactType: transactType, amount: amount, fee: fee, transactStatus: transactStatus, address: address, tx: tx, text: text, transactTime: transactTime, timestamp: timestamp)
                    completion(trans, response, nil)
                } else {
                    completion(nil, response, nil)
                }
            } catch {
                completion(nil, response, nil)
            }
            
        }
        task.resume()
    }
    
    
    
    static func GET_Wallet(authentication: Authentication, currency: String? = nil, completion: @escaping (Wallet?, URLResponse?, Error?) -> Void) {
        
        let scheme = "https"
        let host = "www.bitmex.com"
        let path = "/api/v1" + endpoint_wallet
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        
        var queryItems = [URLQueryItem]()
        if let currency = currency {
            queryItems.append(URLQueryItem(name: "currency", value: currency))
        }
        
        if !queryItems.isEmpty {
            urlComponents.queryItems = queryItems
        }
        
        
        let headers = authentication.getHeaders(for: request)
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(nil, response, error)
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    completion(nil, response, nil)
                }
            } else {
                completion(nil, response, nil)
                return
            }
            guard let data = data else {
                completion(nil, response, nil)
                return
            }
            do {
                if let item = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    let wallet = Wallet(item: item)
                    completion(wallet, response, nil)
                } else {
                    completion(nil, response, nil)
                }
            } catch {
                completion(nil, response, nil)
            }
            
        }
        task.resume()
    }
    
    
    static func GET_WalletHistory(authentication: Authentication, currency: String? = nil, count: Int? = nil, start: Int? = nil, completion: @escaping ([WalletHistory]?, URLResponse?, Error?) -> Void) {
        
        let scheme = "https"
        let host = "www.bitmex.com"
        let path = "/api/v1" + endpoint_walletHistory
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        
        var queryItems = [URLQueryItem]()
        if let currency = currency {
            queryItems.append(URLQueryItem(name: "currency", value: currency))
        }
        if let count = count {
            queryItems.append(URLQueryItem(name: "count", value: String(count)))
        }
        if let start = start {
            queryItems.append(URLQueryItem(name: "start", value: String(start)))
        }
        
        if !queryItems.isEmpty {
            urlComponents.queryItems = queryItems
        }
        
        
        let headers = authentication.getHeaders(for: request)
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(nil, response, error)
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    completion(nil, response, nil)
                }
            } else {
                completion(nil, response, nil)
                return
            }
            guard let data = data else {
                completion(nil, response, nil)
                return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    var result = [WalletHistory]()
                    for item in json {
                        let transactID: String = item["transactID"] as! String
                        let account: Double? = item["account"] as? Double
                        let currency: String? = item["currency"] as? String
                        let transactType: String? = item["transactType"] as? String
                        let amount: Double? = item["amount"] as? Double
                        let fee: Double? = item["fee"] as? Double
                        let transactStatus: String? = item["transactStatus"] as? String
                        let address: String? = item["address"] as? String
                        let tx: String? = item["tx"] as? String
                        let text: String? = item["text"] as? String
                        let transactTime: String? = item["transactTime"] as? String
                        let timestamp: String? = item["timestamp"] as? String
                        let walletHistory = WalletHistory(transactID: transactID, account: account, currency: currency, transactType: transactType, amount: amount, fee: fee, transactStatus: transactStatus, address: address, tx: tx, text: text, transactTime: transactTime, timestamp: timestamp)
                        result.append(walletHistory)
                    }
                    completion(result, response, nil)
                } else {
                    completion(nil, response, nil)
                }
            } catch {
                completion(nil, response, nil)
            }
            
        }
        task.resume()
    }
    
    
    
    static func GET_WalletSummary(authentication: Authentication, currency: String? = nil, completion: @escaping ([WalletSummary]?, URLResponse?, Error?) -> Void) {
        
        let scheme = "https"
        let host = "www.bitmex.com"
        let path = "/api/v1" + endpoint_walletSummary
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        
        var queryItems = [URLQueryItem]()
        if let currency = currency {
            queryItems.append(URLQueryItem(name: "currency", value: currency))
        }
        
        if !queryItems.isEmpty {
            urlComponents.queryItems = queryItems
        }
        
        
        let headers = authentication.getHeaders(for: request)
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(nil, response, error)
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    completion(nil, response, nil)
                }
            } else {
                completion(nil, response, nil)
                return
            }
            guard let data = data else {
                completion(nil, response, nil)
                return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    var result = [WalletSummary]()
                    for item in json {
                        let transactID: String = item["transactID"] as! String
                        let account: Int? = item["account"] as? Int
                        let currency: String? = item["currency"] as? String
                        let transactType: String? = item["transactType"] as? String
                        let amount: Double? = item["amount"] as? Double
                        let fee: Double? = item["fee"] as? Double
                        let transactStatus: String? = item["transactStatus"] as? String
                        let address: String? = item["address"] as? String
                        let tx: String? = item["tx"] as? String
                        let text: String? = item["text"] as? String
                        let transactTime: String? = item["transactTime"] as? String
                        let timestamp: String? = item["timestamp"] as? String
                        let ws = WalletSummary(transactID: transactID, account: account, currency: currency, transactType: transactType, amount: amount, fee: fee, transactStatus: transactStatus, address: address, tx: tx, text: text, transactTime: transactTime, timestamp: timestamp)
                        result.append(ws)
                    }
                    completion(result, response, nil)
                } else {
                    completion(nil, response, nil)
                }
            } catch {
                completion(nil, response, nil)
            }
            
        }
        task.resume()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    class UserPreferences {
        
        //MARK: Properties
        var alertOnLiquidations: Bool?
        var animationsEnabled: Bool?
        var announcementsLastSeen: String?
        var chatChannelID: Double?
        var colorTheme: String?
        var currency: String?
        var debug: Bool?
        var disableEmails: [String]?
        var disablePush: [String]?
        var hideConfirmDialogs: [String]?
        var hideConnectionModal: Bool?
        var hideFromLeaderboard: Bool?
        var hideNameFromLeaderboard: Bool?
        var hideNotifications: [String]?
        var locale: String?
        var msgsSeen: [String]?
        var orderBookBinning: Any?
        var orderBookType: String?
        var orderClearImmediate: Bool?
        var orderControlsPlusMinus: Bool?
        var showLocaleNumbers: Bool?
        var sounds: [String]?
        var strictIPCheck: Bool?
        var strictTimeout: Bool?
        var tickerGroup: String?
        var tickerPinned: Bool?
        var tradeLayout: String?
        
        
        //MARK: Initialization
        init(alertOnLiquidations: Bool?, animationsEnabled: Bool?, announcementsLastSeen: String?, chatChannelID: Double?, colorTheme: String?, currency: String?, debug: Bool?, disableEmails: [String]?, disablePush: [String]?, hideConfirmDialogs: [String]?, hideConnectionModal: Bool?, hideFromLeaderboard: Bool?, hideNameFromLeaderboard: Bool?, hideNotifications: [String]?, locale: String?, msgsSeen: [String]?, orderBookBinning: Any?, orderBookType: String?, orderClearImmediate: Bool?, orderControlsPlusMinus: Bool?, showLocaleNumbers: Bool?, sounds: [String]?, strictIPCheck: Bool?, strictTimeout: Bool?, tickerGroup: String?, tickerPinned: Bool?, tradeLayout: String?) {
            self.alertOnLiquidations = alertOnLiquidations
            self.animationsEnabled = animationsEnabled
            self.announcementsLastSeen = announcementsLastSeen
            self.chatChannelID = chatChannelID
            self.colorTheme = colorTheme
            self.currency = currency
            self.debug = debug
            self.disableEmails = disableEmails
            self.disablePush = disablePush
            self.hideConfirmDialogs = hideConfirmDialogs
            self.hideConnectionModal = hideConnectionModal
            self.hideFromLeaderboard = hideFromLeaderboard
            self.hideNameFromLeaderboard = hideNameFromLeaderboard
            self.hideNotifications = hideNotifications
            self.locale = locale
            self.msgsSeen = msgsSeen
            self.orderBookBinning = orderBookBinning
            self.orderBookType = orderBookType
            self.orderClearImmediate = orderClearImmediate
            self.orderControlsPlusMinus = orderControlsPlusMinus
            self.showLocaleNumbers = showLocaleNumbers
            self.sounds = sounds
            self.strictIPCheck = strictIPCheck
            self.strictTimeout = strictTimeout
            self.tickerGroup = tickerGroup
            self.tickerPinned = tickerPinned
            self.tradeLayout = tradeLayout
        }
        
        
    }

    
    class Affiliate {
        //MARK: Properties
        var account: Double
        var currency: String
        var prevPayout: Double?
        var prevTurnover: Double?
        var prevComm: Double?
        var prevTimestamp: String?
        var execTurnover: Double?
        var execComm: Double?
        var totalReferrals: Double?
        var totalTurnover: Double?
        var totalComm: Double?
        var payoutPcnt: Double?
        var pendingPayout: Double?
        var timestamp: String?
        var referrerAccount: Double?
        var referralDiscount: Double?
        var affiliatePayout: Double?
        
        //MARK: Initialization
        init(account: Double, currency: String, prevPayout: Double?, prevTurnover: Double?, prevComm: Double?, prevTimestamp: String?, execTurnover: Double?, execComm: Double?, totalReferrals: Double?, totalTurnover: Double?, totalComm: Double?, payoutPcnt: Double?, pendingPayout: Double?, timestamp: String?, referrerAccount: Double?, referralDiscount: Double?, affiliatePayout: Double?) {
            self.account = account
            self.currency = currency
            self.prevPayout = prevPayout
            self.prevTurnover = prevTurnover
            self.prevComm = prevComm
            self.prevTimestamp = prevTimestamp
            self.execTurnover = execTurnover
            self.execComm = execComm
            self.totalReferrals = totalReferrals
            self.totalTurnover = totalTurnover
            self.totalComm = totalComm
            self.payoutPcnt = payoutPcnt
            self.pendingPayout = pendingPayout
            self.timestamp = timestamp
            self.referrerAccount = referrerAccount
            self.referralDiscount = referralDiscount
            self.affiliatePayout = affiliatePayout
        }
        
        
    }
    
    
    class Transaction {
        //MARK: Properties
        var transactID: String
        var account: Double?
        var currency: String?
        var transactType: String?
        var amount: Double?
        var fee: Double?
        var transactStatus: String?
        var address: String?
        var tx: String?
        var text: String?
        var transactTime: String?
        var timestamp: String?
        
        
        //MARK: Initialization
        internal init(transactID: String, account: Double?, currency: String?, transactType: String?, amount: Double?, fee: Double?, transactStatus: String?, address: String?, tx: String?, text: String?, transactTime: String?, timestamp: String?) {
            self.transactID = transactID
            self.account = account
            self.currency = currency
            self.transactType = transactType
            self.amount = amount
            self.fee = fee
            self.transactStatus = transactStatus
            self.address = address
            self.tx = tx
            self.text = text
            self.transactTime = transactTime
            self.timestamp = timestamp
        }
        
    }
    
    
    
    
    
    class UserCommission {
        internal init(makerFee: Double?, takerFee: Double?, settlementFee: Double?, maxFee: Double?) {
            self.makerFee = makerFee
            self.takerFee = takerFee
            self.settlementFee = settlementFee
            self.maxFee = maxFee
        }
        
        var makerFee: Double?
        var takerFee: Double?
        var settlementFee: Double?
        var maxFee: Double?
    }
    
    
    class CommunicationToken {
        internal init(id: String, userId: Double, deviceToken: String, channel: String) {
            self.id = id
            self.userId = userId
            self.deviceToken = deviceToken
            self.channel = channel
        }
        
        var id: String
        var userId: Double
        var deviceToken: String
        var channel: String
    }
    
    
    
    class AccessToken {
        internal init(id: String, ttl: Double?, created: String?, userId: Double?) {
            self.id = id
            self.ttl = ttl
            self.created = created
            self.userId = userId
        }
        
        var id: String
        var ttl: Double? // time to live in seconds (2 weeks by default) ,
        var created: String?
        var userId: Double?
    }
    
    
    
    class Margin {
        internal init(item: [String: Any]) {
            account = item["account"] as! Int
            currency = item["currency"] as! String
            riskLimit = item["riskLimit"] as? Double
            prevState = item["prevState"] as? String
            state = item["state"] as? String
            action = item["action"] as? String
            amount = item["amount"] as? Double
            pendingCredit = item["pendingCredit"] as? Double
            pendingDebit = item["pendingDebit"] as? Double
            confirmedDebit = item["confirmedDebit"] as? Double
            prevRealisedPnl = item["prevRealisedPnl"] as? Double
            prevUnrealisedPnl = item["prevUnrealisedPnl"] as? Double
            grossComm = item["grossComm"] as? Double
            grossOpenCost = item["grossOpenCost"] as? Double
            grossOpenPremium = item["grossOpenPremium"] as? Double
            grossExecCost = item["grossExecCost"] as? Double
            grossMarkValue = item["grossMarkValue"] as? Double
            riskValue = item["riskValue"] as? Double
            taxableMargin = item["taxableMargin"] as? Double
            initMargin = item["initMargin"] as? Double
            maintMargin = item["maintMargin"] as? Double
            sessionMargin = item["sessionMargin"] as? Double
            targetExcessMargin = item["targetExcessMargin"] as? Double
            varMargin = item["varMargin"] as? Double
            realisedPnl = item["realisedPnl"] as? Double
            unrealisedPnl = item["unrealisedPnl"] as? Double
            indicativeTax = item["indicativeTax"] as? Double
            unrealisedProfit = item["unrealisedProfit"] as? Double
            syntheticMargin = item["syntheticMargin"] as? Double
            walletBalance = item["walletBalance"] as? Int
            marginBalance = item["marginBalance"] as? Int
            marginBalancePcnt = item["marginBalancePcnt"] as? Double
            marginLeverage = item["marginLeverage"] as? Double
            marginUsedPcnt = item["marginUsedPcnt"] as? Double
            excessMargin = item["excessMargin"] as? Int
            excessMarginPcnt = item["excessMarginPcnt"] as? Double
            availableMargin = item["availableMargin"] as? Double
            withdrawableMargin = item["withdrawableMargin"] as? Double
            timestamp = item["timestamp"] as? String
            grossLastValue = item["grossLastValue"] as? Double
            commission = item["commission"] as? Double
        }
        
        
        var account: Int
        var currency: String
        var riskLimit: Double?
        var prevState: String?
        var state: String?
        var action: String?
        var amount: Double?
        var pendingCredit: Double?
        var pendingDebit: Double?
        var confirmedDebit: Double?
        var prevRealisedPnl: Double?
        var prevUnrealisedPnl: Double?
        var grossComm: Double?
        var grossOpenCost: Double?
        var grossOpenPremium: Double?
        var grossExecCost: Double?
        var grossMarkValue: Double?
        var riskValue: Double?
        var taxableMargin: Double?
        var initMargin: Double?
        var maintMargin: Double?
        var sessionMargin: Double?
        var targetExcessMargin: Double?
        var varMargin: Double?
        var realisedPnl: Double?
        var unrealisedPnl: Double?
        var indicativeTax: Double?
        var unrealisedProfit: Double?
        var syntheticMargin: Double?
        var walletBalance: Int?
        var marginBalance: Int?
        var marginBalancePcnt: Double?
        var marginLeverage: Double?
        var marginUsedPcnt: Double?
        var excessMargin: Int?
        var excessMarginPcnt: Double?
        var availableMargin: Double?
        var withdrawableMargin: Double?
        var timestamp: String?
        var grossLastValue: Double?
        var commission: Double?
    }
    
    
    
    class QuoteFillRatio {
        internal init(date: String, account: Double?, quoteCount: Double?, dealtCount: Double?, quotesMavg7: Double?, dealtMavg7: Double?, quoteFillRatioMavg7: Double?) {
            self.date = date
            self.account = account
            self.quoteCount = quoteCount
            self.dealtCount = dealtCount
            self.quotesMavg7 = quotesMavg7
            self.dealtMavg7 = dealtMavg7
            self.quoteFillRatioMavg7 = quoteFillRatioMavg7
        }
        
        var date: String
        var account: Double?
        var quoteCount: Double?
        var dealtCount: Double?
        var quotesMavg7: Double?
        var dealtMavg7: Double?
        var quoteFillRatioMavg7: Double?
    }
    
    
    
    
    class Wallet {
        init(item: [String: Any]) {
            account = item["account"] as! Int
            currency = item["currency"] as! String
            prevDeposited = item["prevDeposited"] as? Double
            prevWithdrawn = item["prevWithdrawn"] as? Double
            prevTransferIn = item["prevTransferIn"] as? Double
            prevTransferOut = item["prevTransferOut"] as? Double
            prevAmount = item["prevAmount"] as? Double
            prevTimestamp = item["prevTimestamp"] as? String
            deltaDeposited = item["deltaDeposited"] as? Double
            deltaWithdrawn = item["deltaWithdrawn"] as? Double
            deltaTransferIn = item["deltaTransferIn"] as? Double
            deltaTransferOut = item["deltaTransferOut"] as? Double
            deltaAmount = item["deltaAmount"] as? Double
            deposited = item["deposited"] as? Double
            withdrawn = item["withdrawn"] as? Double
            transferIn = item["transferIn"] as? Double
            transferOut = item["transferOut"] as? Double
            amount = item["amount"] as? Double
            pendingCredit = item["pendingCredit"] as? Double
            pendingDebit = item["pendingDebit"] as? Double
            confirmedDebit = item["confirmedDebit"] as? Double
            timestamp = item["timestamp"] as? String
            addr = item["addr"] as? String
            script = item["script"] as? String
            withdrawalLock = item["withdrawalLock"] as? [String]
        }
        
        
        var account: Int
        var currency: String
        var prevDeposited: Double?
        var prevWithdrawn: Double?
        var prevTransferIn: Double?
        var prevTransferOut: Double?
        var prevAmount: Double?
        var prevTimestamp: String?
        var deltaDeposited: Double?
        var deltaWithdrawn: Double?
        var deltaTransferIn: Double?
        var deltaTransferOut: Double?
        var deltaAmount: Double?
        var deposited: Double?
        var withdrawn: Double?
        var transferIn: Double?
        var transferOut: Double?
        var amount: Double?
        var pendingCredit: Double?
        var pendingDebit: Double?
        var confirmedDebit: Double?
        var timestamp: String?
        var addr: String?
        var script: String?
        var withdrawalLock: [String]?
    }
    
    
    
    class WalletHistory {
        internal init(transactID: String, account: Double?, currency: String?, transactType: String?, amount: Double?, fee: Double?, transactStatus: String?, address: String?, tx: String?, text: String?, transactTime: String?, timestamp: String?) {
            self.transactID = transactID
            self.account = account
            self.currency = currency
            self.transactType = transactType
            self.amount = amount
            self.fee = fee
            self.transactStatus = transactStatus
            self.address = address
            self.tx = tx
            self.text = text
            self.transactTime = transactTime
            self.timestamp = timestamp
        }
        
        var transactID: String
        var account: Double?
        var currency: String?
        var transactType: String?
        var amount: Double?
        var fee: Double?
        var transactStatus: String?
        var address: String?
        var tx: String?
        var text: String?
        var transactTime: String?
        var timestamp: String?
    }
    
    class WalletSummary {
        internal init(transactID: String, account: Int?, currency: String?, transactType: String?, amount: Double?, fee: Double?, transactStatus: String?, address: String?, tx: String?, text: String?, transactTime: String?, timestamp: String?) {
            self.transactID = transactID
            self.account = account
            self.currency = currency
            self.transactType = transactType
            self.amount = amount
            self.fee = fee
            self.transactStatus = transactStatus
            self.address = address
            self.tx = tx
            self.text = text
            self.transactTime = transactTime
            self.timestamp = timestamp
        }
        
        var transactID: String
        var account: Int?
        var currency: String?
        var transactType: String?
        var amount: Double?
        var fee: Double?
        var transactStatus: String?
        var address: String?
        var tx: String?
        var text: String?
        var transactTime: String?
        var timestamp: String?
    }
    
    
    //MARK: - RealTime
    // Only Wallet and Margin depoloyed
    static func subscribeRealTime(webSocket: WebSocket, auth: Authentication) {
        let api_expires = String(Int(Date().timeIntervalSince1970.rounded()) + 5)
        let api_signature: String = "GET/realtime" + api_expires
        let sig = api_signature.hmac(algorithm: .SHA256, key: auth.apiSecret)
        webSocket.send(text: "{\"op\": \"authKeyExpires\", \"args\": [\"\(auth.apiKey)\", \(api_expires), \"\(sig)\"]}")
        
        
        let args: String = "[\"wallet\", \"margin\"]"
        let message: String = "{\"op\": \"subscribe\", \"args\": [" + args + "]}"
        webSocket.send(text: message)
        
    }
    
    static func unsubscribeRealTime(webSocket: WebSocket, auth: Authentication) {
        let api_expires = String(Int(Date().timeIntervalSince1970.rounded()) + 5)
        let api_signature: String = "GET/realtime" + api_expires
        let sig = api_signature.hmac(algorithm: .SHA256, key: auth.apiSecret)
        webSocket.send(text: "{\"op\": \"authKeyExpires\", \"args\": [\"\(auth.apiKey)\", \(api_expires), \"\(sig)\"]}")
        
        
        let args: String = "[\"wallet\", \"margin\"]"
        let message: String = "{\"op\": \"unsubscribe\", \"args\": [" + args + "]}"
        webSocket.send(text: message)
    }
    
}



