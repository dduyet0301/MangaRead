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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        if currentSegment == 0 {
            Contains.arrBookmark = cache.get(entity: Contains.BOOKMARK_COREDATA)
            Contains.arrReadingItem = Contains.arrBookmark.reversed()
        } else {
            Contains.arrRecent = cache.get(entity: Contains.RECENT_COREDATA)
            Contains.arrReadingItem = Contains.arrRecent.reversed()
        }
        collectionView.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name("reloadTabReading"), object: nil)
    }
    
    @objc func reload () {
        viewDidLoad()
    }
    
    @IBAction func didChangeSegment(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            currentSegment = 0
            Contains.arrReadingItem = Contains.arrBookmark.reversed()
        } else if sender.selectedSegmentIndex == 1 {
            currentSegment = 1
            Contains.arrReadingItem = Contains.arrRecent.reversed()
        }
        collectionView.reloadData()
    }
}

extension TabReadingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Contains.arrReadingItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let manga = Contains.arrReadingItem[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabReadingCell", for: indexPath) as! TabReadingCollectionViewCell
        cell.lbTitle.text = manga.title
        cell.img.sd_setImage(with: URL(string: "https:\(manga.image)"))
        cell.lbLatest.text = manga.latestChapter
        return cell
    }
}

extension TabReadingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let manga = Contains.arrReadingItem[indexPath.row]
        let mangaDetail = storyboard?.instantiateViewController(withIdentifier: "MangaDetailViewController") as! MangaDetailViewController
        mangaDetail.mangaTitle = manga.title
        mangaDetail.urlDetail = manga.url
        Contains.mangaDetail.removeDetail()
        self.navigationController?.pushViewController(mangaDetail, animated: true)
        NotificationCenter.default.post(name: NSNotification.Name("reloadDetail"), object: nil)
    }
}

