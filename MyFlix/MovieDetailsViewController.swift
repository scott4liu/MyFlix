//
//  MovieDetailsViewController.swift
//  MyFlix
//
//  Created by Scott Liu on 9/12/14.
//  Copyright (c) 2014 Scott. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       //println(currentMovie)
        if let movie = currentMovie {
            
            let posters = movie["posters"] as NSDictionary
            
            let imageURL = posters["original"] as NSString
            
            dispatch_async(dispatch_get_main_queue(), {
                
                self.movieImageView.image =  UIImage(data: NSData(contentsOfURL: NSURL(string: imageURL )))
                
            })

        
            self.title =  movie["title"] as NSString
            
            var year = " (" + String(movie["year"] as NSInteger) + ")"
            
            self.titleLabel.text =  movie["title"] as String + year
            
            let ratings =  movie["ratings"] as NSDictionary
        
            let s1 = ratings["critics_score"] as? NSInteger
            let s2 = ratings["audience_score"] as? NSInteger
            
            var score = ""
            if (s1 != nil) {
                score = "Critics Score: " + String(s1!) + ", "
            }
            
            if s2 != nil  {
                score =  score + "Audience Score: " + String(s2!)
            }
            
            self.scoreLabel.text =   score
            
            
        
            self.ratingLabel.text = movie["mpaa_rating"] as? String

            self.synopsisLabel.text = movie["synopsis"] as? String
            
            self.synopsisLabel.sizeToFit()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
