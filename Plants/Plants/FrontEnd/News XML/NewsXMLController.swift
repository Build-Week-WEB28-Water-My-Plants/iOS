////
////  NewsXMLController.swift
////  Plants
////
////  Created by Alexander Supe on 03.02.20.
////
//
//import Foundation
//import UIKit
//
//class NewsXMLController: UITableViewController, XMLParserDelegate {
//    var items: [Item] = []
//    var elementName = String()
//    var title = String()
//
//    init() {
//        if let path = URL(string: "https://www.theguardian.com/lifeandstyle/gardens/rss"){
//            if let parser = XMLParser(contentsOf: path) {
//                parser.delegate = self
//                parser.parse()
//            }
//        }
//    }
//
//    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
//        if elementName == "item" {
//            title = String()
//        }
//        self.elementName = elementName
//    }
//
//    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
//        if elementName == "item" {
//            let item = Item(title: title, link: nil, description: nil, pubDate: nil, media: nil)
//            items.append(item)
//        }
//    }
//
//    func parser(_ parser: XMLParser, foundCharacters string: String) {
//        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
//
//        if !data.isEmpty {
//            if self.elementName == "title" {
//                title += data
//            }
//        }
//        print(items)
//    }
//
//}
