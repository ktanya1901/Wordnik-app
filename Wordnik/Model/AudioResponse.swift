//
//  AudioResponse.swift
//  Wordnik
//
//  Created by Tatyana Korotkova on 14.02.2021.
//

import Foundation

struct AudioResponse: Decodable{
    var commentCount: Int
    var createdBy: String
    var createdAt: String
    var id: Int
    var word: String
    var duration: Float
    var audioType: String
    var attributionText: String
    var attributionUrl: String
    var fileUrl: String
}
