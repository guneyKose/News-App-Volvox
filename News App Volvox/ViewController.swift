//
//  ViewController.swift
//  News App Volvox
//
//  Created by Güney Köse on 17.03.2022.
//

import UIKit
import SDWebImage

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var newsCollection: UICollectionView!
    
    var newsNumber = 3
    let urlString = "https://newsapi.org/v2/top-headlines?country=us&apiKey=8e192d3c29924533b8f9f8133714f658"
    let decoder = JSONDecoder()
    
    var newsIndex = 0
    var imageString = ""
    var newsArray: NewsData?
    
    let device = UIDevice.current.model
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performRequest()
        
        newsCollection.delegate = self
        newsCollection.dataSource = self
        
        newsCollection.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "newsCell")
        navigationItem.title = "Volvox News"
        
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        newsCollection.addSubview(refreshControl)
        
    }
    
    //MARK: - CollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return newsArray?.articles?.count ?? 0
        
    }
    
    func collectionViewLayout() -> UICollectionViewFlowLayout {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        
        return layout
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = collectionView.bounds.width
        var height = collectionView.bounds.height
        
        if device == "iPhone" {
            height = height / 2.3
        } else if device == "iPad" {
            width = width / 2.03
            height = height / 3.5
        }
        
        return CGSize(width: width, height: height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newsCell", for: indexPath) as! CollectionViewCell
        
        if let imageURL = newsArray?.articles?[indexPath.row].urlToImage {
            imageString = imageURL
        } else {
            imageString = ""
        }
        
        cell.newsTitle.text = newsArray?.articles![indexPath.row].title
        cell.newsLabel.text = newsArray?.articles![indexPath.row].description
        cell.newsImage.sd_setImage(with: URL(string: imageString), placeholderImage: UIImage(named: "placeholder.png"))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let stroyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let webController = stroyboard.instantiateViewController(withIdentifier: "webController") as? WebController else {
            return
        }
        webController.url = (newsArray?.articles?[indexPath.row].url)!
        navigationController?.pushViewController(webController, animated: true)
    }
    
    //MARK: - Networking
    
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
        
        do {
            let decodedData = try decoder.decode(NewsData.self, from: newsData)
            newsArray = decodedData
            
            DispatchQueue.main.async {
                self.newsCollection.reloadData()
            }
            
        } catch {
            print("error parseJSON")
        }
        
    }
    @objc func refresh(_ sender: AnyObject) {
        performRequest()
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
            self.refreshControl.endRefreshing()
        }
    }
}

