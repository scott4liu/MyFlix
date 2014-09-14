//
//  ViewController.swift
//  MyFlix
//
//  Created by Scott Liu on 9/12/14.
//  Copyright (c) 2014 Scott. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{

    @IBOutlet weak var movieTableView: UITableView!
    
    var movieArray: NSArray?
    //var searchResult: NSArray?
    
    var refreshControl:UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Refreshing ...")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.movieTableView.addSubview(refreshControl)
        
        //getMovies()
        getMoviesUsingAFNetworking();
    }
    
    func getMoviesUsingAFNetworking()
    {
        
        let YourApiKey = "rcb4xukpaf7u35w5qr6p2b5c"
        let RottenTomatoesURLString = "http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=" + YourApiKey
        
        let manager = AFHTTPRequestOperationManager()
        manager.GET(
            RottenTomatoesURLString,
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation!,
                responseObject: AnyObject!) in
                //println("JSON: " + responseObject.description)
                
                var errorValue: NSError? = nil
                let dictionary = responseObject as Dictionary<String, AnyObject>
                
                self.movieArray = dictionary["movies"] as? NSArray
                
                //println(self.movieArray)
                
                self.movieTableView.reloadData()

            },
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                println("Error: " + error.localizedDescription)
        })
    }
    
    /*
    func getMovies()
    {
        let YourApiKey = "rcb4xukpaf7u35w5qr6p2b5c"
        let RottenTomatoesURLString = "http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=" + YourApiKey
        let request = NSMutableURLRequest(URL: NSURL(string: RottenTomatoesURLString))
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response, data, error) in
            var errorValue: NSError? = nil
            
            if (error != nil) {
                println(error);
            } else {
                
                let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &errorValue) as NSDictionary
                
                self.movieArray = dictionary["movies"] as? NSArray
                
                //println(self.movieArray)
                
                self.movieTableView.reloadData()
                
                //println("ok");
            }
            
        })

    }
    */
    
    func refresh(sender:AnyObject)
    {
        getMoviesUsingAFNetworking();
        self.refreshControl.endRefreshing()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*
        if self.movieTableView == self.searchDisplayController?.searchResultsTableView {
            if self.searchResult != nil {
                return self.searchResult!.count
            }
        } else {*/
        
            if self.movieArray != nil {
                return self.movieArray!.count
            }
       // }
        
        return 0;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = movieTableView.dequeueReusableCellWithIdentifier("MyFlix.MovieViewCell") as MovieViewCell
        
        let movie = self.movieArray![indexPath.row] as NSDictionary
        
        cell.movieTitle.text = movie["title"] as NSString
        cell.movieDescription.text = movie["synopsis"] as NSString
        cell.ratingLabel.text = movie["mpaa_rating"] as NSString
        cell.yearLabel.text = String(movie["year"] as NSInteger)
        
        let posters = movie["posters"] as NSDictionary
        
        let imageURL = posters["thumbnail"] as NSString
        
        //println(imageURL);
        
        
        dispatch_async(dispatch_get_main_queue(), {
            
            cell.movieImageView.image =  UIImage(data: NSData(contentsOfURL: NSURL(string: imageURL )))
            
        })

        
        return cell;
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        currentMovie = self.movieArray![indexPath.row] as? NSDictionary
        
        //let storyboard do it, so commented out following lines
        
        //let detailsViewController = MovieDetailsViewController()
        //self.navigationController?.pushViewController(detailsViewController, animated: true)
    
    }
   
    
   
}

var currentMovie : NSDictionary?

