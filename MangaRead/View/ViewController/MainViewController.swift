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
    let cache = MangaCache()
    var arrManga: [Manga] = []
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
        tabBarController?.delegate = self
        arrManga = Contains.arrLatest
        collectionView.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name("reload"), object: nil)
        let searchButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.search, target: self, action: #selector(search))
        tabBarController!.navigationItem.rightBarButtonItem = searchButton
    }
    
    @objc func search() {
        let search = storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        self.navigationController?.pushViewController(search, animated: true)
    }
    
    @objc func reload (notification: NSNotification) {
        self.viewDidLoad()
    }
    
    @IBAction func didChangeSegment(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            currentSegment = 0
            collectionView.setContentOffset(CGPoint(x: 0, y: yL), animated: true)
            arrManga = Contains.arrLatest
            collectionView.reloadData()
        } else if sender.selectedSegmentIndex == 1 {
            currentSegment = 1
            collectionView.setContentOffset(CGPoint(x: 0, y: yU), animated: true)
            arrManga = Contains.arrUpdates
            collectionView.reloadData()
        } else if sender.selectedSegmentIndex == 2 {
            currentSegment = 2
            collectionView.setContentOffset(CGPoint(x: 0, y: yP), animated: true)
            arrManga = Contains.arrPopular
            collectionView.reloadData()
        }
    }
}

extension MainViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return arrManga.count > 0 ? 1 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrManga.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        let manga = arrManga[indexPath.row]
        cell.img.sd_setImage(with: URL(string: "https:\(manga.image)"))
        cell.lbTitle.text = manga.title
        cell.lbLatest.text = manga.latestChapter
        return cell
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
                if currentSegment == 0 {
                    footerChange(footerView, pageLatest)
                } else if currentSegment == 1 {
                    footerChange(footerView, pageUpdates)
                } else if currentSegment == 2 {
                    footerChange(footerView, pagePopular)
                }
                return footerView
            }
        default:
            assert(false, "Unexpected element kind")
        }
        return UICollectionReusableView()
    }
    
    func headerChange(_ header: HeaderCollectionReusableView, _ page: Int) {
        header.lbPage.text = "\(page)"
        header.btnPrev.addTarget(self, action: #selector(prevPage), for: .touchUpInside)
        header.btnNext.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
    }
    
    func footerChange(_ footer: FooterCollectionReusableView, _ page: Int) {
        footer.lbPage.text = "\(page)"
        footer.btnPrev.addTarget(self, action: #selector(prevPage), for: .touchUpInside)
        footer.btnNext.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
    }
    
    @objc func prevPage() {
        if currentSegment == 0 {
            if pageLatest > 1 {
                pageLatest -= 1
                getData.fetchLatestManga(collectionView, page: pageLatest)
                collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            }
        } else if currentSegment == 1 {
            if pageUpdates > 1 {
                pageUpdates -= 1
                getData.fetchUpdatesManga(collectionView, page: pageUpdates)
                collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            }
        } else if currentSegment == 2 {
            if pagePopular > 1 {
                pagePopular -= 1
                getData.fetchPopularManga(collectionView, page: pagePopular)
                collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            }
        }
        collectionView.reloadData()
    }
    
    @objc func nextPage() {
        if currentSegment == 0 {
            if pageLatest < 39 {
                pageLatest += 1
                getData.fetchLatestManga(collectionView, page: pageLatest)
                collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            }
        } else if currentSegment == 1 {
            if pageUpdates < 39 {
                pageUpdates += 1
                getData.fetchUpdatesManga(collectionView, page: pageUpdates)
                collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            }
        } else if currentSegment == 2 {
            if pagePopular < 39 {
                pagePopular += 1
                getData.fetchPopularManga(collectionView, page: pagePopular)
                collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            }
        }
        collectionView.reloadData()
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
        let manga = arrManga[indexPath.row]
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

extension MainViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.selectedIndex == 1 {
            Contains.arrBookmark = self.cache.get(entity: Contains.BOOKMARK_COREDATA)
            Contains.arrRecent = self.cache.get(entity: Contains.RECENT_COREDATA)
            viewController.viewDidLoad()
        }
    }
}
