//
//  APIClient.swift
//  Reactor - Networking
//
//  Created by Reiker Seiffe on 2/5/18.
//  Copyright © 2018 ReikerSeiffe.com. All rights reserved.
//

import Foundation


protocol APIClient {
    var session: URLSession { get }
    func fetch<T: Decodable>(with request: URLRequest, decode: @escaping (Decodable) -> T?, completion: @escaping (Result<T, APIError>) -> Void)
}


extension APIClient {
    typealias JSONTaskCompletionHandler = (Decodable?, APIError?) -> Void
    
    typealias TaskCompletionHandler = (APIResponse?) -> Void
    
    //decoding for JSON
    private func decodingTask<T: Decodable>(with request: URLRequest, decodingType: T.Type, completionHandler completion: @escaping JSONTaskCompletionHandler) -> URLSessionDataTask {
        
        let task = session.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, .requestFailed)
                return
            }
            if httpResponse.statusCode == 200 {
                if let data = data {
                    do {
                        //let responseString = String(data: data, encoding: .utf8)
                        let genericModel = try JSONDecoder().decode(decodingType, from: data)
                        completion(genericModel, nil)
                    } catch {
                        print(error)
                        completion(nil, .jsonConversionFailure)
                    }
                } else {
                    completion(nil, .invalidData)
                }
            }else{
                print("refresh here 1")
                completion(nil, .responseUnsuccessful)
            }
        }
        return task
    }
    
    //decoding without JSON
    private func decodingTask(with request: URLRequest, completionHandler completion: @escaping TaskCompletionHandler) -> URLSessionDataTask {
        
        let task = session.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(APIError.requestFailed)
                return
            }
            if httpResponse.statusCode == 200 {
                completion(APISuccess.registeredUser)
            }else if httpResponse.statusCode == 409 { //this is if the username is taken
                completion(APIError.usernameUnavailable)
            }else if httpResponse.statusCode == 201 { //this is if the user is succesfully added to the group
                completion(APISuccess.addedUserToGroup)
            }else{
                print(httpResponse.statusCode)
                print("refresh here 2")
                completion(APIError.responseUnsuccessful)
                let client = ReactorOauthClient()
                let preferences = UserDefaults.standard
                client.getOauthRefresh(from: .oauth){ result in
                    switch result {
                    case .success(let reactorAPIResult):
                        guard let oauthResults = reactorAPIResult else {
                            print("There was an error in oauthValidationCheck request portion")
                            return
                        }
                        
                        //setting access_token
                        preferences.set(oauthResults.access_token, forKey: "access_token")
                        
                        //setting expires_at
                        let currentDateTime = Date()
                        let expires_in = TimeInterval(oauthResults.expires_in!)
                        let expires_at = currentDateTime.addingTimeInterval(expires_in)
                        preferences.set(expires_at, forKey: "expires_at")
                        
                        //setting refresh_token
                        preferences.set(oauthResults.refresh_token, forKey: "refresh_token")
                        
                        print("REFRESHED THE TOKEN BECUASE OF A BAD RESPONSE")
                        
                    case .failure(let error):
                        print("the error \(error)")
                        return
                    }
                }
            }
        }
        return task
    }
    
    
    //Fetch for JSON
    func fetch<T: Decodable>(with request: URLRequest, decode: @escaping (Decodable) -> T?, completion: @escaping (Result<T, APIError>) -> Void) {
        let task = decodingTask(with: request, decodingType: T.self) { (json , error) in
            //MARK: change to main queue
            DispatchQueue.main.async {
                guard let json = json else {
                    if let error = error {
                        completion(Result.failure(error))
                    } else {
                        completion(Result.failure(.invalidData))
                    }
                    return
                }
                if let value = decode(json) {
                    completion(.success(value))
                } else {
                    completion(.failure(.jsonParsingFailure))
                }
            }
        }
        task.resume()
    }
    
    //Fetch without JSON
    func fetch(with request: URLRequest, completion: @escaping (Result<APISuccess, APIError>) -> Void) {
        let task = decodingTask(with: request) { (response) in
            //MARK: change to main queue
            DispatchQueue.main.async {
                if let response = response as? APISuccess{
                    completion(Result.success(response))
                }
                if let response = response as? APIError{
                    completion(Result.failure(response))
                }
            }
        }
        task.resume()
    }
}
