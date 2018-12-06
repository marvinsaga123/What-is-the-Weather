//
//  ViewController.swift
//  What's the Weather
//
//  Created by Marvin Sagastume on 11/28/18.
//  Copyright © 2018 Innovaze. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var enterCityTextField: UITextField!
    @IBOutlet weak var weatherReportResult: UILabel!
    
    // unsplash.com for application background image
    // weather-forecast.com for weather data
    
    // to-do
    // - set up UI (background image, input fields, buttons) ---
    // - set up weather-forecast.com appropriate url ---
    // - get weather-forecast.com html for specified city ---
    // - look into html and see if there is a specific area we can target to get weather description ---
    // - parse html text and isolate weather description paragraph ---
    // - output weather description to UI ---
    // - handle error scenario #1: user inputs incorrect city and gets no response
    // - handle error scenario #2: user inputs a city with spaces
    // - perform code cleanup and final touches
    // - play around with application and attempt to break it (hit all edge cases)
    // - create local repository
    // - create remote repository and make appropriate changes on GitHub
    
    
    @IBAction func GetWeatherForCity(_ sender: Any) {
        
        // format the name of the city appropriately to account for spaces
        var city = enterCityTextField.text!
        city = city.replacingOccurrences(of: " ", with: "-")
        var weatherDescription: String = ""
        
        if let url = URL(string: "https://www.weather-forecast.com/locations/\(city)/forecasts/latest") {
            
            let request = NSMutableURLRequest(url: url)
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                data, response, error in
                
                if let error = error {
                    
                    print(error)
                    
                } else {
                    
                    if let unwrappedData = data {
                        
                        let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)! as String
                        
                        let firstIndexOfDescription = dataString.endIndex(of: "<span class=\"phrase\">")!.encodedOffset
                        
                        let dataStringDescriptionAtStart = NSString(string: dataString).substring(from: firstIndexOfDescription) as String
                        
                        let lastIndexOfDescription = dataStringDescriptionAtStart.index(of: "</span")!.encodedOffset
                        
                        weatherDescription = NSString(string: dataStringDescriptionAtStart).substring(to: lastIndexOfDescription) as String
                        
                        print(weatherDescription)
                        print(firstIndexOfDescription)
                        
                        weatherDescription = weatherDescription.replacingOccurrences(of: "&deg;", with: "°")
                        
                        DispatchQueue.main.async {
                            self.weatherReportResult.text = weatherDescription
                        }
                    }
                }
            }
            
            task.resume()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
}

extension StringProtocol where Index == String.Index {
    
    func index(of string: Self, options: String.CompareOptions = []) -> Index? {
        return range(of: string, options: options)?.lowerBound
    }
    
    func endIndex(of string: Self, options: String.CompareOptions = []) -> Index? {
        return range(of: string, options: options)?.upperBound
    }
    
}
