//
//  MoviePoster.swift
//  Trakt.tv Swift MVC
//
//  Created by Juan Villa on 02/08/17.
//

import Foundation
import SwiftyJSON

public class MoviePoster: NSCoding {
    
    public var hdmovielogo: [HdMovieLogo] = []
    internal let kMovieImageKey: String = "movieposter"

    
    convenience public init(object: AnyObject) {
        self.init(json: JSON(object))
    }
    
    public init(json: JSON) {
        
        guard let imgJson = json[kMovieImageKey].array?.first else {
            return
        }
        let movieLogo = HdMovieLogo(json: imgJson)
        
        hdmovielogo.append(movieLogo)
    }
    

    
    required public init(coder aDecoder: NSCoder) {
      self.hdmovielogo = aDecoder.decodeObject(forKey:kMovieImageKey) as! [HdMovieLogo]
        
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(hdmovielogo, forKey: kMovieImageKey)

    }
}
