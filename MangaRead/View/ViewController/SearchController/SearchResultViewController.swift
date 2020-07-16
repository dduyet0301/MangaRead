//
//  SearchResultViewController.swift
//  MangaRead
//
//  Created by gem on 7/15/20.
//  Copyright © 2020 gem. All rights reserved.
//

import UIKit

class SearchResultViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnABC: UIButton!
    @IBOutlet weak var btnRating: UIButton!
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var btnRelease: UIButton!
    var getData = GetData()
    var page = 1
    var orderBy = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        getData.fetchSearchResult(orderBy: orderBy, page: page)
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name("ReloadSearchResult"), object: nil)
        Contains.arrSearchResult.removeAll()
    }
    
    @objc func reload() {
        collectionView.reloadData()
    }
    
    @IBAction func sortByABC(_ sender: Any) {
        if orderBy != "a-z" {
        page = 1
        orderBy = "a-z"
        getData.fetchSearchResult(orderBy: orderBy, page: page)
        collectionView.reloadData()
        btnABC.setTitleColor(.red, for: .normal)
        btnRating.setTitleColor(.blue, for: .normal)
        btnUpdate.setTitleColor(.blue, for: .normal)
        btnRelease.setTitleColor(.blue, for: .normal)
        }
    }
    
    @IBAction func sortByRating(_ sender: Any) {
        if orderBy != "rating" {
        page = 1
        orderBy = "rating"
        getData.fetchSearchResult(orderBy: orderBy, page: page)
        collectionView.reloadData()
        btnABC.setTitleColor(.blue, for: .normal)
        btnRating.setTitleColor(.red, for: .normal)
        btnUpdate.setTitleColor(.blue, for: .normal)
        btnRelease.setTitleColor(.blue, for: .normal)
        }
    }
    
    @IBAction func sortByUpdate(_ sender: Any) {
        if orderBy != "update" {
        page = 1
        orderBy = "update"
        getData.fetchSearchResult(orderBy: orderBy, page: page)
        collectionView.reloadData()
        btnABC.setTitleColor(.blue, for: .normal)
        btnRating.setTitleColor(.blue, for: .normal)
        btnUpdate.setTitleColor(.red, for: .normal)
        btnRelease.setTitleColor(.blue, for: .normal)
        }
    }
    
    @IBAction func sortByRelease(_ sender: Any) {
        if orderBy != "create" {
            page = 1
            orderBy = "create"
            getData.fetchSearchResult(orderBy: orderBy, page: page)
            collectionView.reloadData()
            btnABC.setTitleColor(.blue, for: .normal)
             btnRating.setTitleColor(.blue, for: .normal)
             btnUpdate.setTitleColor(.blue, for: .normal)
             btnRelease.setTitleColor(.red, for: .normal)
        }
    }
}

extension SearchResultViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Contains.arrSearchResult.count > 0 ? 1 : 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Contains.arrSearchResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchResultCollectionViewCell", for: indexPath) as! CollectionViewCell
        let manga = Contains.arrSearchResult[indexPath.row]
        cell.img.sd_setImage(with: URL(string: "https:\(manga.image)"))
        cell.lbTitle.text = manga.title
        cell.lbLatest.text = manga.latestChapter
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SearchResultHeaderCell", for: indexPath) as? HeaderCollectionReusableView {
                headerView.lbPage.text = "\(page)"
                headerView.btnPrev.addTarget(self, action: #selector(prevClick), for: .touchUpInside)
                headerView.btnNext.addTarget(self, action: #selector(nextClick), for: .touchUpInside)
                return headerView }
        case UICollectionView.elementKindSectionFooter:
            if let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SearchResultFooterCell", for: indexPath) as? FooterCollectionReusableView {
                footerView.lbPage.text = "\(page)"
                footerView.btnPrev.addTarget(self, action: #selector(prevClick), for: .touchUpInside)
                footerView.btnNext.addTarget(self, action: #selector(nextClick), for: .touchUpInside)
                return footerView
            }
        default:
            assert(false, "Unexpected element kind")
        }
        return UICollectionReusableView()
    }
    
    @objc func prevClick() {
        if page > 1 {
            page -= 1
            Contains.arrSearchResult.removeAll()
            getData.fetchSearchResult(orderBy: orderBy, page: page)
            collectionView.reloadData()
            collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
    }
    
    @objc func nextClick() {
        if page < 334 {
            page += 1
            Contains.arrSearchResult.removeAll()
            getData.fetchSearchResult(orderBy: orderBy, page: page)
            collectionView.reloadData()
            collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
    }
}

extension SearchResultViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cache = MangaCache()
        let manga = Contains.arrSearchResult[indexPath.row]
        let mangaDetail = storyboard?.instantiateViewController(withIdentifier: "MangaDetailViewController") as! MangaDetailViewController
        mangaDetail.mangaTitle = manga.title
        mangaDetail.urlDetail = manga.url
        if cache.itemExist(mangaTitle: manga.title, entity: Contains.RECENT_COREDATA) {
            cache.delete(mangaTitle: manga.title, entity: Contains.RECENT_COREDATA)
        }
        cache.save(manga: manga, entity: Contains.RECENT_COREDATA)
        Contains.mangaDetail.removeDetail()
        self.navigationController?.pushViewController(mangaDetail, animated: true)
    }
}
