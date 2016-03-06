//
//  FlicksViewController.swift
//  flicks
//
//  Created by Vincent Le on 1/15/16.
//  Copyright © 2016 Vincent Le. All rights reserved.
//

import UIKit
import AFNetworking
import PKHUD
import MBProgressHUD
import Cosmos
import SWRevealViewController

class FlicksViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITabBarDelegate, UISearchBarDelegate, UIScrollViewDelegate{
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var tabBar: UITabBar!
    var movies: [NSDictionary]?
    var filteredData: [NSDictionary]?
    var video_key: NSDictionary?
    var load_movie: DarwinBoolean = false
    var genre_list: [NSDictionary]?
    var genre_type: Int?
    
    @IBOutlet weak var hamButton: UIBarButtonItem!
    @IBOutlet weak var popupView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var rating: CosmosView!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var ytView: UIWebView!
    @IBOutlet weak var popupContentView: UIView!
    @IBOutlet weak var genreListLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        if self.revealViewController() != nil {
            hamButton.target = self.revealViewController()
            hamButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.revealViewController().rearViewRevealWidth = 170
        }
        
        collectionView.dataSource = self
        collectionView.delegate = self
        tabBar.delegate = self
        searchBar.delegate = self
        popupView.delegate = self
        fetchMovies("movie/now_playing")
        fetchGenres()
        filteredData = movies
        
       
       
        
        tabBar.selectedItem = tabBar.items![0] as UITabBarItem
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        collectionView.insertSubview(refreshControl, atIndex: 0)
        
        popupView.layer.cornerRadius = 10

    }

    func setupPopup(movie: NSDictionary) {
        popupView.contentSize = CGSizeMake(popupView.bounds.width, 733)
        titleLabel.text = movie["title"] as! String
        overviewLabel.text = movie["overview"] as! String
        genreListLabel.text = ""
        let id = movie["id"]
  
        overviewLabel.sizeToFit()
        rating.settings.fillMode = .Precise
        rating.settings.updateOnTouch = false
        rating.rating = (movie["vote_average"] as! Double) / 2
        
        if let genres = movie["genre_ids"] as! [Int]? {
            var counter = 0;
            for i in genres {
                counter += 1;
                if genres.count == 1 {
                    genreListLabel.text = genreListLabel.text! + "\(findGenre(i))";

                }
                else if counter == genres.count {
                    genreListLabel.text = genreListLabel.text! + "and \(findGenre(i))";
                }
                else if counter == genres.count - 1 {
                    genreListLabel.text = genreListLabel.text! + "\(findGenre(i)) ";
                }
                else {
                    genreListLabel.text = genreListLabel.text! + "\(findGenre(i)), ";
                }
            }
        }
        
        
        if let posterPath = movie["poster_path"] as? String {
            let smallBaseUrl = "http://image.tmdb.org/t/p/w500"
            let largeBaseUrl = "http://image.tmdb.org/t/p/original"
            let smallImageRequest = NSURLRequest(URL: NSURL(string: smallBaseUrl + posterPath)!)
            let largeImageRequest = NSURLRequest(URL: NSURL(string: largeBaseUrl + posterPath)!)
            
        
            self.posterView.setImageWithURLRequest(
                smallImageRequest,
                placeholderImage: nil,
                success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
                    self.posterView.alpha = 0.0
                    self.posterView.image = smallImage
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        self.posterView.alpha = 1.0
                        }, completion: { (sucess) -> Void in
                            self.posterView.setImageWithURLRequest(
                                largeImageRequest,
                                placeholderImage: smallImage,
                                success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                                    self.posterView.image = largeImage;
                                },
                                
                                failure: { (imageRequest, imageResponse, error) -> Void in
                                    self.posterView.image = nil
                            })
                    })
                },
                failure: { (imageRequest, imageResponse, error) -> Void in
                    self.posterView.image = nil
            })
            
            posterView.layer.cornerRadius = 10.0
            posterView.clipsToBounds = true
            
        }
        else {
            self.posterView.image = nil
        }
        
        let api_key = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(id!)/videos?api_key=\(api_key)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            self.video_key = responseDictionary
                            self.setPopupVideo()
                            
                    }
                }
        });
        task.resume()
    
        ytView.layer.cornerRadius = 10.0
        popupContentView.frame.size = CGSize(width: popupView.frame.width, height: overviewLabel.frame.height + 588)
    }
    func setPopupVideo() {
        let key_array = video_key!.valueForKeyPath("results.key") as! [String]
        if key_array.count > 0 {
            let key = key_array.first! as String
            let path = "https://www.youtube.com/embed/\(key)"
            let yt_url = NSURL(string: path)
            
            let yt_url_request = NSURLRequest(URL: yt_url!)
            ytView.loadRequest(yt_url_request)
        }
        
    }

    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let data = filteredData {
            return data.count
        }
        else {
            return 0
        }
    }
    func filterByGenre(genre_id: Int){
        for data in filteredData! {
            let list = data["genre_ids"] as! [Int]
            if !list.contains(genre_id) {
                let index = filteredData!.indexOf(data)
                filteredData!.removeAtIndex(index!)
            }
        }
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        let movie = filteredData![indexPath.row]
        let movie_genre = movie["genre_ids"]
        if let posterPath = movie["poster_path"] as? String {
            let posterBaseUrl = "http://image.tmdb.org/t/p/w500"
            let imageRequest = NSURLRequest(URL: NSURL(string: posterBaseUrl + posterPath)!)
            cell.posterView.setImageWithURLRequest(
                imageRequest,
                placeholderImage: nil,
                success: { (imageRequest, imageResponse, image) -> Void in
                    if imageResponse != nil {
                        cell.posterView.alpha = 0.0
                        cell.posterView.image = image
                        UIView.animateWithDuration(0.3, animations: { () -> Void in
                            cell.posterView.alpha = 1.0
                        })
                    } else {
                        cell.posterView.image = image
                    }
                },
                failure: { (imageRequest, imageResponse, error) -> Void in
                   self.movieHasNilPoster(cell)
            })
            
        }
        else {
             self.movieHasNilPoster(cell)
        }
        return cell
    }
    
    func movieHasNilPoster(cell: MovieCell!) {
        cell.posterView.image = UIImage(named: "poster-coming-soon.jpg")
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let movie = filteredData![indexPath.row]
        setupPopup(movie)
        coverView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        coverView.hidden = false
        popupView.hidden = false
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredData = movies
        } else {
            filteredData = movies?.filter({ (movie: NSDictionary) -> Bool in
                if let title = movie["title"] as? String {
                    return title.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
                }
                return false
            })
        }
        collectionView.reloadData()
    }
    
    @IBAction func onCoverViewClicked(sender: AnyObject) {
        coverView.hidden = true
        popupView.hidden = true
        posterView.image = nil
        popupView.setContentOffset(CGPointMake(0, 0), animated: true)
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        fetchMovies(toSnakeCase(tabBar.selectedItem!.title as String!))
        self.collectionView.reloadData()
        refreshControl.endRefreshing()
    }

    func fetchMovies(type: String) {
        let api_key = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/\(type)?api_key=\(api_key)")
        //print(url)
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            MBProgressHUD.hideHUDForView(self.view, animated: true)
                            if let movies = responseDictionary["results"] as? [NSDictionary] {
                                self.movies = movies
                                self.filteredData = self.movies
                                self.collectionView.reloadData()
                                if self.genre_type != nil && self.genre_type != 999999 {
                                    self.filterByGenre(self.genre_type!)
                                }
                                else if self.genre_type == 999999 {
                                    self.filteredData = self.movies
                                }
                            }
                    }
                }
        });
        task.resume()
    }
    
    
    func fetchGenres() {
        let api_key = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/genre/movie/list?api_key=\(api_key)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            self.genre_list = responseDictionary["genres"] as! [NSDictionary]
                    }
                }
        });
        task.resume()
    }

    func findGenre(id: Int) -> String {
        for genre in genre_list! {
            if genre["id"] as! Int == id {
                return genre["name"] as! String;
            }
        }
        return "Genre not found"
    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        collectionView.hidden = false
        let path = toSnakeCase(item.title as String!)
        fetchMovies("movie/\(path)")
        collectionView.reloadData()
        
        
    }
    

    func toSnakeCase(str: String) -> String {
        return str.lowercaseString.stringByReplacingOccurrencesOfString(" ", withString: "_")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}