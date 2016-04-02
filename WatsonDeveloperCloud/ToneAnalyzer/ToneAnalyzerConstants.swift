//
//  ToneAnalyzerConstants.swift
//  WatsonDeveloperCloud
//
//  Created by Pedro Rey on 02/04/16.
//  Copyright © 2016 Glenn R. Fisher. All rights reserved.
//

import Foundation

extension ToneAnalyzer {
    
    internal struct Constants {
        
        static let serviceURL = "https://gateway.watsonplatform.net/tone-analyzer-beta/api"
        static let tokenURL = "https://gateway.watsonplatform.net/authorization/api/v1/token"
        static let errorDomain = "com.watsonplatform.toneanalyzer"
        
        static let tone = "/v3/tone"
    }
}