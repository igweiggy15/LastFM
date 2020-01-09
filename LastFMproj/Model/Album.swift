//
//  Album.swift
//  LastFMproj
//
//  
//

import Foundation

struct AlbumResponse: Decodable {
    
    let topAlbums: AlbumInfo
    
    private enum CodingKeys: String, CodingKey {
        case topAlbums = "top albums"
    }
}

struct  AlbumInfo: Decodable {
    let album: [Album]
}

class Album: Decodable {
    
    let name: String
    let playCount: Int
    let image: [Image]
    
    private enum CodingKeys: String, CodingKey {
        case playCount = "play count"
        case name
        case image
    }
}
