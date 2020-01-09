//
//  Track.swift
//  LastFMproj
//
//  
//

import Foundation

struct TrackResult: Decodable {
    let toptracks: TrackInfo
}

struct TrackInfo: Decodable {
    let track: [Track]
}

class Track: Decodable {
    
    let name: String
    let playCount: String
    let url: String
    let image: [Image]
    
    private enum CodingKeys: String, CodingKey {
        case name
        case playCount = "play count"
        case url
        case image
    }
}
