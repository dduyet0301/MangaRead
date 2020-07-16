//
//  ReleaseYearViewController.swift
//  MangaRead
//
//  Created by gem on 7/14/20.
//  Copyright © 2020 gem. All rights reserved.
//

import UIKit

class ReleaseYearViewController: UIViewController {
    
    @IBOutlet weak var viewController: UICollectionView!
    var arrYear: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewController.dataSource = self
        viewController.delegate = self
        for i in 1946...2017 {
            arrYear.append("\(i)")
        }
    }
}

extension ReleaseYearViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrYear.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YearCollectionViewCell", for: indexPath) as! YearCollectionViewCell
        cell.lbReleaseYear.text = arrYear[indexPath.row]
        if arrYear[indexPath.row] == SearchViewController.selectedYear {
            cell.lbReleaseYear.textColor = .red
        } else {
            cell.lbReleaseYear.textColor = .black
        }
        return cell
    }
}

extension ReleaseYearViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        SearchViewController.selectedYear = arrYear[indexPath.row]
        collectionView.reloadData()
        NotificationCenter.default.post(name: Notification.Name("ReloadSearchViewController"), object: nil)
    }
}
