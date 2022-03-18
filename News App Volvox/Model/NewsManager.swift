//
//  NewsManager.swift
//  News App Volvox
//
//  Created by Güney Köse on 17.03.2022.
//

import Foundation

struct NewsManager {
    
    let urlString = "https://newsapi.org/v2/top-headlines?country=tr&apiKey=8e192d3c29924533b8f9f8133714f658"
    var numberOfNews = 0
    
    func performRequest() {
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print("error")
                    return
                }
                if let safeData = data {
                    self.parseJSON(newsData: safeData)
                }
            }
            task.resume()
        }
    }
    func parseJSON(newsData: Data) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(NewsData.self, from: newsData)
            //            let numberOfNews = decodedData.totalResults
            //            viewController.newsNumber = numberOfNews
            //            let title = decodedData.articles![0].title
            //            let description = decodedData.articles![0].description
            print(decodedData.totalResults)
           
        } catch {
            print("error parseJSON")
        }
    }
}
