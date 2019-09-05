//
//  WeatherBitAPIService.swift
//  LocalWeather
//
//  Created by Ilya Rudometov on 02.09.2019.
//  Copyright © 2019 Ilya Rudometov. All rights reserved.
//

import Foundation
import Moya

final class WeatherBitAPIService: MoyaProvider<WeatherBitAPI>, IWeatherService {
    
    private let responseHandler: APIResponseHandler = APIResponseHandler()
    
    func getCurrentWeather(lat: Double,
                           long: Double,
                           completion: @escaping ResultBlock<ICurrentWeatherInfo>) {
        
        request(.current(lat: lat, long: long)) { [weak self] result in
            
            guard let this = self else { return }
            
            switch result {
            case .success(let response):
                this.responseHandler.handleJSONResponse(response, type: WBCurrentWeatherResponse.self) { result in
                    
                    switch result {
                    case .success(let apiResponse):
                        
                        // Simply get the first object from a received array...
                    
                        if let firstInfo = apiResponse.data.first {
                            completion(.success(firstInfo))
                        } else {
                            completion(.failure(NSError(domain: "temp", code: 0, userInfo: [NSLocalizedDescriptionKey: "The current weather info is not found for provided coordinates."])))
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getCurrentWeather(cityName: String,
                           completion: @escaping ResultBlock<ICurrentWeatherInfo>) {
        
        fatalError("The method \(#function) is not implemented.")
    }
}
