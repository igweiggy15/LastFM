//
//  LastFMService.swift
//  LastFMproj
//
//  
//

import Foundation

typealias ArtistHandler = ([Artist]) -> Void
typealias AlbumHandler = ([Album]) -> Void
typealias TrackHandler = ([Track]) -> Void

let lsService = LastService.shared

final class LastService {
    
    static let shared = LastService()
    private init() {}
    
    lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        return URLSession(configuration: config)
    }()
    
    
    //MARK: Artist
    func get(artist: String, completion: @escaping ArtistHandler) {
        
        var limit = 30
        if let artistsCount = UserDefaults.standard.value(forKey: Limits.Keys.artistsCount.rawValue) as? Int {
            limit = artistsCount
        }
        
        let urlString = LastFMAPI.getArtistURL(artist, limit)
        
        guard let finalURL = URL(string: urlString) else {
            completion([])
            return
        }
        
        session.dataTask(with: finalURL) { (dat, _, _) in
            
            if let data = dat {
                
                do {
                    let response = try JSONDecoder().decode(ArtistResults.self, from: data)
                    
                    let artists = response.results.artistmatches.artist
                    
                    completion(artists)
                    
                } catch let err {
                    completion([])
                    print("Error: \(err.localizedDescription)")
                }
                
            }
            
        }.resume()
        
    } //end func
    
    
    //MARK: Album
    
    func getAlbums(for artist: String, completion: @escaping AlbumHandler) {
        
        let urlString = LastFMAPI.getAlbumURL(artist)
        
        guard let finalURL = URL(string: urlString) else {
            completion([])
            return
        }
        
        session.dataTask(with: finalURL) { (dat, _, _) in
            
            if let data = dat {
                
                do {
                    let response = try JSONDecoder().decode(AlbumResponse.self, from: data)
                    
                    let albums = response.topAlbums.album
                    
                    completion(albums)
                    
                } catch let err {
                    completion([])
                    print("Error: \(err.localizedDescription)")
                }
                
            }
            
        }.resume()
        
    } //end func
    
    
    //MARK: Track
    func getTracks(for artist: String, completion: @escaping TrackHandler) {
        
        let urlString = LastFMAPI.getTrackURL(artist)
        
        guard let url = URL(string: urlString) else {
            completion([])
            return
        }
        
        
        session.dataTask(with: url) { (dat, _, _) in
            
            if let data = dat {
                
                do {
                    let result = try JSONDecoder().decode(TrackResult.self, from: data)
                    let tracks = result.toptracks.track
                    completion(tracks)
                } catch {
                    
                    completion([])
                    print("Error: \(error.localizedDescription)")
                    return
                }
                
            }
        }.resume()
        
    }
    
    
    
}

let dlManager = DownloadManager.shared
typealias DataHandler = (Data?) -> Void

final class DownloadManager {
    
    static let shared = DownloadManager()
    private init() {}
    
    lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        return URLSession(configuration: config)
    }()
    
    let cache = NSCache<NSString, NSData>()
    
    func download(_ url: String, completion: @escaping DataHandler) {
        
        if let data = cache.object(forKey: url as NSString) {
            completion(data as Data)
            return
        }
        guard let finalURL = URL(string: url) else {
            completion(nil)
            return
        }
        
        session.dataTask(with: finalURL) { [unowned self] (dat, _, _) in
            
            if let data = dat {
                
                self.cache.setObject(data as NSData, forKey: url as NSString)
                
                DispatchQueue.main.async {
                    completion(data)
                }
            }
            }.resume()
        
    }
    
}

struct Utility {
    
    //MARK: FileManager
    static private let fileManager = FileManager.default
    
    //MARK: Save FM
    static func saveWithFileManager(_ data: Data) {
        
        let hash = String(data.hashValue)
        
        guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(hash) else {
            
            print("Error with file system")
            return
        }
        
        do {
            try data.write(to: url)
            print("Successfully wrote data to disk")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //MARK: Load FM
    static func loadWithFileManager(_ hashValue: String) -> URL? {
        
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomain = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomain, true)
        
        if let dirPath = paths.first {
            
            let url = URL(fileURLWithPath: dirPath).appendingPathComponent(hashValue)
            
            return url
        }
        
        return nil
    }
    
    //MARK: Helpers
    static func getImageURL(from images: [Image]) -> String? {
        
        guard let img = images.first(where: {$0.size == "extralarge"}) else {
            return nil
        }
        
        return img.text
    }
    
}
