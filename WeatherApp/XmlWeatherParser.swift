//
//  XmlWeatherParser.swift
//  WeatherApp
//
//  Created by Oleksiy Bilyi on 2/18/17.
//  Copyright © 2017 Oleksiy Bilyi. All rights reserved.
//

import UIKit

class XmlWeatherParser: NSObject, WeatherParserInterface {
    
    // MARK: - Parameters
    fileprivate var conditions = WeatherCondition()
    
    // MARK: - WeatherParserInterface
    func getWeatherConditionsFor(data : Data) -> WeatherCondition {
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
        return conditions
    }
    
    // MARK: - Extra functions
    /**
     Asynchronously downloads weather condition image
      - Parameter urlTemplate: string url for downloading weather image
     */
    fileprivate func  downloadConditionImage(urlTemplate : String) {
        guard let urlAllowed = urlTemplate.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
        let url = URL(string: urlAllowed) else {
            print("Not valid URL")
            return
        }
        
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    if let downloadCompletion = self.conditions.iconDownloadCompletion {
                        downloadCompletion(UIImage(data: data!))
                    }
                    self.conditions.weatherIcon = UIImage(data: data!)
                }
            }
        })
        dataTask.resume()
    }
    
}

// MARK: - XMLParserDelegate
extension XmlWeatherParser: XMLParserDelegate {
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        switch elementName {
        case "temperature":
            if let temperature = attributeDict["value"], let temperatureDouble = Double(temperature)  {
                conditions.temperature = temperatureDouble
            }
        case "weather":
            if let icon = attributeDict["icon"] {
                let iconUrl = "http://openweathermap.org/img/w/\(icon).png"
                downloadConditionImage(urlTemplate: iconUrl)
            }
        case "clouds":
            if let clouds = attributeDict["name"] {
                conditions.clouds = clouds
            }
        case "sun":
            if let rise = attributeDict["rise"] {
                conditions.sunrise = rise[rise.index(rise.startIndex, offsetBy: 11)...rise.index(rise.endIndex, offsetBy: -4)]
            }
            if let set = attributeDict["set"] {
                conditions.sunset = set[set.index(set.startIndex, offsetBy: 11)...set.index(set.endIndex, offsetBy: -4)]

            }
        case "humidity":
            if let humidity = attributeDict["value"] {
                conditions.humidity = Int(humidity)
            }
        case "pressure":
            if let pressure = attributeDict["value"],
               let units = attributeDict["unit"] {
                conditions.pressure = String(format: "%@ %@", pressure, units)
            }
        case "speed":
            if let speed = attributeDict["value"],
               let name = attributeDict["name"] {
                conditions.windSpeed = Double(speed)
                conditions.windName = name
            }
        case "direction":
            if let direction = attributeDict["name"] {
                conditions.windDirection = direction
            }
        case "clouds":
            if let cloudsName = attributeDict["name"] {
                conditions.clouds = cloudsName
            }
        case "precipitation":
            if let precipitation = attributeDict["mode"] {
                conditions.precipitation = precipitation
            }
        default:
            break
        }
    }
    
}
