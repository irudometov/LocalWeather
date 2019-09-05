//
//  APIResponseHandler.swift
//  LocalWeather
//
//  Created by Ilya Rudometov on 02.09.2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import Foundation
import Moya

typealias ResultBlock<T> = (Result<T, Error>) -> Void

struct APIResponseHandler {
    
    func handleJSONResponse<T: Decodable>(_ response: Moya.Response,
                                          type: T.Type = T.self,
                                          completion: @escaping ResultBlock<T>) {
        
        do {
            let _ = try response.filterSuccessfulStatusCodes()
            let model = try JSONDecoder().decode(T.self, from: response.data)
            completion(Result.success(model))
        }
        catch {
            completion(Result.failure(error))
        }
    }
}
