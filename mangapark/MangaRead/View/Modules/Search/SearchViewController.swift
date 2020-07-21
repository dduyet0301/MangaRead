//
//  SearchViewController.swift
//  MangaReadSearch1TableViewCell
//
//  Created by gem on 7/14/20.
//  Copyright © 2020 gem. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    public static var selectedYear = ""
    public static var selectedGenre = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name("ReloadSearchViewController"), object: nil)
    }
    
    @IBAction func toSearchResult(_ sender: Any) {
        let search = storyboard?.instantiateViewController(withIdentifier: "SearchResultViewController")
        navigationController?.pushViewController(search!, animated: true)
    }
    
    @objc func reload() {
        tableView.reloadData()
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTitleTableViewCell", for: indexPath) as! SearchTitleTableViewCell
            cell.selectionStyle = .none
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchReleaseTableViewCell", for: indexPath) as! SearchReleaseTableViewCell
            cell.lbRelease.text = SearchViewController.selectedYear
            cell.selectionStyle = .none
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchGenreTableViewCell", for: indexPath) as! SearchGenreTableViewCell
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchContentTableViewCell", for: indexPath) as! SearchContentTableViewCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 150
        } else if indexPath.row == 3 {
            return 800
        } else {
            return 60
        }
    }
    
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            //to release year list
            let releaseYear = storyboard?.instantiateViewController(withIdentifier: "ReleaseYearViewController") as! ReleaseYearViewController
            navigationController?.pushViewController(releaseYear, animated: true)
        } else if indexPath.row == 2 {
            //to genre list
            let genreList = storyboard?.instantiateViewController(withIdentifier: "GenreListViewController") as! GenreListViewController
            navigationController?.pushViewController(genreList, animated: true)
        }
    }
}
