//
//  NewsController.swift
//  Plants
//
//  Created by Alexander Supe on 03.02.20.
//

import Foundation
import CoreData

class NewsController {
    
    private let baseURL = URL(string: "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fwww.theguardian.com%2Flifeandstyle%2Fgardens%2Frss")!
    
    public var news: [News] = []
    
    func getNews(completion: @escaping (Error?) -> Void) {
        
        URLSession.shared.dataTask(with: baseURL) { (data, _, error) in
            if let error = error { NSLog("error: \(error)"); DispatchQueue.main.async { completion(error)}; return }
            guard let data = data else { NSLog("no data"); DispatchQueue.main.async { completion(NSError())}; return }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-dd-MM hh:mm:ss"
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            
            do {
                let news = try decoder.decode(NewsArticles.self, from: data).items
                self.news = news
                DispatchQueue.main.async { completion(nil) }
            }
            catch { NSLog("decoding error: \(error)"); DispatchQueue.main.async {  completion(error) }}
        }.resume()
    }
    
    func getImages(completion: @escaping (Error?) -> Void) {
        var i = 0
        for news in self.news {
            guard let url = URL(string: news.enclosure?.link ?? "") else { continue }
            URLSession.shared.dataTask(with: url) { (data, _, error) in
                if let error = error { NSLog("error: \(error)"); DispatchQueue.main.async { completion(error)}; return }
                guard let data = data else { NSLog("no data"); DispatchQueue.main.async { completion(NSError())}; return }
                self.news[i].image = data
                i += 1
                DispatchQueue.main.async { completion(nil) }
            }.resume()
        }
        
    }
}
