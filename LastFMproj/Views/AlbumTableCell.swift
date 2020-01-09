//
//  AlbumTableCell.swift
//  LastFMproj
//
// 
//

import UIKit

class AlbumTableCell: UITableViewCell {

    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var albumLabel: UILabel!
    
    static let identifier = "AlbumCell"
    
    
    func configureTable(with artist: Artist) {
        
        albumLabel.text = artist.name
        
        guard let url = Utility.getImageURL(from: artist.image) else {
            albumImage.image = #imageLiteral(resourceName: "ph_placeholder")
            return
        }
        
        dlManager.download(url) { [unowned self] dat in
            
            if let data = dat, let image = UIImage(data: data) {
                
                self.albumImage.image = image
            }
        }
    }
}
