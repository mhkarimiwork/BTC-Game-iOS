//
//  OrderBook.swift
//  BitMEX
//
//  Created by Behnam Karimi on 6/20/1398 AP.
//  Copyright © 1398 AP Behnam Karimi. All rights reserved.
//

import Foundation

class OrderBookEntry {
    //MARK: Constants
    static let endpoint = "/orderBook/L2"
    
    //MARK: Properties
    var symbol: String
    var id: Double
    var side: String
    var size: Double?
    var price: Double?
    
    //MARK: Initialization
    private init(item: [String: Any]) {
        symbol = item["symbol"] as! String
        id = item["id"] as! Double
        side = item["side"] as! String
        size = item["size"] as? Double
        price = item["price"] as? Double
    }
    
    //MARK: Types
    struct Columns {
        static let symbol = "symbol"
        static let id = "id"
        static let side = "side"
        static let size = "size"
        static let price = "price"
    }
    
    
    //MARK: Static Methods
    
    /// send 0 for full depth
    static func GET(symbol: String, depth: Int? = nil, completion: @escaping ([OrderBookEntry]?, URLResponse?, Error?) -> Void) {
        let scheme = "https"
        let host = "www.bitmex.com"
        let path = "/api/v1" + endpoint
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        
        var queryItems = [URLQueryItem]()
        
        queryItems.append(URLQueryItem(name: "symbol", value: symbol))
        
        if let depth = depth {
            queryItems.append(URLQueryItem(name: "depth", value: String(depth)))
        }
        
        if !queryItems.isEmpty {
            urlComponents.queryItems = queryItems
        }
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        
        
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
                    var result = [OrderBookEntry]()
                    for item in json {
                        let ob = OrderBookEntry(item: item)
                        result.append(ob)
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
    
    
    //MARK: - RealTime
    
    static func subscribeRealTime(auth: Authentication) -> WebSocket {
        let url = "wss://www.bitmex.com/realtime"
        let webSocket = WebSocket(url)
        
        
        let args: String = "\"orderBookL2_25\""
        let message: String = "{\"op\": \"subscribe\", \"args\": [" + args + "]}"
        webSocket.send(text: message)
        
        return webSocket
    }
    
    static func unsubscribeRealTime(webSocket: WebSocket, auth: Authentication) {
        let args: String = "\"orderBookL2_25\""
        let message: String = "{\"op\": \"unsubscribe\", \"args\": [" + args + "]}"
        webSocket.send(text: message)
        webSocket.close()
    }
    

}
