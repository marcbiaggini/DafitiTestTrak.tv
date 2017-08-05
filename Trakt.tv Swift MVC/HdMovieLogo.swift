//
//  hdmovielogo.swift
//  Trakt.tv Swift MVC
//
//  Created by Juan Villa on 03/08/17.
//

import Foundation
import SwiftyJSON

public class HdMovieLogo: NSCoding {
    
    public var url: String?
    internal let kURLKey: String = "url"

    required public init(coder aDecoder: NSCoder) {
        self.url = aDecoder.decodeObject(forKey:kURLKey) as? String
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(url, forKey: kURLKey)
    }
    
    convenience public init(object: AnyObject) {
        self.init(json: JSON(object))
    }
    

    public init(json: JSON) {
        url = json[kURLKey].string
    
    }
  
    public func dictionaryRepresentation() -> [String : AnyObject ] {
        
        var dictionary: [String : AnyObject ] = [ : ]
    
        if url != nil {
            dictionary.updateValue(url! as AnyObject, forKey: kURLKey)
        }
        
        return dictionary
    }
}
