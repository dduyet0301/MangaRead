//
//  MangaCache.swift
//  MangaRead
//
//  Created by gem on 7/13/20.
//  Copyright © 2020 gem. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class MangaCache {
    func save(manga: Manga, entity: String) {
        guard let appDel = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDel.persistentContainer.viewContext
        let mangaEntity = NSEntityDescription.entity(forEntityName: entity, in: managedContext)!
        let mangaDataCore = NSManagedObject(entity: mangaEntity, insertInto: managedContext)
        mangaDataCore.setValue(manga.title, forKey: "title")
        mangaDataCore.setValue(manga.image, forKey: "image")
        mangaDataCore.setValue(manga.latestChapter, forKey: "latestChapter")
        mangaDataCore.setValue(manga.url, forKey: "url")
        do {
            try managedContext.save()
            debugPrint("saved")
        } catch {
            debugPrint("could not save")
        }
    }
    
    func get(entity: String) -> [Manga] {
        var arrManga = [Manga]()
        guard let appDel = UIApplication.shared.delegate as? AppDelegate else {
            return arrManga
        }
        let managedContext = appDel.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        do {
            let result = try managedContext.fetch(fetchRequest)
            for manga in result as! [NSManagedObject] {
                let title = manga.value(forKey: "title") as! String
                let image = manga.value(forKey: "image") as! String
                let latestChapter = manga.value(forKey: "latestChapter") as! String
                let url = manga.value(forKey: "url") as! String
                arrManga.append(Manga.init(title: title, image: image, latestChapter: latestChapter, url: url))
            }
        } catch {
            debugPrint("Could not fetch \(error)")
        }
        return arrManga
    }
    
    func delete(mangaTitle: String, entity: String) {
        guard let appDel = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDel.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.predicate = NSPredicate(format: "title == %@", mangaTitle)
        do {
            let results = try managedContext.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                managedContext.delete(objectData)
                try managedContext.save()
            }
        } catch {
            debugPrint("delete error \(error)")
        }
    }
    
    func itemExist(mangaTitle: String, entity: String) -> Bool {
        guard let appDel = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        let managedContext = appDel.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entity)
        fetchRequest.predicate = NSPredicate(format: "title == %@", mangaTitle)
        var results: [NSManagedObject] = []
        do {
            results = try managedContext.fetch(fetchRequest)
        } catch {
            debugPrint("Could not fetch \(error)")
        }
        return results.count > 0
    }
}
