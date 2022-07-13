//
//  BaseRequest.swift
//  demo
//
//  Created by Quan Nguyen on 13/07/2022.
//

import Alamofire

class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}

class BaseRequest<R> {
    let request: URLRequest
    
    init(request: URLRequest) {
        self.request = request
    }
}

class BaseServiceFactory {
    func urlRequest(path: String, method: HTTPMethod) -> URLRequest {
        let url = URL(string: BaseAPIRouter.baseURL)!
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        return urlRequest
    }
}

class BaseManagerAPI {
    let sessionManager: SessionManager
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 300
        sessionManager = SessionManager(configuration: configuration)
    }
    
    // MARK: - Public
    
    func preparedRequest<R: Codable>(request: BaseRequest<R>, input: [String: Any]? = nil) -> URLRequest {
        var executableRequest: URLRequest
        if let input = input, let httpMethod = HTTPMethod(rawValue: request.request.httpMethod ?? "") {
            do {
                switch httpMethod {
                case .get:
                    let queryEncoding = URLEncoding(destination: .queryString, arrayEncoding: .noBrackets)
                    executableRequest = try queryEncoding.encode(request.request, with: input)
                case .connect, .delete, .head, .options, .patch, .post, .put, .trace:
                    executableRequest = try Alamofire.JSONEncoding.default.encode(request.request, with: input)
                }
            } catch {
                executableRequest = request.request
            }
            
        } else {
            executableRequest = request.request
        }
        return executableRequest
    }
    
    @discardableResult
    func run<R: Codable>(request: BaseRequest<R>,
                         input: [String: Any]? = nil,
                         completionHandler: @escaping (APIResponseResult<R>) -> Void)
        -> DataRequest {
        let executableRequest = preparedRequest(request: request, input: input)
        
            let request = sessionManager.request(executableRequest)
                .responseJSON { [weak self] response in
                    print("Debug API: \(executableRequest)\n\(response)" )
                    var apiResult: APIResponseResult<R>
                    guard let data = response.data else {
                        apiResult = .failure(APIErrorModel.defaultError)
                        return completionHandler(apiResult)
                    }
                    
                    if let error = self?.parsedError(data: data) {
                        apiResult = .failure(error)
                    } else {
                        do {
                            if let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                               let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
                                let decoder = JSONDecoder()
                                let output = try decoder.decode(R.self, from: jsonData)
                                apiResult = .success(output)
                            } else if let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: Any]] {
                                let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
                                let decoder = JSONDecoder()
                                let output = try decoder.decode(R.self, from: jsonData)
                                apiResult = .success(output)
                            } else {
                                apiResult = .failure(APIErrorModel.defaultError)
                            }
                        } catch {
                            print("Debug Error:" ,error)
                            apiResult = .failure(APIErrorModel.init(errorString: error.localizedDescription))
                        }
                    }
                    completionHandler(apiResult)
                }
            return request
    }
    
    func upload<R: Codable>(data: Data?,
                            withName: String? = "image",
                            filename: String? = "\(Date().timeIntervalSince1970).jpeg",
                            mimeType: String? = "image/jpeg",
                            request: BaseRequest<R>,
                            input: [String: Any]? = nil,
                            completionHandler: @escaping (APIResponseResult<R>) -> Void,
                            progressHandler: @escaping (Double) -> Void) -> Void {
        let executableRequest = preparedRequest(request: request, input: input)
        print("Debug UPLOAD API Request: ", executableRequest)
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            if let data = data, let withName = withName, let filename = filename, let mimeType = mimeType {
                multipartFormData.append(data, withName: withName, fileName: filename, mimeType: mimeType)
            }
            
            let params: [String: Any] = input ?? [:]
            for (key, value) in params {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
            
        }, with: executableRequest) { (result) in
            switch result {
            case .success(let uploadRequest, _, _):
                uploadRequest.uploadProgress { (progress) in
                    if progress.isFinished {
                        progressHandler(1.0)
                    } else {
                        progressHandler(progress.fractionCompleted)
                    }
                }
                
                uploadRequest.responseJSON { [weak self] (response) in
                    print("Debug UPLOAD API Response: ", response)
                    var apiResult: APIResponseResult<R>
                    guard let data = response.data else {
                        apiResult = .failure(APIErrorModel.defaultError)
                        return completionHandler(apiResult)
                    }
                    
                    if let error = self?.parsedError(data: data) {
                        apiResult = .failure(error)
                    } else {
                        do {
                            let decoder = JSONDecoder()
                            let obj = try decoder.decode(R.self, from: response.data!)
                            apiResult = .success(obj)
                        } catch {
                            apiResult = .failure(APIErrorModel.defaultError)
                        }
                    }
                   
                    completionHandler(apiResult)
                }
            case .failure(let error):
                var apiResult: APIResponseResult<R>
                apiResult = .failure(APIErrorModel(error: error))
                completionHandler(apiResult)
            }
        }
    }
    
    private func parsedError(data: Data?) -> APIErrorModel? {
        guard let data = data else {
            return nil
        }
        do {
            if let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                var errorMessage: String?
                if let message = jsonObject["Error"] as? String {
                    errorMessage = message
                }
                if let error = errorMessage {
                    return APIErrorModel(errorString: error)
                }
            }
            return nil
        } catch {
            return nil
        }
    }
    
    
}

enum APIResponseResult<Value> {
    case success(Value)
    case failure(APIErrorModel)
}

enum APIErrorCode: String {
    case unknow = "UNKNOW"
    case notfound = "NOT_FOUND"
    case notAuthen = "E_UNAUTHORIZED"
}

class PublicManagerAPI: BaseManagerAPI {
    static let shared = PublicManagerAPI()
    
    private override init() {
        super.init()
    }
}

class PrivateManagerAPI: BaseManagerAPI {
    static let shared = PrivateManagerAPI()
    private override init() {
        super.init()
        let headerAdapter = PPRequestAdapter()
        sessionManager.adapter = headerAdapter
    }
}

class PPRequestAdapter: RequestAdapter {
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return urlRequest
    }
}
