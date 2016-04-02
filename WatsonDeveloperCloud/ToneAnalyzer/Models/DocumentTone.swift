//
//  Tone.swift
//  WatsonDeveloperCloud
//
//  Created by Pedro Rey on 02/04/16.
//  Copyright © 2016 Glenn R. Fisher. All rights reserved.
//

import Foundation
import ObjectMapper

extension ToneAnalyzer {
    
    public struct DocumentTone: Mappable {
        
        //
        public var toneCategories: [ToneCategory]?
        
        /// Used internally to initialize `Tone` from JSON.
        public init?(_ map: Map) {}
        
        /// Used internally to serialize and deserialize JSON.
        public mutating func mapping(map: Map) {
            toneCategories      <- map["tone_categories"]
        }
    }
    
    /// An identifiable language
    public struct ToneCategory: Mappable {
        
        // 
        public var tones: [Tone]?
        
        // The unique iD of the category
        public var categoryId:String?
        
        // The tone analysis categories.  Possible tone categories are emotioin, writing and social.
        public var categoryName:String?
        
        /// Used internally to initialize `Tone` from JSON.
        public init?(_ map: Map) {}
        
        /// Used internally to serialize and deserialize JSON.
        public mutating func mapping(map: Map) {
            tones           <- map["tones"]
            categoryId      <- map["category_id"]
            categoryName    <- map["category_name"]
        }
    }
    
    public struct Tone: Mappable {
        // The score of the tone
        public var score:Float?
        
        // The unique ID of the tone.
        public var toneId:String?
        
        // The name of the tone
        public var toneName:String?
        
        /// Used internally to initialize `Tone` from JSON.
        public init?(_ map: Map) {}
        
        /// Used internally to serialize and deserialize JSON.
        public mutating func mapping(map: Map) {
            score           <- map["score"]
            toneId          <- map["tone_id"]
            toneName        <- map["tone_name"]
        }
    }
}