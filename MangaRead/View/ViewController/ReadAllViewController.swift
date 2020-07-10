//
//  MangaReadViewController.swift
//  MangaRead
//
//  Created by gem on 7/10/20.
//  Copyright © 2020 gem. All rights reserved.
//

import UIKit
import SDWebImage

class ReadAllViewController: UIViewController {
    @IBOutlet weak var pinchGesture: UIPinchGestureRecognizer!
    @IBOutlet weak var tableView: UITableView!
    var url = ""
    let getData = GetData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        getData.fetchMangaImage(tableView,url:url)
    }
    @IBAction func zoom(_ sender: UIPinchGestureRecognizer) {
        sender.view?.transform = (sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale))!
        sender.scale = 1.0
    }
    
}

extension ReadAllViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Contains.arrImage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let img = Contains.arrImage[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableCell", for: indexPath) as! MangaImageTableViewCell
        cell.imgManga.sd_setImage(with: URL(string: img))
        return cell
    }
    
}

extension ReadAllViewController: UITableViewDelegate {
    
}
