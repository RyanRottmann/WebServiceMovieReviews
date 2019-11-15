//
//  MovieReview.swift
//  Movie Reviews
//
//  Created by DALE MUSSER on 3/4/17.
//  Updated for Xcode 10 and Swift 4.2 on 11/4/18.
//  Updated for Xcode 10.2 and Swift 5 on 4/19/19.
//  Copyright © 2017-2019 Tech Innovator (Dale Musser). All rights reserved.
//

import Foundation

var criticsPickVariable = String()
var startDateHolder = Date()
var endDateHolder = Date()
var criticsPickHolder = Bool()
var dateFilterHolder = Bool()
var disableEndDateHolder = Bool()
var startDateText = String()
var endDateText = String()
var firstLoad = 0

struct Link {
    var type: String
    var urlString: String
    var linkText: String
}

struct Media {
    var type: String
    var srcUrlString: String
    var width: Int
    var height: Int
}

struct MovieReview {
    var displayTitle: String
    var mpaaRating: String
    var criticsPick: Int
    var byline: String
    var headline: String
    var shortSummary: String
    var publicationDate: Date
    var openingDate: Date
    var dateUpdated: Date
    var link: Link
    var media: Media
}
