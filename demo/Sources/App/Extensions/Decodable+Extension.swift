//
//  Decodable+Extension.swift
//  demo
//
//  Created by Quan Nguyen on 23/12/2020.
//

import Foundation

public extension Decodable {
    static func decode(with decoder: JSONDecoder = JSONDecoder(), from data: Data) throws -> Self {
        return try decoder.decode(Self.self, from: data)
    }
    
    static func decode(JSON json: [AnyHashable : Any]) throws -> Self {
        let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        return try decode(from: data)
    }
}

public extension Encodable {
    func encode(with encoder: JSONEncoder = JSONEncoder()) throws -> Data {
        return try encoder.encode(self)
    }
    func encodeJSON(with encoder: JSONEncoder = JSONEncoder(), options: JSONSerialization.ReadingOptions = .allowFragments) throws -> [AnyHashable : Any]? {
        let data = try encode()
        let json = try JSONSerialization.jsonObject(with: data, options: options) as? [AnyHashable : Any]
        return json
    }
}
