//
//  WeatherService.swift
//  WeatherDemo
//
//  Created by Pablo Mateo Fernández on 02/02/2017.
//  Copyright © 2017 355 Berry Street S.L. All rights reserved.
//

import Foundation

class WeatherService {
    
    let openWeatherBaseAPI = "http://api.openweathermap.org/data/2.5/weather?appid=5dbb5c068718ea452732e5681ceaa0c7&units=metric&q="
    let urlSession = URLSession.shared
    
    
    func getCurrentWeather(location:String, completion: @escaping (WeatherData) -> ()) {
        
        let openWeatherAPI = openWeatherBaseAPI + location.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)! //Añade todos los caracteresnecesarios que admite untipo URL, porque las URLs no admiten espacios

        print(openWeatherAPI)
        
        guard let queryURL = URL(string: openWeatherAPI) else {
            return
        }
        let request = URLRequest(url: queryURL)
        var weatherData = WeatherData()
        
        let task = urlSession.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            
            guard let data = data else {
                if let error = error {
                    print(error)
                }
                
                return
            }
            
            // Retrieve JSON data
            do {
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
                
                // Parse JSON data
                let jsonWeather = jsonResult?["weather"] as! [AnyObject]
                
                for jsonCurrentWeather in jsonWeather {
                    weatherData.weather = jsonCurrentWeather["description"] as! String
                }
                
                let jsonMain = jsonResult?["main"] as! Dictionary<String, AnyObject>
                weatherData.temperature = jsonMain["temp"] as! Int
                
                completion(weatherData)
                
            } catch {
                print(error)
            }
        })
        
        task.resume()
    }
    
}

