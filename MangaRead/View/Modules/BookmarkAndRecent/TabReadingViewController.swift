//
//  TabReadingViewController.swift
//  MangaRead
//
//  Created by gem on 7/13/20.
//  Copyright © 2020 gem. All rights reserved.
//

import UIKit

class TabReadingViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    var currentSegment = 0
    let cache = MangaCache()
    var arrReadingItem: [Manga] = []
    var arrBookmark: [Manga] = []
    var arrRecent: [Manga] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        getReadingTabData()
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name("ReloadReadingTab"), object: nil)
    }
    
    @objc func reload() {
        getReadingTabData()
        if currentSegment == 0 {
            arrReadingItem = arrBookmark.reversed()
        } else {
            arrReadingItem = arrRecent.reversed()
        }
    }
    
    func getReadingTabData() {
        arrBookmark = cache.get(entity: Contains.BOOKMARK_COREDATA)
        arrRecent = cache.get(entity: Contains.RECENT_COREDATA)
        collectionView.reloadData()
    }
    
    @IBAction func didChangeSegment(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            currentSegment = 0
            arrReadingItem = arrBookmark.reversed()
        } else if sender.selectedSegmentIndex == 1 {
            currentSegment = 1
            arrReadingItem = arrRecent.reversed()
        }
        collectionView.reloadData()
    }
}

extension TabReadingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrReadingItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let manga = arrReadingItem[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabReadingCell", for: indexPath) as! TabReadingCollectionViewCell
        cell.lbTitle.text = manga.title
        cell.img.sd_setImage(with: URL(string: "https:\(manga.image)"))
        cell.lbLatest.text = manga.latestChapter
        return cell
    }
}

extension TabReadingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let manga = arrReadingItem[indexPath.row]
        let mangaDetail = storyboard?.instantiateViewController(withIdentifier: "MangaDetailViewController") as! MangaDetailViewController
        mangaDetail.mangaTitle = manga.title
        mangaDetail.urlDetail = manga.url
        self.navigationController?.pushViewController(mangaDetail, animated: true)
    }
}

