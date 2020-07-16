//
//  GenreListViewController.swift
//  MangaRead
//
//  Created by gem on 7/14/20.
//  Copyright © 2020 gem. All rights reserved.
//

import UIKit

class GenreListViewController: UIViewController {
    public static let arrGenre = ["4-komaAction", "Action", "Adaptation", "Adult", "Adventure", "Aliens", "Animals", "Anthology", "Award-winning", "Comedy", "Cooking", "Crime", "Crossdressing","Delinquents", "Demons", "Doujinshi", "Drama", "Ecchi", "Fan colored", "Fantasy", "Food", "Full color", "Game", "Gender-bender", "Genderswap", "Ghosts", "Gore", "Gossip", "Gyaru", "Harem", "Historical", "Horror", "Incest", "Isekai", "Josei", "Kids", "Loli", "Lolicon", "Long strip", "Mafia", "Magic", "Magical-girls", "Manhwa", "Martial-arts", "Mature", "Mecha", "Medical", "Military", "Monster-girls", "Monsters", "Music", "Mystery", "Ninja", "Office-workers", "Official-colored", "One-shot", "Parody", "Philosophical", "Police", "Post-apocalyptic", "Psychological", "Reincarnation", "Reverse-harem", "Romance", "Samurai", "School-life", "Sci-fi", "Seinen", "Shota", "Shotacon", "Shoujo", "Shoujo-ai", "Shounen", "Shounen-ai", "Slice-of-life", "Smut", "Space", "Sports", "Super-power", "Superhero", "Supernatural", "Survival", "Suspense", "Thriller", "Time-travel", "Toomics", "Traditional-games", "Tragedy", "User-created", "Vampire", "Vampires", "Video-games", "Virtual-reality", "Web-comic", "Webtoon", "Wuxia", "Yaoi", "Yuri", "Zombies"]
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension GenreListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GenreListViewController.arrGenre.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenreCollectionViewCell", for: indexPath) as! GenreCollectionViewCell
        let genreItem = GenreListViewController.arrGenre[indexPath.row]
        cell.lbGenre.text = genreItem
        if SearchContentTableViewCell.arrGenreList.contains(genreItem) {
            cell.lbGenre.textColor = .red
        } else {
            cell.lbGenre.textColor = .black
        }
        return cell
    }
}

extension GenreListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let genreItem = GenreListViewController.arrGenre[indexPath.row]
        SearchContentTableViewCell.genre = genreItem
        if !SearchContentTableViewCell.arrGenreList.contains(genreItem) {
            SearchContentTableViewCell.arrGenreList.append(SearchContentTableViewCell.genre)
        } else {
            if let index = SearchContentTableViewCell.arrGenreList.firstIndex(of: GenreListViewController.arrGenre[indexPath.row]) {
                SearchContentTableViewCell.arrGenreList.remove(at: index)
            }
            //            guard let index = SearchContentTableViewCell.arrGenreList.firstIndex(of: GenreListViewController.arrGenre[indexPath.row]) else {return}
            //            SearchContentTableViewCell.arrGenreList.remove(at: index)
        }
        collectionView.reloadData()
        NotificationCenter.default.post(name: Notification.Name("ReloadSearchContent"), object: nil)
    }
}
