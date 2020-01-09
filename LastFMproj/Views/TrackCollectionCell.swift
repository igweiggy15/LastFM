//
//  TrackCollectionCell.swift
//  LastFMproj
//
//  
//

import UIKit

class TrackCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var trackImage: UIImageView!
    @IBOutlet weak var trackLabel: UILabel!
    
    static let identifier = "TrackCollectionCell"
    
    func configure(with album: Album) {
        
        trackLabel.text = album.name
        
        guard let url = Utility.getImageURL(from: album.image) else {
            trackImage.image = #imageLiteral(resourceName: "ph_placeholder")
            return
        }
        
        dlManager.download(url) { [unowned self] dat in
            if let data = dat, let image = UIImage(data: data) {
                self.trackImage.image = image
            }
        }
    }
}
