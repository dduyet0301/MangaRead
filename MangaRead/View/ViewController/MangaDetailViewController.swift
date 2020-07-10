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
    var urlDetail = ""
    let getData = GetData()
    
    override func viewDidLoad() {
        tableDetail.dataSource = self
        tableDetail.delegate = self
        Contains.mangaDetail.removeDetail()
        getData.fetchMangaDetail(tableDetail, url: urlDetail)
    }
}

extension MangaDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Contains.mangaDetail.chapters.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let detail = Contains.mangaDetail
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
            readManga.url = Contains.mangaDetail.chapters[indexPath.row - 1].url
            readManga.title = Contains.mangaDetail.chapters[indexPath.row - 1].name
            self.navigationController?.pushViewController(readManga, animated: true)
        }
    }
}
