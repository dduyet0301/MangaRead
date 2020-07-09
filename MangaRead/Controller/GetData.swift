//
//  GetData.swift
//  MangaRead
//
//  Created by gem on 7/6/20.
//  Copyright © 2020 gem. All rights reserved.
//

import Foundation
import SwiftSoup
import SwiftyJSON
import Alamofire

class GetData {
    func fetchLatestManga (_ collectionView: UICollectionView, page: Int) {
        //latest
        Alamofire.request("https://mangapark.net/latest/\(page)", method: .get).responseString { (myResponse) in
            switch myResponse.result {
            case .success:
//                print(myResponse)
                let html = myResponse.result.value
                do{
                    let parse = try SwiftSoup.parse(html!)
                    Contains.arrLatest.removeAll()
                    for item in try parse.getElementsByClass("ls1")[0].getElementsByClass("d-flex flex-row item first") {
                        self.getLatestItem(element: item)
                    }
                    for item in try parse.getElementsByClass("ls1")[0].getElementsByClass("d-flex flex-row item ") {
                        self.getLatestItem(element: item)
                    }
                    for item in try parse.getElementsByClass("ls1")[0].getElementsByClass("d-flex flex-row item  new") {
                        self.getLatestItem(element: item)
                    }
                    for item in try parse.getElementsByClass("ls1")[0].getElementsByClass("d-flex flex-row item  hot") {
                        self.getLatestItem(element: item)
                    }
                    for item in try parse.getElementsByClass("ls1")[0].getElementsByClass("d-flex flex-row item last") {
                        self.getLatestItem(element: item)
                    }
                    for item in try parse.getElementsByClass("ls1")[0].getElementsByClass("d-flex flex-row item last hot") {
                        self.getLatestItem(element: item)
                    }
                     NotificationCenter.default.post(name: NSNotification.Name("reload"), object: nil)
                    collectionView.reloadData()
                    print("fetch latest")
                } catch {
                    debugPrint(error)
                }
                break
            case .failure:
                print("loi \(myResponse.error!)")
                break
            }
        }
    }
    
    func getLatestItem (element: Element) {
        do {
            let title = try element.select("a")[0].attr("title")
            let image = try element.select("a")[0].select("img").attr("src")
            let latestChapter = try element.select("ul").select("li")[0].select("span").select("a").text()
            let url = try element.select("a").attr("href")
//            print("\(title) + \(latestChapter)")
            let manga = Manga(title: title, image: image, latestChapter: latestChapter, url: url)
            Contains.arrLatest.append(manga)
        } catch {
            debugPrint(error)
        }
    }
    
    func fetchPopularManga(_ collectionView: UICollectionView, page: Int) {
        //popular
        Alamofire.request("https://mangapark.net/search?orderby=views&page=\(page)", method: .get).responseString { (myResponse) in
            switch myResponse.result {
            case .success:
//                print(myResponse)
                let html = myResponse.result.value
                do{
                    let parse = try SwiftSoup.parse(html!)
                    Contains.arrPopular.removeAll()
                    for item in try parse.getElementsByClass("manga-list")[0].getElementsByClass("item first") {
                        self.getPopularItem(element: item)
                    }
                    for item in try parse.getElementsByClass("manga-list")[0].getElementsByClass("item hot") {
                         self.getPopularItem(element: item)
                    }
                    for item in try parse.getElementsByClass("manga-list")[0].getElementsByClass("item cmp") {
                         self.getPopularItem(element: item)
                    }
                    for item in try parse.getElementsByClass("manga-list")[0].getElementsByClass("item") {
                         self.getPopularItem(element: item)
                    }
                    for item in try parse.getElementsByClass("manga-list")[0].getElementsByClass("item hot cmp") {
                         self.getPopularItem(element: item)
                    }
                    for item in try parse.getElementsByClass("manga-list")[0].getElementsByClass("item last cmp") {
                         self.getPopularItem(element: item)
                    }
                    collectionView.reloadData()
                    print("fetch popular")
                } catch {
                    debugPrint(error)
                }
                break
            case .failure:
                print("loi \(myResponse.error!)")
                break
            }
        }
    }
    
    func getPopularItem(element: Element) {
        do {
            let title = try element.select("a").select("img").attr("title")
            let image = try element.select("a").select("img").attr("src")
            let latestChapter = try element.select("ul").select("a").select("b").text()
            let url = ""
            let manga = Manga(title: title, image: image, latestChapter: latestChapter, url: url)
            Contains.arrPopular.append(manga)
        } catch {
            debugPrint(error)
        }
    }
    
    func fetchUpdatesManga(_ collectionView: UICollectionView, page: Int) {
        //Update
        Alamofire.request("https://mangapark.net/search?orderby=create&page=\(page)", method: .get).responseString { (myResponse) in
            switch myResponse.result {
            case .success:
                //print(myResponse)
                let html = myResponse.result.value
                do{
                    let parse = try SwiftSoup.parse(html!)
                    Contains.arrUpdates.removeAll()
                    for item in try parse.getElementsByClass("manga-list")[0].getElementsByClass("item first new") {
                        self.getUpdatesItem(element: item)
                    }
                    for item in try parse.getElementsByClass("manga-list")[0].getElementsByClass("item new") {
                       self.getUpdatesItem(element: item)
                    }
                    for item in try parse.getElementsByClass("manga-list")[0].getElementsByClass("item new cmp") {
                        self.getUpdatesItem(element: item)
                    }
                    for item in try parse.getElementsByClass("manga-list")[0].getElementsByClass("item last new cmp") {
                       self.getUpdatesItem(element: item)
                    }
                    collectionView.reloadData()
                    print("fetch updates")
                } catch {
                    debugPrint(error)
                }
                break
            case .failure:
                print("loi \(myResponse.error!)")
                break
            }
        }
    }
    
    func getUpdatesItem(element: Element) {
        do {
            let title = try element.select("a").select("img").attr("title")
            let image = try element.select("a").select("img").attr("src")
            let latestChapter = try element.select("ul").select("a").select("b").text()
            let url = ""
            let manga = Manga(title: title, image: image, latestChapter: latestChapter, url: url)
            Contains.arrUpdates.append(manga)
        } catch {
            debugPrint(error)
        }
    }
    
    func fetchMangaDetail(_ tableView: UITableView, url: String) {
        Alamofire.request("https://mangapark.net\(url)", method: .get).responseString { (myResponse) in
            switch myResponse.result {
            case .success:
                print(myResponse)
                let html = myResponse.result.value
                do{
                    let parse = try SwiftSoup.parse(html!)
                    try self.getDetail(elements: parse.getElementsByClass("container content"))
                    for item in try parse.getElementsByClass("mt-2 volume") {
                        self.getChapterList(element: item)
                    }
                    tableView.reloadData()
                    print("fetch detail")
                } catch {
                    debugPrint(error)
                }
                break
            case .failure:
                print("loi \(myResponse.error!)")
                break
            }
        }
    }
    
    func getDetail(elements: Elements) {
        do {
                let image = try elements.select("div")[1].select("div")[1].attr("src")
                let title = try elements.select("div")[1].select("div")[1].attr("title")
                let star = try elements.select("tbody").select("tr")[0].select("span").select("i").text()
                let rating = try elements.select("tbody").select("tr")[1].select("td").text()
                let popularity = try elements.select("tbody").select("tr")[2].select("td").text()
                let alternative = try elements.select("tbody").select("tr")[3].select("td").text()
                let author = try elements.select("tbody").select("tr")[4].select("a").attr("title")
                let artist = try elements.select("tbody").select("tr")[5].select("a").attr("title")
                let genre = try elements.select("tbody").select("tr")[6].select("td").text()
                let type = try elements.select("tbody").select("tr")[7].select("td").text()
                let summary = try elements.select("p").text()
             if try elements.select("tbody").select("tr")[8].select("th").text() != "Release" {
                let status = try elements.select("tbody").select("tr")[8].select("td").text()
                let latest = try elements.select("tbody").select("tr")[10].select("td").text()
                let mangaDetail = MangaDetail(image: image, title: title, star: star, rating: rating, popularity: popularity, alternative: alternative, author: author, artist: artist, genre: genre, type: type, release: "", status: status, latest: latest, summary: summary, chapter: "")
                Contains.arrMangaDetail.append(mangaDetail)
             } else {
                let release = try elements.select("tbody").select("tr")[8].select("td").text()
                let status = try elements.select("tbody").select("tr")[9].select("td").text()
                let latest = try elements.select("tbody").select("tr")[11].select("td").text()
                let mangaDetail = MangaDetail(image: image, title: title, star: star, rating: rating, popularity: popularity, alternative: alternative, author: author, artist: artist, genre: genre, type: type, release: release, status: status, latest: latest, summary: summary, chapter: "")
                Contains.arrMangaDetail.append(mangaDetail)
            }
        } catch {
            debugPrint(error)
        }
    }
    
    func getChapterList(element: Element) {
        do {
            let chapter = try element.select("div")[0].select("a").text()
            let mangaChapter = MangaDetail(image: "", title: "", star: "", rating: "", popularity: "", alternative: "", author: "", artist: "", genre: "", type: "", release: "", status: "", latest: "", summary: "", chapter: chapter)
            Contains.arrMangaDetail.append(mangaChapter)
        }
        catch {
            debugPrint(error)
        }
    }
}
