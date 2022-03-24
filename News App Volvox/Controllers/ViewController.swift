//
//  ViewController.swift
//  News App Volvox
//
//  Created by Güney Köse on 17.03.2022.
//

import UIKit
import SDWebImage
import Alamofire

protocol ChangeCountry: AnyObject {
    func changeCountry(location: String)
}

protocol ChangeSubject: AnyObject {
    func changeSubject(topic: String)
}

class ViewController: UIViewController {
    
    @IBOutlet weak var newsCollection: UICollectionView!
    
    var newsNumber = 3
    
    var countryCode = (Locale.current.regionCode)?.lowercased()
    var subject = ""
    var searchin = "top-headlines?"
    
    let decoder = JSONDecoder()
    var newsIndex = 0
    var imageString = ""
    var newsArray: NewsData?
    let device = UIDevice.current.model
    let deviceRegion = Locale.current.regionCode
    let refreshControl = UIRefreshControl()
   
    override func viewDidLoad() {
        super.viewDidLoad()

        newsCollection.delegate = self
        newsCollection.dataSource = self
        
        newsCollection.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "newsCell")
        navigationItem.title = "Volvox News"
        
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        newsCollection.addSubview(refreshControl)
        
        view.backgroundColor = .white
        
        performRequest(country: countryCode!, about: subject)
        
        print(deviceRegion!)
    }

    //MARK: - Networking

    func performRequest(country: String, about: String?) {
        
        var newsLocation = "country=\(country)"
        
        if subject != "" {
            newsLocation = ""
            searchin = "everything?q="
        }
        
        let newsURL = "https://newsapi.org/v2/\(searchin)\(subject)\(newsLocation)&apiKey=ae4692830ee748b9bbfa2ffcaeff369b"
        AF.request(newsURL, method: .get, parameters: nil).response { (response) in
            switch response.result {
            case .success:
                self.parseJSON(newsData: response.data!)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        print(newsURL)
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
    //MARK: - Refresh
    @objc func refresh(_ sender: AnyObject) {
        
        performRequest(country: countryCode!, about: subject)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.refreshControl.endRefreshing()
            
        }
    }
    @IBAction func locationTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "country", sender: nil)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is Countries {
            let destinationVC = segue.destination as! Countries
            destinationVC.delegate = self
            destinationVC.subjectDelegate = self
        }
    }
}
//MARK: - ChangeCountry Protocol
extension ViewController: ChangeCountry {
    func changeCountry(location: String) {
        print("change country works", countryCode as Any)
        countryCode = location
        subject = ""
        searchin = "top-headlines?"
        self.performRequest(country: location, about: subject)
    }
}
extension ViewController: ChangeSubject {
    func changeSubject(topic: String) {
        subject = topic
        self.performRequest(country: countryCode!, about: subject)
    }
}
//MARK: - UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionViewLayout() -> UICollectionViewFlowLayout {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        
        return layout
    }
}
//MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
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
}
//MARK: - UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsArray?.articles?.count ?? 0
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let stroyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let webController = stroyboard.instantiateViewController(withIdentifier: "webController") as? WebController else {
            return
        }
        webController.url = (newsArray?.articles?[indexPath.row].url)!
        navigationController?.pushViewController(webController, animated: true)
    }
}


