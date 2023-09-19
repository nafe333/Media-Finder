//
//  TableViewCell.swift
//  Media Finder
//
//  Created by Nafea Elkassas on 15/07/2023.
//

import UIKit

class TableViewCell: UITableViewCell {
   //MARK: - Outlets
    
    @IBOutlet weak var mediaImageView: UIImageView!
    
    @IBOutlet weak var mediaTextLabel: UILabel!
    
    @IBOutlet weak var mediaInformationTextLabel: UILabel!
    
    
    @IBAction func imageBtnTapped(_ sender: UIButton) {
        let imageFrameX = mediaImageView.frame.origin.x
               self.mediaImageView.frame.origin.x += 4
               UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, animations: {
                   self.mediaImageView.frame.origin.x -= 8
                   self.mediaImageView.frame.origin.x = imageFrameX
               }, completion: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mediaImageView.isUserInteractionEnabled = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
            }
    
}
