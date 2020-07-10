//
//  ViewController.swift
//  MangaRead
//
//  Created by gem on 7/6/20.
//  Copyright © 2020 gem. All rights reserved.
//

import UIKit
import SDWebImage

class MainViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    let getData = GetData()
//    var page = 1
        var pageLatest = 1
        var pageUpdates = 1
        var pagePopular = 1
    var currentSegment = 0
    var yL: CGFloat = 0.0
    var yU: CGFloat = 0.0
    var yP: CGFloat = 0.0
    
    override func loadView() {
        super.loadView()
        getData.fetchLatestManga(collectionView, page: pageLatest)
        getData.fetchUpdatesManga(collectionView, page: pageUpdates)
        getData.fetchPopularManga(collectionView, page: pagePopular)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        Contains.arrManga = Contains.arrLatest
        collectionView.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name("reload"), object: nil)
    }
    
    @objc func reload (notification: NSNotification) {
        self.viewDidLoad()
    }
    
    @IBAction func didChangeSegment(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            currentSegment = 0
            collectionView.setContentOffset(CGPoint(x: 0, y: yL), animated: true)
            Contains.arrManga = Contains.arrLatest
            collectionView.reloadData()
        } else if sender.selectedSegmentIndex == 1 {
            currentSegment = 1
            collectionView.setContentOffset(CGPoint(x: 0, y: yU), animated: true)
            Contains.arrManga = Contains.arrUpdates
            collectionView.reloadData()
        } else if sender.selectedSegmentIndex == 2 {
            currentSegment = 2
            collectionView.setContentOffset(CGPoint(x: 0, y: yP), animated: true)
            Contains.arrManga = Contains.arrPopular
            collectionView.reloadData()
        }
    }
}

extension MainViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Contains.arrManga.count > 0 ? 1 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Contains.arrManga.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        let manga = Contains.arrManga[indexPath.row]
        cell.img.sd_setImage(with: URL(string: "https:\(manga.image)"))
        cell.lbTitle.text = manga.title
        cell.lbLatest.text = manga.latestChapter
        return cell
    }
    
    @objc func prevPage() {
        if currentSegment == 0 {
            prev(page: pageLatest)
        } else if currentSegment == 1 {
            prev(page: pageUpdates)
        } else if currentSegment == 2 {
            prev(page: pagePopular)
        }
    }
    
    @objc func nextPage() {
        if currentSegment == 0 {
            next(page: pageLatest)
        } else if currentSegment == 1 {
             next(page: pageUpdates)
        } else if currentSegment == 2 {
             next(page: pagePopular)
        }
    }
    
    func prev(page: Int) {
        var currentPage: Int
        currentPage = page
        if currentPage > 1 {
            currentPage -= 1
        }
    }
    
    func next(page: Int) {
        var currentPage: Int
        currentPage = page
        if currentPage < 39 {
            currentPage += 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderCell", for: indexPath) as? HeaderCollectionReusableView {
                if currentSegment == 0 {
                    headerChange(headerView, pageLatest)
                } else if currentSegment == 1 {
                     headerChange(headerView, pageUpdates)
                } else if currentSegment == 2 {
                     headerChange(headerView, pagePopular)
                }
                return headerView }
        case UICollectionView.elementKindSectionFooter:
            if let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FooterCell", for: indexPath) as? FooterCollectionReusableView {
                
                return footerView
            }
        default:
            assert(false, "Unexpected element kind")
        }
        return UICollectionReusableView()
    }
    
    func headerChange(_ header: HeaderCollectionReusableView,_ page: Int) {
        header.lbPage.text = "\(page)"
        header.btnPrev.addTarget(self, action: #selector(prevPage), for: .touchUpInside)
        header.btnNext.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
    }
    
    func footerChange(_ footer: FooterCollectionReusableView, _ page: Int) {
        footer.lbPage.text = "\(page)"
//        footer.btnPrev.addTarget(self, action: #selector(prevPage), for: .touchUpInside)
//        footer.btnNext.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
    }
}

extension MainViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if currentSegment == 0 {
            yL = scrollView.contentOffset.y
        } else if currentSegment == 1 {
            yU = scrollView.contentOffset.y
        } else if currentSegment == 2 {
            yP = scrollView.contentOffset.y
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mangaDetail = storyboard?.instantiateViewController(withIdentifier: "MangaDetailViewController") as! MangaDetailViewController
        mangaDetail.title = Contains.arrManga[indexPath.row].title
        mangaDetail.urlDetail = Contains.arrManga[indexPath.row].url
        self.navigationController?.pushViewController(mangaDetail, animated: true)
    }
}

