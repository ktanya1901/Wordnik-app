//
//  APIService.swift
//  Wordnik
//
//  Created by Tatyana Korotkova on 13.02.2021.
//

import Foundation
import Moya

enum APIService{
    case getSynonym(text: String)
    case getAntonym(text: String)
    case getAudio(text: String)
}
//https://api.wordnik.com/v4/word.json/door/relatedWords?useCanonical=false&relationshipTypes=synonym&limitPerRelationshipType=10&api_key=YOURAPIKEY

extension APIService: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.wordnik.com/v4/word.json")!
    }
    
    var path: String {
        switch self{
        case .getSynonym (let text):
            return "/\(text.lowercased())/relatedWords"
        case .getAntonym( let text):
            return "/\(text.lowercased())/relatedWords"
        case .getAudio(let text):
            return "/\(text.lowercased())/audio"
        }
        
    }
    
    var method: Moya.Method {
        switch self {
        case .getSynonym:
            return .get
        case .getAntonym:
            return .get
        case .getAudio:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getSynonym:
            let params: [String : String] = [
                "useCanonical" : "false",
                "relationshipTypes" : "synonym",
                "limitPerRelationshipType" : "10",
                "api_key" : "a2a73e7b926c924fad7001ca3111acd55af2ffabf50eb4ae5"
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getAntonym:
            let params: [String : String] = [
                "useCanonical" : "false",
                "relationshipTypes" : "antonym",
                "limitPerRelationshipType" : "10",
                "api_key" : "a2a73e7b926c924fad7001ca3111acd55af2ffabf50eb4ae5"
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getAudio:
            let params: [String : String] = [
                "useCanonical" : "false",
                "limit" : "1",
                "api_key" : "a2a73e7b926c924fad7001ca3111acd55af2ffabf50eb4ae5"
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type" : "application/json"]
    }
    
    
}

