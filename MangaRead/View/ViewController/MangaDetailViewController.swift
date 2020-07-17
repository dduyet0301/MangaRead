//
//  MangaDetailViewController.swift
//  MangaRead
//
//  Created by gem on 7/8/20.
//  Copyright © 2020 gem. All rights reserved.
//

import UIKit
import SDWebImage

class MangaDetailViewController: UIViewController {
    @IBOutlet weak var tableDetail: UITableView!
    var mangaDetail = MangaDetail.init()

    var bookmarked = false
    var urlDetail = ""
    var mangaTitle = ""
    let getData = GetData()
    let cache = MangaCache()
    
    override func viewDidLoad() {
        tableDetail.dataSource = self
        tableDetail.delegate = self
        self.title = mangaTitle
        getData.fetchMangaDetail(url: urlDetail, callback: addMangaDetail(detail:))
        bookmarked = cache.itemExist(mangaTitle: mangaTitle, entity: Contains.BOOKMARK_COREDATA)
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.bookmarks, target: self, action: #selector(bookmarking))
        if bookmarked {
            button.tintColor = .red
        }
        navigationItem.rightBarButtonItem = button
    }
    
    func addMangaDetail(detail: MangaDetail) {
        mangaDetail = detail
        tableDetail.reloadData()
    }
    
    @objc func bookmarking() {
        let title = mangaDetail.title
        let image = mangaDetail.image
        let latest = mangaDetail.latest
        if bookmarked {
            cache.delete(mangaTitle: title, entity: Contains.BOOKMARK_COREDATA)
        } else {
            cache.save(manga: Manga.init(title: title
                , image: image, latestChapter: latest, url: urlDetail), entity: Contains.BOOKMARK_COREDATA)
        }
        NotificationCenter.default.post(name: Notification.Name("ReloadTabReading"), object: nil)
        viewDidLoad()
    }
}

extension MangaDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mangaDetail.chapters.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let detail = mangaDetail
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableCell") as! MangaDetailTableViewCell
            cell.imageThumbnail.sd_setImage(with: URL(string: "https:\(detail.image)"))
            cell.lbTitle.text = detail.title
            cell.lbStar.text = "Star: \(detail.star)"
            cell.lbDetail.text = "Rating: \(detail.rating)\nPopularity: \(detail.popularity)\nAlternative: \(detail.alternative)\nAuthor: \(detail.author)\nArtist: \(detail.artist)\nGenre: \(detail.genre)\nType: \(detail.type)\nRelease: \(detail.release)\nStatus: \(detail.status)\nLatest: \(detail.latest)"
            cell.lbSummary.text = "    \(detail.summary)"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChapterTableCell") as! ChapterListTableViewCell
            cell.lbChapter.text = detail.chapters[indexPath.row - 1].name
            return cell
        }
    }
}

extension MangaDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0 {
            //chapter select
            let readManga = storyboard?.instantiateViewController(withIdentifier: "ReadAllViewController") as! ReadAllViewController
            readManga.url = mangaDetail.chapters[indexPath.row - 1].url
            readManga.title = mangaDetail.chapters[indexPath.row - 1].name
            self.navigationController?.pushViewController(readManga, animated: true)
        }
    }
}
