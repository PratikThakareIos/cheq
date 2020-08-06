//
//  BasiqConnectionResponse.swift
//  Cheq
//
//  Created by Amit.Rawal on 29/04/20.
//  Copyright © 2020 Cheq. All rights reserved.
//

import Foundation


struct BasiqConnectionResponse : Codable {
    let type : String?
    let id : String?
    let links : Links?

    enum CodingKeys: String, CodingKey {

        case type = "type"
        case id = "id"
        case links = "links"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        links = try values.decodeIfPresent(Links.self, forKey: .links)
    }
}

struct Links : Codable {
    let linksSelf : String?

    enum CodingKeys: String, CodingKey {

        case linksSelf = "self"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        linksSelf = try values.decodeIfPresent(String.self, forKey: .linksSelf)
    }

}


/*

// MARK: - Welcome
public struct BasiqConnectionResponse: Codable {
    public var type: String?
    public var id: String?
    public var links: Links?
    
    public init(type: String?, id: String?, links: Links?) {
        self.type = type
        self.id = id
        self.links = links
    }
}

//        {
//            "type": "job",
//            "id": "0ee627e2-8293-445f-968a-aec426e15d6d",
//            "links": {
//                "self": "https://au-api.basiq.io/jobs/0ee627e2-8293-445f-968a-aec426e15d6d"
//            }
//        }


// MARK: - Links
public struct Links: Codable {
    let linksSelf: String?
    
    public init(linksSelf: String?) {
           self.linksSelf = linksSelf
    }
    
    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
    }
}

*/




//{
//  "loginId": "gavinBelson",
//  "password": "hooli2016",
//  "institution":{
//    "id":"AU00000"
//  }
//}
//

// MARK: - Welcome
public struct PostBasiqLoginRequest : Codable {
    
    public var loginId: String
    public var password: String
    public var institution: Institution
    
    public init(loginId: String, password: String, institution: Institution) {
        self.loginId = loginId
        self.password = password
        self.institution = institution
    }
}

// MARK: - Institution
public struct Institution : Codable  {
    let id: String
    public init(id: String) {
          self.id = id
    }
}



public class DictionaryEncoder {
    private let jsonEncoder = JSONEncoder()

    /// Encodes given Encodable value into an array or dictionary
    func encode<T>(_ value: T) throws -> Any where T: Encodable {
        let jsonData = try jsonEncoder.encode(value)
        return try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
    }
}

public class DictionaryDecoder {
    private let jsonDecoder = JSONDecoder()

    /// Decodes given Decodable type from given array or dictionary
    func decode<T>(_ type: T.Type, from json: Any) throws -> T where T: Decodable {
        let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
        return try jsonDecoder.decode(type, from: jsonData)
    }
}

//Example

//struct Computer: Codable {
//    var owner: String?
//    var cpuCores: Int
//    var ram: Double
//}
//
//let computer = Computer(owner: "5keeve", cpuCores: 8, ram: 4)
//let dictionary = try! DictionaryEncoder().encode(computer)
//let decodedComputer = try! DictionaryDecoder().decode(Computer.self, from: dictionary)
