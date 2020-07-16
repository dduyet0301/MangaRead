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
    let header = ["User-Agent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) coc_coc_browser/86.0.180 Chrome/80.0.3987.180 Safari/537.36",
                  "Cookie":"__cfduid=d29dfbf4fe057a7136a9a11c43c5fac6d1594006102; _ga=GA1.2.599817998.1594006104; set=theme=1&h=1&img_load=1&img_zoom=1&img_tool=1&twin_m=0&twin_c=0&manga_a_warn=1&history=1&timezone=14; _gid=GA1.2.582730129.1594637047; Hm_lvt_5ee99fa43d3e817978c158dfc8eb72ad=1594692758,1594707373,1594778377,1594865776; cf_chl_1=430c027a006e71b; cf_clearance=2287ddf8afee2d3a178e4bdbd695b19d9d413d6d-1594870281-0-1zedb55dafz1ba6e01z809c3d3d-150; Hm_lpvt_5ee99fa43d3e817978c158dfc8eb72ad=1594872942; _gat_gtag_UA_17788005_10=1; __atuvc=256%7C28%2C113%7C29; __atuvs=5f0fca0a5cc6da1d00e"]
    func fetchLatestManga (_ collectionView: UICollectionView, page: Int) {
        //latest
        Alamofire.request("https://mangapark.net/latest/\(page)", method: .get, headers: header).responseString { (myResponse) in
            switch myResponse.result {
            case .success:
//                print(myResponse)
                let html = myResponse.result.value
                do{
                    let parse = try SwiftSoup.parse(html!)
                    Contains.arrLatest.removeAll()
                    for element in try parse.getElementsByClass("ls1")[0].getElementsByClass("item") {
                        self.getLatestItem(element: element)
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
        Alamofire.request("https://mangapark.net/search?orderby=views&page=\(page)", method: .get, headers: header).responseString { (myResponse) in
            switch myResponse.result {
            case .success:
//                print(myResponse)
                let html = myResponse.result.value
                do{
                    let parse = try SwiftSoup.parse(html!)
                    Contains.arrPopular.removeAll()
                    for element in try parse.getElementsByClass("manga-list")[0].getElementsByClass("item") {
                         let popular = self.getPopularAndUpdatesItem(element: element)
                        Contains.arrPopular.append(popular)
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
    
    func getPopularAndUpdatesItem(element: Element) -> Manga {
        do {
            let title = try element.select("a").select("img").attr("title")
            let image = try element.select("a").select("img").attr("src")
            let latestChapter = try element.select("ul").select("a").select("b").text()
            let url = try element.select("h2").select("a").attr("href")
            return Manga(title: title, image: image, latestChapter: latestChapter, url: url)
        } catch {
            debugPrint(error)
            return Manga(title: "", image: "", latestChapter: "", url: "")
        }
    }
    
    func fetchUpdatesManga(_ collectionView: UICollectionView, page: Int) {
        //Update
        Alamofire.request("https://mangapark.net/search?orderby=create&page=\(page)", method: .get, headers: header).responseString { (myResponse) in
            switch myResponse.result {
            case .success:
                //print(myResponse)
                let html = myResponse.result.value
                do{
                    let parse = try SwiftSoup.parse(html!)
                    Contains.arrUpdates.removeAll()
                    for element in try parse.getElementsByClass("manga-list")[0].getElementsByClass("item new") {
                      let updates = self.getPopularAndUpdatesItem(element: element)
                        Contains.arrUpdates.append(updates)
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
    
    func fetchMangaDetail(_ tableView: UITableView, url: String) {
        Alamofire.request("https://mangapark.net\(url)", method: .get, headers: header).responseString { (myResponse) in
            switch myResponse.result {
            case .success:
//                print(myResponse)
                let html = myResponse.result.value
                do{
                    let parse = try SwiftSoup.parse(html!)
                    Contains.mangaDetail.removeDetail()
                    Contains.arrChapter.removeAll()
                    let elements = try parse.getElementsByClass("container content")
                    let element = try parse.getElementsByClass("mt-2 volume")[0]
                    var arrChapter = Contains.arrChapter
                    let image = try elements.select("div")[0].select("div")[0].select("div").select("img").attr("src")
                    let title = try elements.select("div")[2].select("div").select("div").select("img").attr("title")
                    let star = try elements.select("tbody").select("tr")[0].select("i").text()
                    let rating = try elements.select("tbody").select("tr")[1].select("td").text()
                    let popularity = try elements.select("tbody").select("tr")[2].select("td").text()
                    let alternative = try elements.select("tbody").select("tr")[3].select("td").text()
                    let author = try elements.select("tbody").select("tr")[4].select("a").attr("title")
                    let artist = try elements.select("tbody").select("tr")[5].select("a").attr("title")
                    let genre = try elements.select("tbody").select("tr")[6].select("td").text()
                    let type = try elements.select("tbody").select("tr")[7].select("td").text()
                    let summary = try elements.select("p").text()
                    for i in 0...(try element.getElementsByClass("ml-1 visited ch").count - 1) {
                        let chapterName = try element.getElementsByClass("ml-1 visited ch")[i].text()
                        let chapterUrl = try element.getElementsByClass("d-none d-md-block")[i].select("a")[4].attr("href")
                        let chapter = Chapter.init(name: chapterName, url: chapterUrl)
                        arrChapter.append(chapter)
                    }
                    if try elements.select("tbody").select("tr")[8].select("th").text() != "Release" {
                        let status = try elements.select("tbody").select("tr")[8].select("td").text()
                        let latest = try elements.select("tbody").select("tr")[10].select("td").text()
                        Contains.mangaDetail = MangaDetail.init(image: image, title: title, star: star, rating: rating, popularity: popularity, alternative: alternative, author: author, artist: artist, genre: genre, type: type, release: "", status: status, latest: latest, summary: summary, chapters: arrChapter)
                    } else {
                        let release = try elements.select("tbody").select("tr")[8].select("td").text()
                        let status = try elements.select("tbody").select("tr")[9].select("td").text()
                        let latest = try elements.select("tbody").select("tr")[11].select("td").text()
                        Contains.mangaDetail = MangaDetail(image: image, title: title, star: star, rating: rating, popularity: popularity, alternative: alternative, author: author, artist: artist, genre: genre, type: type, release: release, status: status, latest: latest, summary: summary, chapters: arrChapter)
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
    
    func fetchMangaImage(url: String) {
        Alamofire.request("https://mangapark.net\(url)", method: .get, headers: header).responseString { (myResponse) in
            switch myResponse.result {
            case .success:
//                print(myResponse)
                let html = myResponse.result.value
                do{
                    let parse = try SwiftSoup.parse(html!)
                    let data = try parse.select("script")[4].data()
                    let start = data.firstIndex(of: "[")!
                    let end = data.lastIndex(of: "]")!
                    let listImage = data[start...end]
                    let json = try JSON(data: Data(listImage.utf8))
                    if let items = json.array {
                        Contains.arrImage.removeAll()
                        for i in items {
                            Contains.arrImage.append(i["u"].stringValue)
                        }
                    }
                    print("fetch image")
                    NotificationCenter.default.post(name: Notification.Name("reloadImage"), object: nil)
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
    
    func fetchSearchResult(orderBy: String, page: Int) {
        let title = SearchTitleTableViewCell.title
        let author = SearchTitleTableViewCell.author
        let years = SearchViewController.selectedYear
        let status = SearchTitleTableViewCell.status
        var genres = ""
        for i in SearchContentTableViewCell.arrGenreList {
             genres += "\(i),"
        }
        Alamofire.request("https://mangapark.net/search?q=\(title)&autart=\(author)&status=\(status)&years=\(years)&genres=\(genres)&page=\(page)&orderby=\(orderBy)", method: .get, headers: header).responseString { (myResponse) in
            switch myResponse.result {
            case .success:
//                print("ressss \(myResponse)")
                let html = myResponse.result.value
                do{
                    let parsed = try SwiftSoup.parse(html!)
                    Contains.arrSearchResult.removeAll()
                    for element in try parsed.getElementsByClass("item") {
                        let searchResult = self.getPopularAndUpdatesItem(element: element)
                        Contains.arrSearchResult.append(searchResult)
                    }
                    NotificationCenter.default.post(name: Notification.Name("ReloadSearchResult"), object: nil)
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
}
