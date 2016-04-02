//
//  ToneAnalyzer.swift
//  WatsonDeveloperCloud
//
//  Created by Pedro Rey on 02/04/16.
//  Copyright © 2016 Glenn R. Fisher. All rights reserved.
//

import Foundation
import ObjectMapper



public class ToneAnalyzer: WatsonService {
    
    // The shared WatsonGateway singleton.
    let gateway = WatsonGateway.sharedInstance
    
    // The authentication strategy to obtain authorization tokens.
    let authStrategy: AuthenticationStrategy
    
    // TODO: comment this initializer
    public required init(authStrategy: AuthenticationStrategy) {
        self.authStrategy = authStrategy
    }
    
    // TODO: comment this initializer
    public convenience required init(username: String, password: String) {
        let authStrategy = BasicAuthenticationStrategy(tokenURL: Constants.tokenURL,
                                                       serviceURL: Constants.serviceURL, username: username, password: password)
        self.init(authStrategy: authStrategy)
    }
    
    /**
     Retrieves the list of tones
    */
    public func getDocumentTone(
        completionHandler: ([DocumentTone]?, NSError?) -> Void) {
        
         var urlParams = [NSURLQueryItem]()
        
        urlParams.append(NSURLQueryItem(name: "text", value: "hello how are you"))
        urlParams.append(NSURLQueryItem(name: "version", value: "2016-02-11"))
        
        // construct request
        let request = WatsonRequest(
            method: .GET,
            serviceURL: Constants.serviceURL,
            endpoint: Constants.tone,
            authStrategy: authStrategy,
            accept: .JSON,
            urlParams: urlParams)
        
        // execute request
        gateway.request(request, serviceError: ToneAnalyzerError()) {
            data, error in
            
            
            let str = "{\"document_tone\":{\"tone_categories\":[{\"tones\":[{\"score\":0.10715,\"tone_id\":\"anger\",\"tone_name\":\"Anger\"},{\"score\":0.313029,\"tone_id\":\"disgust\",\"tone_name\":\"Disgust\"},{\"score\":0.129359,\"tone_id\":\"fear\",\"tone_name\":\"Fear\"},{\"score\":0.129185,\"tone_id\":\"joy\",\"tone_name\":\"Joy\"},{\"score\":0.303293,\"tone_id\":\"sadness\",\"tone_name\":\"Sadness\"}],\"category_id\":\"emotion_tone\",\"category_name\":\"Emotion Tone\"},{\"tones\":[{\"score\":0.954,\"tone_id\":\"analytical\",\"tone_name\":\"Analytical\"},{\"score\":0.0,\"tone_id\":\"confident\",\"tone_name\":\"Confident\"},{\"score\":0.0,\"tone_id\":\"tentative\",\"tone_name\":\"Tentative\"}],\"category_id\":\"writing_tone\",\"category_name\":\"Writing Tone\"},{\"tones\":[{\"score\":0.023,\"tone_id\":\"openness_big5\",\"tone_name\":\"Openness\"},{\"score\":0.046,\"tone_id\":\"conscientiousness_big5\",\"tone_name\":\"Conscientiousness\"},{\"score\":0.984,\"tone_id\":\"extraversion_big5\",\"tone_name\":\"Extraversion\"},{\"score\":0.817,\"tone_id\":\"agreeableness_big5\",\"tone_name\":\"Agreeableness\"},{\"score\":0.531,\"tone_id\":\"neuroticism_big5\",\"tone_name\":\"Emotional Range\"}],\"category_id\":\"social_tone\",\"category_name\":\"Social Tone\"}]}}"
            
            
            print("src string: \(str)")
            
            let userx = Mapper<DocumentTone>().map(str)
            
            completionHandler([userx!], error)
            
           let documentTone = Mapper<DocumentTone>().mapDataArray(data, keyPath: "document_tone.tone_categories.tones")
//            let JSONString = Mapper().toJSONString(documentTone!, prettyPrint: true)
            
//            print("doctone" + JSONString!)
//            completionHandler(documentTone, error)
        }
    }
    
    
/*
    /**
     Retrieves the list of identifiable languages
     
     - parameter completionHandler: callback method that is invoked with the
     identifiable languages
     */
    public func getIdentifiableLanguages(
        completionHandler: ([IdentifiableLanguage]?, NSError?) -> Void) {
        
        // construct request
        let request = WatsonRequest(
            method: .GET,
            serviceURL: Constants.serviceURL,
            endpoint: Constants.identifiableLanguages,
            authStrategy: authStrategy,
            accept: .JSON)
        
        // execute request
        gateway.request(request, serviceError: LanguageTranslationError()) { data, error in
            let languages = Mapper<IdentifiableLanguage>().mapDataArray(data, keyPath: "languages")
            completionHandler(languages, error)
        }
    }
    
    /**
     Identify the language in which text is written
     
     - parameter text:              the text to identify
     - parameter completionHandler: the callback method to be invoked with an array of
     identified languages in descending order of
     confidence
     */
    public func identify(text: String,
                         completionHandler: ([IdentifiedLanguage]?, NSError?) -> Void) {
        
        // construct request
        let request = WatsonRequest(
            method: .GET,
            serviceURL: Constants.serviceURL,
            endpoint: Constants.identify,
            authStrategy: authStrategy,
            accept: .JSON,
            urlParams: [NSURLQueryItem(name: "text", value: text)])
        
        // execute request
        gateway.request(request, serviceError: LanguageTranslationError()) { data, error in
            let languages = Mapper<IdentifiedLanguage>().mapDataArray(data, keyPath: "languages")
            completionHandler(languages, error)
        }
    }
    
    /**
     Translate text using source and target languages
     
     - parameter text:              The text to translate
     - parameter source:            The language that the original text is written in
     - parameter target:            The language that the text will be translated into
     - parameter completionHandler: The callback method that is invoked with the
     translated strings
     */
    public func translate(text: String, source: String, target: String,
                          completionHandler: (String?, NSError?) -> Void) {
        
        translate(TranslateRequest(text: [text], source: source, target: target)) {
            text, error in
            guard let text = text else {
                completionHandler(nil, error)
                return
            }
            var translation = text[0]
            for i in 1..<text.count {
                translation += " " + text[i]
            }
            completionHandler(translation, error)
        }
    }
    
    /**
     Translate text using a model specified by modelID
     
     - parameter text:              The text to translate
     - parameter modelID:           The ID of the model that should be used for
     translation parameters
     - parameter completionHandler: The callback method that is invoked with the
     translated strings
     */
    public func translate(text: String, modelID: String,
                          completionHandler: (String?, NSError?) -> Void) {
        
        translate(TranslateRequest(text: [text], modelID: modelID)) {
            text, error in
            guard let text = text else {
                completionHandler(nil, error)
                return
            }
            var translation = text[0]
            for i in 1..<text.count {
                translation += " " + text[i]
            }
            completionHandler(translation, error)
        }
    }
    
    /**
     Translate text using source and target languages
     
     - parameter text:              The text to translate
     - parameter source:            The language that the original text is written in
     - parameter target:            The language that the text will be translated into
     - parameter completionHandler: The callback method that is invoked with the
     translated strings
     */
    public func translate(text: [String], source: String, target: String,
                          completionHandler: ([String]?, NSError?) -> Void) {
        
        translate(TranslateRequest(text: text, source: source, target: target),
                  completionHandler: completionHandler)
    }
    
    /**
     Translate text using a model specified by modelID
     
     - parameter text:              The text to translate
     - parameter modelID:           The ID of the model that should be used for
     translation parameters
     - parameter completionHandler: The callback method that is invoked with the
     translated strings
     */
    public func translate(text: [String], modelID: String,
                          completionHandler: ([String]?, NSError?) -> Void) {
        
        translate(TranslateRequest(text: text, modelID: modelID),
                  completionHandler: completionHandler)
    }
    
    /**
     Translate text given a `TranslateRequest`.
     - parameter translateRequest: The TranslateRequest object to be used in the body
     of the HTTP request.
     - parameter completionHandler: The callback method that is invoked with the
     translated strings.
     */
    private func translate(translateRequest: TranslateRequest,
                           completionHandler: ([String]?, NSError?) -> Void) {
        
        // construct request
        let request = WatsonRequest(
            method: .POST,
            serviceURL: Constants.serviceURL,
            endpoint: Constants.translate,
            authStrategy: authStrategy,
            accept: .JSON,
            contentType: .JSON,
            messageBody: Mapper().toJSONData(translateRequest))
        
        // execute request
        gateway.request(request, serviceError: LanguageTranslationError()) { data, error in
            let translations = Mapper<TranslateResponse>().mapData(data)?.translationStrings
            completionHandler(translations, error)
        }
    }
    
    /**
     Lists available standard and custom models by source or target language
     
     - parameter source:       Filter models by source language.
     - parameter target:       Filter models by target language.
     - parameter defaultModel: Valid values are leaving it unset, 'true' and 'false'. When 'true', it filters models to return the default model or models. When 'false' it returns the non-default model or models. If not set, all models (default and non-default) return.
     - parameter callback:     The callback method to invoke after the response is received
     */
    public func getModels(source: String? = nil, target: String? = nil,
                          defaultModel: Bool? = nil, completionHandler: ([TranslationModel]?, NSError?) -> Void) {
        
        // construct url query parameters
        var urlParams = [NSURLQueryItem]()
        if let source = source {
            urlParams.append(NSURLQueryItem(name: "source", value: "\(source)"))
        }
        if let target = target {
            urlParams.append(NSURLQueryItem(name: "target", value: "\(target)"))
        }
        if let defaultModel = defaultModel {
            urlParams.append(NSURLQueryItem(name: "default", value: "\(defaultModel)"))
        }
        
        // construct request
        let request = WatsonRequest(
            method: .GET,
            serviceURL: Constants.serviceURL,
            endpoint: Constants.models,
            authStrategy: authStrategy,
            accept: .JSON,
            urlParams: urlParams)
        
        // execute request
        gateway.request(request, serviceError: LanguageTranslationError()) { data, error in
            let models = Mapper<TranslationModel>().mapDataArray(data, keyPath: "models")
            completionHandler(models, error)
        }
    }
    
    /**
     Returns information, including training status, about a specified translation model.
     
     - parameter modelID:           The model identifier
     - parameter completionHandler: The callback method to invoke after the response is received
     */
    public func getModel(modelID: String,
                         completionHandler: (TranslationModel?, NSError?) -> Void) {
        
        // construct request
        let request = WatsonRequest(
            method: .GET,
            serviceURL: Constants.serviceURL,
            endpoint: Constants.model(modelID),
            authStrategy: authStrategy,
            accept: .JSON)
        
        // execute request
        gateway.request(request, serviceError: LanguageTranslationError()) { data, error in
            let model = Mapper<TranslationModel>().mapData(data)
            completionHandler(model, error)
        }
    }
    
    /**
     Uploads a TMX glossary file on top of a domain to customize a translation model.
     
     - parameter baseModelID:        (Required). Specifies the domain model that is used as the base for the training.
     - parameter name:               The model name. Valid characters are letters, numbers, -, and _. No spaces.
     - parameter forcedGlossaryPath: (Required). A TMX file with your customizations. Anything specified in this file will completely overwrite the domain data translation.
     - parameter callback:           Returns the created model
     */
    public func createModel(baseModelID: String, name: String? = nil, fileKey: String, fileURL: NSURL, completionHandler: (String?, NSError?) -> Void) {
        
        // force token to refresh
        // TODO: can remove this after its handled by WatsonGateway
        authStrategy.refreshToken() { error in
            
            // add token to header params
            // TODO: can remove this after its handled by WatsonGateway
            var headerParams = [String: String]()
            if let token = self.authStrategy.token {
                headerParams["X-Watson-Authorization-Token"] = token
            }
            
            // construct url query parameters
            var urlParams = [NSURLQueryItem]()
            urlParams.append(NSURLQueryItem(name: "base_model_id", value: baseModelID))
            if let name = name {
                urlParams.append(NSURLQueryItem(name: "name", value: name))
            }
            
            // construct request
            let request = WatsonRequest(
                method: .POST,
                serviceURL: Constants.serviceURL,
                endpoint: Constants.models,
                authStrategy: self.authStrategy,
                accept: .JSON,
                headerParams: headerParams,
                urlParams: urlParams)
            
            // execute request
            Alamofire.upload(request,
                multipartFormData: { multipartFormData in
                    // encode files as form data
                    multipartFormData.appendBodyPart(fileURL: fileURL, name: fileKey)
                },
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .Success(let upload, _, _):
                        // execute encoded request
                        upload.responseObject {
                            (response: Response<CustomModel, NSError>) in
                            let unwrapID = {
                                (customModel: CustomModel?, error: NSError?) in
                                completionHandler(customModel?.modelID, error) }
                            print(response)
                            validate(response, serviceError: LanguageTranslationError(),
                                completionHandler: unwrapID)
                        }
                    case .Failure:
                        // construct and return error
                        let nsError = NSError(
                            domain: "com.alamofire.error",
                            code: -6008,
                            userInfo: [NSLocalizedDescriptionKey:
                                "Unable to encode data as multipart form."])
                        completionHandler(nil, nsError)
                    }
            })
        }
    }
    
    /**
     Delete a translation model
     
     - parameter modelID:           The model identifier
     - parameter completionHandler: The callback method to invoke after the response is received, returns true if delete is successful
     */
    public func deleteModel(modelID: String, completionHandler: NSError? -> Void) {
        
        // construct request
        let request = WatsonRequest(
            method: .DELETE,
            serviceURL: Constants.serviceURL,
            endpoint: Constants.model(modelID),
            authStrategy: authStrategy)
        
        // execute request
        gateway.request(request, serviceError: LanguageTranslationError()) { data, error in
            completionHandler(error)
        }
    }
 
 */
}