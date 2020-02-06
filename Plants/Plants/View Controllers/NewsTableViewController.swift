//
//  NewsTableViewController.swift
//  Plants
//
//  Created by Alexander Supe on 03.02.20.
//

import UIKit

class NewsTableViewController: UITableViewController {
    
    // MARK: - Properties
    let baseURL = URL(string: "https://www.theguardian.com/lifeandstyle/gardens/")!
    var items: [Item] = []
    
    // XMLParserDelegate
    private var elementName = String()
    private var titleString = String()
    private var dateString = String()
    private var imageString = String()
    private var currentImage = String()
    private var urlString = String()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadCells()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        var i = 0
        for item in items {
            fetchImage(item: item, index: i) { self.tableView.reloadData()}
            i += 1
        }
    }
    
    // MARK: - Helper Methods
    private func reloadCells() {
        if let path = URL(string: "https://www.theguardian.com/lifeandstyle/gardens/rss"){
            if let parser = XMLParser(contentsOf: path) {
                parser.delegate = self
                parser.parse()
            }
        }
        tableView.reloadData()
    }
    
    private func fetchImage(item: Item, index: Int, completion: @escaping () -> Void) {
        DispatchQueue.global().async { [weak self] in
            guard let url = item.url else { return }
            if let data = try? Data(contentsOf: url) {
                if !data.isEmpty { DispatchQueue.main.async {
                    self?.items[index].image = data
                    completion()
                    } }
            }
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsTableViewCell
        let item = items[indexPath.row]
        cell.newsTitle.text = item.title
        
        let dateFormatter = RelativeDateTimeFormatter()
        dateFormatter.dateTimeStyle = .named
        if let date = item.pubDate { cell.newsDate.text = dateFormatter.localizedString(for: date, relativeTo: Date()) }
        
        if let data = item.image { cell.newsImage.image = UIImage(data: data) }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIApplication.shared.open(URL(string: items[indexPath.row].link ?? baseURL.absoluteString) ?? baseURL)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

// MARK: - XMLParserDelegate
extension NewsTableViewController: XMLParserDelegate {
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "item" {
            titleString = String()
            dateString = String()
            imageString = String()
            urlString = String()
        }
        else if elementName == "media:content" {
            if let url = attributeDict["url"] { self.currentImage = url }
        }
        self.elementName = elementName
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "E, dd MMM yyyy HH:mm:ss zzz"
            let date = dateFormatter.date(from: dateString)
            let item = Item(title: titleString, link: urlString, description: nil, pubDate: date, url: URL(string: currentImage))
            items.append(item)
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if !data.isEmpty {
            if self.elementName == "title" {
                titleString += data
            } else if self.elementName == "pubDate" {
                dateString += data
            } else if self.elementName == "link" {
                urlString += data
            }
        }
    }
}
