
//
//  ErrorMessage.swift
//  demo
//
//  Created by Quan Nguyen on 13/07/2022.
//

import Foundation

enum APIError: Error {
    case unknown
    case generalError(String)
    case none
    
    func getMessage() -> String? {
        switch self {
        case let .generalError(msg):
            return msg
        default:
            return nil
        }
    }
}

enum ValidateError: Error {
    case unknown
    case none
}

class APIErrorModel: Codable {
    var message: String = ""
    
    init() {}
    
    convenience init(errorString: String) {
        self.init()
        self.message = errorString
    }
    
    convenience init(error: Error) {
        self.init()
        self.message = error.localizedDescription
    }
    
    var error: Error {
        return APIError.generalError(message)
    }
    
    static var defaultError: APIErrorModel {
        return APIErrorModel(errorString: "Something went wrong")
    }
}


struct ErrorMessage: Error {
    
    // MARK: - Properties
    public let title: String
    public let message: String
    public let code: Int?
    
    // MARK: - Methods
    init(title: String, message: String, code: Int? = nil) {
        self.title = title
        self.message = message
        self.code = code
    }
    
    init(error: APIErrorModel) {
        self.title = ""
        self.message = error.message
        self.code = nil
    }
    
    static var EmptyError: ErrorMessage {
        return ErrorMessage(title: "", message: "")
    }
    
    static var UnknownError: ErrorMessage {
        return ErrorMessage(error: APIErrorModel.defaultError)
    }
}
