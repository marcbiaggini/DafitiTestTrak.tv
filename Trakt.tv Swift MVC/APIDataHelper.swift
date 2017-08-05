//
//  APIDataManager.swift
//  Trakt.tv Swift MVC
//
//  Created by Juan Villa .
//

import UIKit
import Alamofire
import SwiftyJSON

class APIDataManager: NSObject {
    
    // MARK - SERVER CONNECTIONS
    public func downloadMovies(pageNumber : Int, arrayResults : NSMutableArray){
        
        let headers: HTTPHeaders = [
            "Content-Type" : "application/json",
            "trakt-api-version" : kAPI_VERSION,
            "trakt-api-key" : kAPI_CLIENT_ID
        ]
        
        let urlRequest = kAPI_URL + kAPI_GET_MOVIES + "&page=" + String(pageNumber)
        Alamofire.request(urlRequest, headers: headers).responseJSON { response in
            if let jsonRawResponse = response.result.value{
                
                let jsonResult = JSON(jsonRawResponse)
                self.getPoster(result: jsonResult, arrayResults: arrayResults)
                
            }else{
                
                self.dismissOperation();
                
            }
        }
    }
    
    public func searchMovies(pageNumber : Int, arrayResults : NSMutableArray, searchTerms : String){
        
        let headers: HTTPHeaders = [
            "Content-Type" : "application/json",
            "trakt-api-version" : kAPI_VERSION,
            "trakt-api-key" : kAPI_CLIENT_ID ]
        
        let urlRequest = kAPI_URL + kAPI_GET_SEARCH_MOVIES + searchTerms.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)! + "&page=" + String(pageNumber)
        
        Alamofire.request(urlRequest, headers: headers).responseJSON { response in
            if let jsonRawResponse = response.result.value{
                
                let jsonResult = JSON(jsonRawResponse)
                
                if jsonResult.count > 0 {
                    
                    self.getPoster(result: jsonResult, arrayResults: arrayResults)
                    
                } else {
                    self.dismissOperation()
                }
                
            } else {
                
                self.dismissOperation()
                
            }
        }
    }
    
    public func showResults() {
        
        let pref = UserDefaults.standard
        pref.set(false, forKey: "isPageRefreshing")
        pref.synchronize()
        
        let notificationName = Notification.Name("needUpdateTable")
        
        NotificationCenter.default.post(name: notificationName, object: nil)
        
    }
    
    public func dismissOperation(){
        
        let pref = UserDefaults.standard
        pref.set(false, forKey: "isInSearchPhase")
        pref.set(false, forKey: "isPageRefreshing")
        pref.synchronize()
        
        let notificationName = Notification.Name("needUpdateTable")
        
        NotificationCenter.default.post(name: notificationName, object: nil)
        
    }
    
}

extension APIDataManager {
    
    public func getPoster(result : JSON, arrayResults : NSMutableArray){
        
        for i in 0  ..< result.count  {
            let movie = Movie(json: result[i]["movie"])
            self.getImage(movie: movie, arrayResults: arrayResults, currentItemIndex: i, totalItems: result.count)
        }
        

    }
    
    public func getImage(movie : Movie, arrayResults : NSMutableArray, currentItemIndex : Int, totalItems : Int) {
        
        if let imdb = movie.ids?.imdb {
        
            let urlRequest = (KAPI_FAN_ART_TV_GET_IMAGES + imdb+"?api_key="+KAPI_FAN_ART_TV_ID)
        
            Alamofire.request(urlRequest).responseJSON { response in
                
                if let jsonRawResponse = response.result.value as? [String: Any] {

                    let jsonResult = JSON(jsonRawResponse)
                    let moviePoster = MoviePoster(json: jsonResult)
                    
                    let urlMoviePoster = moviePoster.hdmovielogo.first?.url
                    if urlMoviePoster != nil {
                        movie.setImage(url: (urlMoviePoster)!)
                    }
                    
                    arrayResults.add(anyObject: movie)
                
                    if currentItemIndex == (totalItems - 1) {
                        self.showResults()
                    }
                
                } else {
                
                    self.dismissOperation()
                
                }
            }
        } else {
            arrayResults.add(anyObject: movie)
            
            if currentItemIndex == (totalItems - 1) {
                self.showResults()
            }
        }
    }

}
