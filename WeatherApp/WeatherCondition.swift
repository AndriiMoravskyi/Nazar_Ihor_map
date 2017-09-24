//
//  WeatherCondition.swift
//  WeatherApp
//
//  Created by Oleksiy Bilyi on 2/19/17.
//  Copyright © 2017 Oleksiy Bilyi. All rights reserved.
//

import UIKit

class WeatherCondition {
    
    // MARK: - Parameters
    var sunrise : String = ""
    var sunset : String = ""
    var temperature : Double?
    var pressure  : String = ""
    var humidity: Int?
    var windSpeed : Double?
    var windName : String = ""
    var windDirection : String = ""
    var clouds : String = ""
    var precipitation : String = ""
    var weatherIcon : UIImage?
    /// completion for weather image downloading
    var iconDownloadCompletion : ((UIImage?) -> Void)?
    
}
