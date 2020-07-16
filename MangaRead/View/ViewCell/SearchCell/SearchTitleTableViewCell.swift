//
//  SearchTitleTableViewCell.swift
//  MangaRead
//
//  Created by gem on 7/14/20.
//  Copyright © 2020 gem. All rights reserved.
//

import UIKit

class SearchTitleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var tfAuthor: UITextField!
    @IBOutlet weak var btnOngoing: UIButton!
    @IBOutlet weak var btnComplete: UIButton!
    public static var title = ""
    public static var author = ""
    public static var status = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tfTitle.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        tfAuthor.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
    }
    
    @IBAction func completeChecked(_ sender: Any) {
        if SearchTitleTableViewCell.status == "ongoing" || SearchTitleTableViewCell.status == "" {
            btnComplete.setTitleColor(.red, for: .normal)
            btnOngoing.setTitleColor(.black, for: .normal)
            SearchTitleTableViewCell.status = "completed"
        }
    }
    
    @IBAction func ongoingChecked(_ sender: Any) {
        if SearchTitleTableViewCell.status == "completed" || SearchTitleTableViewCell.status == "" {
            btnComplete.setTitleColor(.black, for: .normal)
            btnOngoing.setTitleColor(.red, for: .normal)
            SearchTitleTableViewCell.status = "ongoing"
        }
    }
    
    @objc func textDidChange() {
        SearchTitleTableViewCell.title = tfTitle.text!
        SearchTitleTableViewCell.author = tfAuthor.text!
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
