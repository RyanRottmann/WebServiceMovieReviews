//
//  MovieReviewsTableViewController.swift
//  Movie Reviews
//
//  Created by DALE MUSSER on 3/4/17.
//  Updated for Xcode 10 and Swift 4.2 on 11/4/18.
//  Updated for Xcode 10.2 and Swift 5 on 4/19/19.
//  Copyright © 2017-2019 Tech Innovator (Dale Musser). All rights reserved.
//

import UIKit

class MovieReviewsTableViewController: UITableViewController, UISearchResultsUpdating {
    //@IBOutlet weak var editTableButton: UIBarButtonItem!
    
    let initialSearchText = "life"

    var searchController: UISearchController!
    let dateFormatter = DateFormatter()
    
    var movieReviews: [MovieReview]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateStyle = .medium
        
        title = "Movie Reviews"
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
        
        let editButtonItem = self.editButtonItem
        self.navigationItem.rightBarButtonItem = editButtonItem
        
        searchController.searchBar.text = initialSearchText
        
        //UINavigationBar.

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

     if(velocity.y>0) {
         //Code will work without the animation block.I am using animation block incase if you want to set any delay to it.
        UIView.animate(withDuration: 2.5, delay: 0, options: UIView.AnimationOptions(), animations: {
             self.navigationController?.setNavigationBarHidden(true, animated: true)
             self.navigationController?.setToolbarHidden(true, animated: true)
             print("Hide")
         }, completion: nil)

     } else {
        UIView.animate(withDuration: 2.5, delay: 0, options: UIView.AnimationOptions(), animations: {
             self.navigationController?.setNavigationBarHidden(false, animated: true)
             self.navigationController?.setToolbarHidden(false, animated: true)
             print("Unhide")
         }, completion: nil)
       }
    }*/
    
    override func viewDidAppear(_ animated: Bool) {
        updateSearchResults(for: searchController!)
    }

    //override func loadView() {
    //    print("view loaded")
    //}
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if let searchText = searchController.searchBar.text {
            
            NYTimesMovieReviews.search(searchText: searchText, userInfo: nil, dispatchQueueForHandler: DispatchQueue.main) {
                (userInfo, movieReviews, errorString) in
                if errorString != nil {
                    // could put a call to an alert here to notify user of issue
                    self.movieReviews = nil
                } else {
                    self.movieReviews = movieReviews
                }
                self.tableView.reloadData()
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieReviews?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieReviewCell", for: indexPath)

        if let cell = cell as? MovieReviewTableViewCell, let movieReview = movieReviews?[indexPath.row] {
            if let imageUrl = URL(string: movieReview.media.srcUrlString),
            let imageData = try? Data(contentsOf: imageUrl) {
                cell.reviewImageView.image = UIImage(data: imageData)
            }
            cell.headlineLabel.text = movieReview.headline
            cell.bylineLabel.text = movieReview.byline
            cell.mpaaRatingLabel.text = movieReview.mpaaRating
            cell.openingDateLabel.text = "Opens: " + dateFormatter.string(from: movieReview.openingDate)
            if (movieReview.criticsPick == 1){
                cell.criticsPickLabel.text = "Critics Pick"
            } else {
                cell.criticsPickLabel.text = nil
            }

        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showMovieReviewSegue", sender: self)
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */


    @IBAction func editTable(_ sender: Any) {
        if (tableView.isEditing) {
            tableView.isEditing = false
            //editTableButton.title = "Edit"
        } else {
            tableView.isEditing = true
            //editTableButton.title = "Done"
        }
    }

    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if let movieReview = movieReviews?[sourceIndexPath.row] {
            movieReviews?.remove(at: sourceIndexPath.row)
            movieReviews?.insert(movieReview, at: destinationIndexPath.row)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            movieReviews?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MovieReviewViewController,
           let indexPath = tableView.indexPathForSelectedRow,
           let numReviews = movieReviews?.count,
           indexPath.row < numReviews,
           let movieReview = movieReviews?[indexPath.row] {
                destination.movieReview = movieReview
        }
        searchController.dismiss(animated: true, completion: {})
    }
}
