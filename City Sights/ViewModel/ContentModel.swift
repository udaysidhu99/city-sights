//
//  ContentModel.swift
//  City Sights
//
//  Created by Uday Sidhu on 17/02/23.
//

import Foundation
import CoreLocation
class ContentModel: NSObject, CLLocationManagerDelegate,  ObservableObject{
    var locationManager = CLLocationManager()
    override init(){
        super.init()
        // Set content model as the delgate for location manager
        locationManager.delegate = self
        //Request permision from the user
        locationManager.requestWhenInUseAuthorization()
        
        
    }
    // MARK: Location Manager delegate methods
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse{
            // we have permission
            //Geo locate the user, if permission is granted
            locationManager.startUpdatingLocation()
        }
        else if locationManager.authorizationStatus == .denied{
            //we dont have permission
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // gives location of user
        let userLocation = locations.first
        if userLocation != nil{
            //stop requesting the location
            locationManager.stopUpdatingLocation()
            // send coordinates to Yelp API
            getBusinesses(category: "restauraunts", location: userLocation!)
            
            
        }
        // TODO: if we have user coordinates, sent to Yelp API
        
        
    }
    
     //MARK: Yelp API Methods
    func getBusinesses(category:String, location:CLLocation){
        //Create URL
        /*let urlString = "https://api.yelp.com/v3/businesses/search?latitude=\(location.coordinate.latitude)&longitude=\(location.coordinate.longitude)&categories=\(category)&limit=6"
         */
        var urlComponent = URLComponents(string: "https://api.yelp.com/v3/businesses/search")
        urlComponent?.queryItems = [
            URLQueryItem(name: "latitude", value: String(location.coordinate.latitude)),
            URLQueryItem(name: "longitude", value: String(location.coordinate.longitude)),
            URLQueryItem(name: "categories", value: category),
            URLQueryItem(name: "limit", value: "6")
        ]
        let url = urlComponent?.url
        if let url = url{
            //Create URL request
            var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10.0)
            
            request.httpMethod = "GET"
            request.addValue("Bearer laFjF54DlSNwk3iJvqnkXpZK9S7PSDDsmw19fIC1Nm7iBmhgOusv8ppO3-24YLlb5eCx8BaAiiaSFTr9ggO1HcsR0ba6bLxnQ3TJnCH8LU7w0hWjG9IV3NFY9pvzY3Yx", forHTTPHeaderField: "Authorization")
            //Get URL session
            let session = URLSession.shared
            
            //Create Data Task
            let dataTask = session.dataTask(with: request) { data, response, error in
                    //check if error
                if error == nil {
                    print(response)
                }
        }
    
            dataTask.resume()
                
        }
        
        //Start Data Task
        
    }
}
