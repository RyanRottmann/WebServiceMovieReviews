//
//  MovieReviewViewController.swift
//  Movie Reviews
//
//  Created by DALE MUSSER on 3/4/17.
//  Updated for Xcode 10 and Swift 4.2 on 11/4/18.
//  Updated for Xcode 10.2 and Swift 5 on 4/19/19.
//  Copyright © 2017-2019 Tech Innovator (Dale Musser). All rights reserved.
//

import UIKit

class MovieReviewViewController: UIViewController {
    @IBOutlet weak var reviewImageView: UIImageView!
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var bylineLabel: UILabel!
    @IBOutlet weak var mpaaRatingLabel: UILabel!
    @IBOutlet weak var openingDateLabel: UILabel!
    @IBOutlet weak var shortSummaryLabel: UILabel!
    @IBOutlet weak var criticsPickLabel: UILabel!
    
    var movieReview: MovieReview?
    
    let dateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateStyle = .medium
        
        title = "Review"

        if let movieReview = movieReview {
            headlineLabel.text = movieReview.headline
            bylineLabel.text = movieReview.byline
            mpaaRatingLabel.text = "Rating: " + movieReview.mpaaRating
            openingDateLabel.text = "Opens: " + dateFormatter.string(from: movieReview.openingDate)
            shortSummaryLabel.text = movieReview.shortSummary
            if(movieReview.criticsPick == 1){
                criticsPickLabel.text = "Critics Pick"
            } else{
                criticsPickLabel.text = ""
            }
            
            if let imageUrl = URL(string: movieReview.media.srcUrlString),
                let imageData = try? Data(contentsOf: imageUrl) {
                reviewImageView.image = UIImage(data: imageData)
            }
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func readReview(_ sender: Any) {
        if let movieReview = movieReview,
            let url = URL(string: movieReview.link.urlString) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

