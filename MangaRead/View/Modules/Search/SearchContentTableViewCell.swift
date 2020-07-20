//
//  SearchContentTableViewCell.swift
//  MangaRead
//
//  Created by gem on 7/15/20.
//  Copyright © 2020 gem. All rights reserved.
//

import UIKit

class SearchContentTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    public static var genre = ""
    public static var arrGenreList: [String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.dataSource = self
        collectionView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name("ReloadSearchContent"), object: nil)
    }
    
    @objc func reload() {
        collectionView.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}

extension SearchContentTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SearchContentTableViewCell.arrGenreList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchContentCollectionViewCell", for: indexPath) as! SearchContentCollectionViewCell
        cell.lbSearchContent.text = SearchContentTableViewCell.arrGenreList[indexPath.row]
        cell.lbSearchContent.backgroundColor = .lightGray
        cell.lbSearchContent.layer.cornerRadius = 10.0
        cell.lbSearchContent.clipsToBounds = true
        return cell
    }
}

extension SearchContentTableViewCell: UICollectionViewDelegate {
    
}
