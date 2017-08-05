//
//  Movie.swift
//  Trakt.tv Swift MVC
//
//  Created by Juan Villa .
//


import Foundation
import SwiftyJSON

public class Movie: NSCoding {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    internal let kMovieTitleKey: String = "title"
    internal let kMovieRuntimeKey: String = "runtime"
    internal let kMovieOverviewKey: String = "overview"
    internal let kMovieHomepageKey: String = "homepage"
    internal let kMovieYearKey: String = "year"
    internal let kMovieCertificationKey: String = "certification"
    internal let kMovieTrailerKey: String = "trailer"
    internal let kMovieGenresKey: String = "genres"
    internal let kMovieRatingKey: String = "rating"
    internal let kMovieAvailableTranslationsKey: String = "available_translations"
    internal let kMovieReleasedKey: String = "released"
    internal let kMovieTaglineKey: String = "tagline"
    internal let kMovieUpdatedAtKey: String = "updated_at"
    internal let kMovieVotesKey: String = "votes"
    internal let kMovieLanguageKey: String = "language"
    internal let kMovieIdsKey: String = "ids"
    
    
    // MARK: Properties
    public var title: String?
    public var runtime: Int?
    public var overview: String?
    public var homepage: String?
    public var year: Int?
    public var certification: String?
    public var trailer: String?
    public var genres: [String]?
    public var rating: Float?
    public var availableTranslations: [String]?
    public var released: String?
    public var tagline: String?
    public var updatedAt: String?
    public var votes: Int?
    public var language: String?
    public var ids: MovieIds?
    public var imageURL: String?
    
    
    // MARK: SwiftyJSON Initalizers
    convenience public init(object: AnyObject) {
        self.init(json: JSON(object))
    }
    
    public init(json: JSON) {
        title = json[kMovieTitleKey].string
        runtime = json[kMovieRuntimeKey].int
        overview = json[kMovieOverviewKey].string
        homepage = json[kMovieHomepageKey].string
        year = json[kMovieYearKey].int
        certification = json[kMovieCertificationKey].string
        trailer = json[kMovieTrailerKey].string
        genres = []
        if let items = json[kMovieGenresKey].array {
            for item in items {
                if let tempValue = item.string {
                    genres?.append(tempValue)
                }
            }
        } else {
            genres = nil
        }
        rating = json[kMovieRatingKey].float
        availableTranslations = []
        if let items = json[kMovieAvailableTranslationsKey].array {
            for item in items {
                if let tempValue = item.string {
                    availableTranslations?.append(tempValue)
                }
            }
        } else {
            availableTranslations = nil
        }
        released = json[kMovieReleasedKey].string
        tagline = json[kMovieTaglineKey].string
        updatedAt = json[kMovieUpdatedAtKey].string
        votes = json[kMovieVotesKey].int
        language = json[kMovieLanguageKey].string
        ids = MovieIds(json: json[kMovieIdsKey])
        
    }
    
        
   
    public func dictionaryRepresentation() -> [String : AnyObject ] {
        
        var dictionary: [String : AnyObject ] = [ : ]
        if title != nil {
            dictionary.updateValue(title! as AnyObject, forKey: kMovieTitleKey)
        }
        if runtime != nil {
            dictionary.updateValue(runtime! as AnyObject, forKey: kMovieRuntimeKey)
        }
        if overview != nil {
            dictionary.updateValue(overview! as AnyObject, forKey: kMovieOverviewKey)
        }
        if homepage != nil {
            dictionary.updateValue(homepage! as AnyObject, forKey: kMovieHomepageKey)
        }
        if year != nil {
            dictionary.updateValue(year! as AnyObject, forKey: kMovieYearKey)
        }
        if certification != nil {
            dictionary.updateValue(certification! as AnyObject, forKey: kMovieCertificationKey)
        }
        if trailer != nil {
            dictionary.updateValue(trailer! as AnyObject, forKey: kMovieTrailerKey)
        }
        if (genres?.count)! > 0 {
            dictionary.updateValue(genres! as AnyObject, forKey: kMovieGenresKey)
        }
        if rating != nil {
            dictionary.updateValue(rating! as AnyObject, forKey: kMovieRatingKey)
        }
        if (availableTranslations?.count)! > 0 {
            dictionary.updateValue(availableTranslations! as AnyObject, forKey: kMovieAvailableTranslationsKey)
        }
        if released != nil {
            dictionary.updateValue(released! as AnyObject, forKey: kMovieReleasedKey)
        }
        if tagline != nil {
            dictionary.updateValue(tagline! as AnyObject, forKey: kMovieTaglineKey)
        }
        if updatedAt != nil {
            dictionary.updateValue(updatedAt! as AnyObject, forKey: kMovieUpdatedAtKey)
        }
        if votes != nil {
            dictionary.updateValue(votes! as AnyObject, forKey: kMovieVotesKey)
        }
        if language != nil {
            dictionary.updateValue(language! as AnyObject, forKey: kMovieLanguageKey)
        }
        if ids != nil {
            dictionary.updateValue(ids!.dictionaryRepresentation() as AnyObject, forKey: kMovieIdsKey)
        }
        
        return dictionary
    }
    
    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
        self.title = aDecoder.decodeObject(forKey: kMovieTitleKey) as? String
        self.runtime = aDecoder.decodeObject(forKey:kMovieRuntimeKey) as? Int
        self.overview = aDecoder.decodeObject(forKey:kMovieOverviewKey) as? String
        self.homepage = aDecoder.decodeObject(forKey:kMovieHomepageKey) as? String
        self.year = aDecoder.decodeObject(forKey:kMovieYearKey) as? Int
        self.certification = aDecoder.decodeObject(forKey:kMovieCertificationKey) as? String
        self.trailer = aDecoder.decodeObject(forKey:kMovieTrailerKey) as? String
        self.genres = aDecoder.decodeObject(forKey:kMovieGenresKey) as? [String]
        self.rating = aDecoder.decodeObject(forKey:kMovieRatingKey) as? Float
        self.availableTranslations = aDecoder.decodeObject(forKey:kMovieAvailableTranslationsKey) as? [String]
        self.released = aDecoder.decodeObject(forKey:kMovieReleasedKey) as? String
        self.tagline = aDecoder.decodeObject(forKey:kMovieTaglineKey) as? String
        self.updatedAt = aDecoder.decodeObject(forKey:kMovieUpdatedAtKey) as? String
        self.votes = aDecoder.decodeObject(forKey:kMovieVotesKey) as? Int
        self.language = aDecoder.decodeObject(forKey:kMovieLanguageKey) as? String
        self.ids = aDecoder.decodeObject(forKey:kMovieIdsKey) as? MovieIds
        
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: kMovieTitleKey)
        aCoder.encode(runtime, forKey: kMovieRuntimeKey)
        aCoder.encode(overview, forKey: kMovieOverviewKey)
        aCoder.encode(homepage, forKey: kMovieHomepageKey)
        aCoder.encode(year, forKey: kMovieYearKey)
        aCoder.encode(certification, forKey: kMovieCertificationKey)
        aCoder.encode(trailer, forKey: kMovieTrailerKey)
        aCoder.encode(genres, forKey: kMovieGenresKey)
        aCoder.encode(rating, forKey: kMovieRatingKey)
        aCoder.encode(availableTranslations, forKey: kMovieAvailableTranslationsKey)
        aCoder.encode(released, forKey: kMovieReleasedKey)
        aCoder.encode(tagline, forKey: kMovieTaglineKey)
        aCoder.encode(updatedAt, forKey: kMovieUpdatedAtKey)
        aCoder.encode(votes, forKey: kMovieVotesKey)
        aCoder.encode(language, forKey: kMovieLanguageKey)
        aCoder.encode(ids, forKey: kMovieIdsKey)
        
    }
    
    public func setImage(url: String){
            self.imageURL = url
    }
    
}
