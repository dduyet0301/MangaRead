//
//  MangaDetailTableViewCell.swift
//  MangaRead
//
//  Created by gem on 7/8/20.
//  Copyright © 2020 gem. All rights reserved.
//

import UIKit

class MangaDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var imageThumbnail: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbStar: UILabel!
    @IBOutlet weak var lbDetail: UILabel!
    @IBOutlet weak var lbSummary: UILabel!
    @IBOutlet weak var btnBookmark: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
