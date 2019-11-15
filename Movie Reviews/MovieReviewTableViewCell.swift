//
//  MovieReviewTableViewCell.swift
//  Movie Reviews
//
//  Created by DALE MUSSER on 3/4/17.
//  Updated for Xcode 10 and Swift 4.2 on 11/4/18.
//  Updated for Xcode 10.2 and Swift 5 on 4/19/19.
//  Copyright © 2017-2019 Tech Innovator (Dale Musser). All rights reserved.
//

import UIKit

class MovieReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var reviewImageView: UIImageView!
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var bylineLabel: UILabel!
    @IBOutlet weak var mpaaRatingLabel: UILabel!
    @IBOutlet weak var openingDateLabel: UILabel!
    @IBOutlet weak var criticsPickLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
