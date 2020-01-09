//  LastFMAPI.swift
//  LastFMproj
//

import Foundation

struct LastFMAPI {
    
   static let base = "http://ws.audioscrobbler.com/2.0/"
    
    
    static let artistMethod = "?method=artist.search&artist="
    static let albumMethod = "?method=artist.gettopalbums&artist="
    static let trackMethod = "?method=artist.gettoptracks&artist="
    
    static let key = "?method=album.search&album=believe&api_key=5bc3ccb825d804865acac4ba04d9b424&format=json"
    
    static func getArtistURL(_ artist: String, _ limit: Int) -> String {
        let newLimit = "&limit=\(limit)"
        return base + artistMethod + artist + newLimit + key
    }
    
    static func getAlbumURL(_ artist: String) -> String {
        return base + albumMethod + artist + key
    }
    
    static func getTrackURL(_ artist: String) -> String {
        return base + trackMethod + artist + key
    }
}
