//
//  MovieIds.swift
//  Trakt.tv Swift MVC
//
//  Created by Juan Villa .
//


import Foundation
import SwiftyJSON


public class MovieIds: NSCoding {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    internal let kIdsTraktKey: String = "trakt"
    internal let kIdsImdbKey: String = "imdb"
    internal let kIdsSlugKey: String = "slug"
    internal let kIdsTmdbKey: String = "tmdb"
    
    
    // MARK: Properties
    public var trakt: Int?
    public var imdb: String?
    public var slug: String?
    public var tmdb: Int?
    
    
    // MARK: SwiftyJSON Initalizers
    convenience public init(object: AnyObject) {
        self.init(json: JSON(object))
    }
    
    public init(json: JSON) {
        trakt = json[kIdsTraktKey].int
        imdb = json[kIdsImdbKey].string
        slug = json[kIdsSlugKey].string
        tmdb = json[kIdsTmdbKey].int
        
    }
    

    public func dictionaryRepresentation() -> [String : AnyObject ] {
        
        var dictionary: [String : AnyObject ] = [ : ]
        if trakt != nil {
            dictionary.updateValue(trakt! as AnyObject, forKey: kIdsTraktKey)
        }
        if imdb != nil {
            dictionary.updateValue(imdb! as AnyObject, forKey: kIdsImdbKey)
        }
        if slug != nil {
            dictionary.updateValue(slug! as AnyObject, forKey: kIdsSlugKey)
        }
        if tmdb != nil {
            dictionary.updateValue(tmdb! as AnyObject, forKey: kIdsTmdbKey)
        }
        
        return dictionary
    }
    
    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
        self.trakt = aDecoder.decodeObject(forKey: kIdsTraktKey) as? Int
        self.imdb = aDecoder.decodeObject(forKey: kIdsImdbKey) as? String
        self.slug = aDecoder.decodeObject(forKey: kIdsSlugKey) as? String
        self.tmdb = aDecoder.decodeObject(forKey: kIdsTmdbKey) as? Int
        
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(trakt, forKey: kIdsTraktKey)
        aCoder.encode(imdb, forKey: kIdsImdbKey)
        aCoder.encode(slug, forKey: kIdsSlugKey)
        aCoder.encode(tmdb, forKey: kIdsTmdbKey)
        
    }
    

}
