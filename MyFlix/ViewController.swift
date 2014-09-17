//
//  ViewController.swift
//  MyFlix
//
//  Created by Scott Liu on 9/12/14.
//  Copyright (c) 2014 Scott. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITabBarDelegate
{
    @IBOutlet weak var DVDBarItem: UITabBarItem!

    @IBOutlet weak var BoxOfficeBarITem: UITabBarItem!
    
    @IBOutlet weak var movieTabBar: UITabBar!
    
    @IBOutlet weak var movieTableView: UITableView!
    
    var movieArray: NSArray?
    //var searchResult: NSArray?
    
    var refreshControl:UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationController?.appearance().backgroundColor = UIColor.greenColor()
        //self.navigationController?.toolbar.barTintColor = UIColor.greenColor()
        
        movieTabBar.selectedItem = DVDBarItem
        
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
        
        var listType = "movies/in_theaters.json?"
        
        if b_showTopRentals {
            listType = "dvds/top_rentals.json?"
        }
  
        let RottenTomatoesURLString = "http://api.rottentomatoes.com/api/public/v1.0/lists/" + listType + "apikey=" + YourApiKey
        
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated:true)
        hud.labelText = "Loading ..."
        
                
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
                
                hud.hide(true)
                
                //MBProgressHUD.hideHUDForView(self.view, animated:true)

            },
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                
                hud.labelText = "Networking Error: " + error.localizedDescription
                
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
        
        /*
        
        dispatch_async(dispatch_get_main_queue(), {
            
            cell.movieImageView.image =  UIImage(data: NSData(contentsOfURL: NSURL(string: imageURL )))
            
        })
        */

        cell.movieImageView.setImageWithURL(NSURL(string: imageURL))
        
        return cell;
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        currentMovie = self.movieArray![indexPath.row] as? NSDictionary
        let cell = tableView.cellForRowAtIndexPath(indexPath) as MovieViewCell
        cellImage = cell.movieImageView.image
        
        //let storyboard do it, so commented out following lines
        
        //let detailsViewController = MovieDetailsViewController()
        //self.navigationController?.pushViewController(detailsViewController, animated: true)
    
    }
   
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem)
    {
        if item == DVDBarItem {
            b_showTopRentals = true;
        } else {
            b_showTopRentals = false;
        }
        
        getMoviesUsingAFNetworking();
    }
    
    
    
   
}

var b_showTopRentals = true;

var cellImage : UIImage?

var currentMovie : NSDictionary?

