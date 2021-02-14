//
//  WordsResponse.swift
//  Wordnik
//
//  Created by Tatyana Korotkova on 13.02.2021.
//

import Foundation

struct WordnikResponse: Decodable{
    var relationshipType: String
    var words: [String]
}

