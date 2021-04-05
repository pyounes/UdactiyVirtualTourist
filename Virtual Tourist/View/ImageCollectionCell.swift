//
//  ImageCollectionCell.swift
//  Virtual Tourist
//
//  Created by Pierre Younes on 4/5/21.
//

import UIKit

class ImageCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setupCell(image: Data?) {
        self.imageView.image = UIImage(data: image!)
    }
    
}
