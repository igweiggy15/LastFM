//
//  ContentTableCell.swift
//  LastFMproj
//
//  
//

import UIKit

class ContentTableCell: UITableViewCell {
    
    @IBOutlet weak var contentImage: UIImageView!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    static let identifier = "ContentTableCell"
    
    func configure(with content: Content) {
        
        switch content {
        case .artist(let artist):
            
            contentLabel.text = artist.name
            
            guard let url = Utility.getImageURL(from: artist.image) else {
                contentImage.image = #imageLiteral(resourceName: "ph_placeholder")
                return
            }
            
            dlManager.download(url) { [unowned self] dat in
                
                if let data = dat {
                    
                    let image = UIImage(data: data)
                    self.contentImage.image = image
                }
            }
            
        case .album(let album):
            
            contentLabel.text = album.name
            
            guard let url = Utility.getImageURL(from: album.image) else {
                contentImage.image = #imageLiteral(resourceName: "ph_placeholder")
                return
            }
            
            dlManager.download(url) { [unowned self] dat in
                
                if let data = dat {
                    
                    let image = UIImage(data: data)
                    self.contentImage.image = image
                }
            }
            
        case .track(let track):
            
            contentLabel.text = track.name
            
            guard let url = Utility.getImageURL(from: track.image) else {
                contentImage.image = #imageLiteral(resourceName: "ph_placeholder")
                return
            }
            
            dlManager.download(url) { [unowned self] dat in
                
                if let data = dat {
                    
                    let image = UIImage(data: data)
                    self.contentImage.image = image
                }
            }
        }
    } //end func
}
