//
//  ChapterListTableViewCell.swift
//  MangaRead
//
//  Created by gem on 7/9/20.
//  Copyright © 2020 gem. All rights reserved.
//

import UIKit

class ChapterListTableViewCell: UITableViewCell {

    @IBOutlet weak var lbChapter: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
