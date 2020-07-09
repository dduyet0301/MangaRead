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
    var controllerTitle = ""
    var urlDetail = ""
    let getData = GetData()
    
    override func viewDidLoad() {
        tableDetail.dataSource = self
        tableDetail.delegate = self
        getData.fetchMangaDetail(tableDetail, url: urlDetail)
       self.title = controllerTitle
    }
}

extension MangaDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Contains.arrMangaDetail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let detail = Contains.arrMangaDetail[indexPath.row]
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableCell") as! MangaDetailTableViewCell
            cell.imageThumbnail.sd_setImage(with: URL(string: detail.image))
            cell.lbTitle.text = detail.title
            cell.lbStar.text = "Star: \(detail.star)"
            cell.lbDetail.text = "Rating: \(detail.rating)\nPopularity: \(detail.popularity)\nAlternative: \(detail.alternative)\nAuthor: \(detail.author)\nArtist: \(detail.artist)\nGenre: \(detail.genre)\nType: \(detail.type)\nRelease: \(detail.release)\nStatus: \(detail.status)\nLatest: \(detail.latest)"
            cell.lbSummary.text = "Summary: \(detail.summary)"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChapterTableCell") as! ChapterListTableViewCell
           cell.lbChapter.text = detail.chapter
            return cell
        }
    }
}

extension MangaDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0 {
            //chapter select
        }
    }
}
