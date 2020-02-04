//
//  NewsTableViewController.swift
//  Plants
//
//  Created by Alexander Supe on 03.02.20.
//

import UIKit

class NewsTableViewController: UITableViewController, XMLParserDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        reloadCells()
    }
    
    func reloadCells() {
        if let path = URL(string: "https://www.theguardian.com/lifeandstyle/gardens/rss"){
            if let parser = XMLParser(contentsOf: path) {
                parser.delegate = self
                parser.parse()
            }
        }
        tableView.reloadData()
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
        if let media = item.media {
            if let url = media[0].url { cell.newsImage.load(url: url) }
            else { cell.newsImage.image = UIImage(systemName: "rectangle.fill")}
        }
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    var items: [Item] = []
    var elementName = String()
    var titleString = String()
    var dateString = String()
    var imageString = String()
    
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "item" {
            titleString = String()
            dateString = String()
            imageString = String()
        }
        self.elementName = elementName
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "E, dd MMM yyyy HH:mm:ss zzz"
            
            let date = dateFormatter.date(from: dateString)
            let item = Item(title: titleString, link: nil, description: nil, pubDate: date, media: [Media(width: nil, url: URL(string: imageString))])
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
            } else if self.elementName == "url" {
                imageString += data
            }
        }
    }

}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if data.isEmpty { DispatchQueue.main.async { self?.image = UIImage(systemName: "rectangle.fill")
                } }
                else { if let image = UIImage(data: data) { DispatchQueue.main.async { self?.image = image } } }
            }
        }
    }
}
