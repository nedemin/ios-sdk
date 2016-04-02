//
//  ToneAnalyzerError.swift
//  WatsonDeveloperCloud
//
//  Created by Pedro Rey on 02/04/16.
//  Copyright © 2016 Glenn R. Fisher. All rights reserved.
//

import Foundation
import ObjectMapper

extension ToneAnalyzer {
    
    internal struct ToneAnalyzerError: WatsonError {
        var errorCode: Int! = 0
        var errorMessage: String! = "noop"
        
        var nsError: NSError {
            let domain = Constants.errorDomain
            let userInfo = [NSLocalizedDescriptionKey: errorMessage]
            return NSError(domain: domain, code: errorCode, userInfo: userInfo)
        }
        
        init() {}
        
        init?(_ map: Map) {}
        
        mutating func mapping(map: Map) {
            errorCode    <- map["error_code"]
            errorMessage <- map["error_message"]
        }
    }
}