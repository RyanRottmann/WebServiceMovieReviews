//
//  NYTimesMovieReviews.swift
//  Movie Reviews
//
//  Created by DALE MUSSER on 3/4/17.
//  Updated for Xcode 10 and Swift 4.2 on 11/4/18.
//  Updated for Xcode 10.2 and Swift 5 on 4/19/19.
//  Copyright © 2017-2019 Tech Innovator (Dale Musser). All rights reserved.
//
// Go to the NY Times developer portal and create an account
// https://developer.nytimes.com/

// Go to your apps and create a new app
// https://developer.nytimes.com/my-apps
// Choose App Name, Description, and turn on APIs to be used. This app uses the Movie Reviews API. Then Create.

// You are provided with a Key and a Secret. The Key is needed for the request URL.
// Key: ...the key (I have removed my Key from this code. You need your own key.)

// Documentation for Movie Reviews API
// https://developer.nytimes.com/docs/movie-reviews-api/1/overview


import Foundation


class NYTimesMovieReviews {
    // https://api.nytimes.com/svc/movies/v2/reviews/search.json?query=godfather&api-key=yourkey
    // https://api.nytimes.com/svc/movies/v2/reviews/search.json?query=the space between us&api-key=<the_key>
    // note: spaces in urls need to be escaped which is why addingPercentEncoding is used below

    
    static let baseUrlString = "https://api.nytimes.com/svc/movies/v2/reviews/search.json"
    static let apiKey = "9Ep6vtfxF2iAHy9Yg2SBuUy25Y3UeT1G"  //  you need an API key from the NYTimes, please get your own
    // get API key from: https://developer.nytimes.com/
    
    static let allowedCharacterSet = (CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[] ").inverted)
    
    static let dateFormatter = DateFormatter()
    static let dateTimeFormatter = DateFormatter()
    
    /*
    if let escapedString = originalString.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) {
        //do something with escaped string
    }
 */
    
    class func search(searchText: String, userInfo: Any?, dispatchQueueForHandler: DispatchQueue, completionHandler: @escaping (Any?, [MovieReview]?, String?) -> Void) {
        guard let escapedSearchText = searchText.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) else {
            dispatchQueueForHandler.async(execute: {
                completionHandler(userInfo, nil, "problem preparing search text")
            })
            return
        }
        var urlString = String()
        print("Start date is")
        print(startDateText)
        print("End date is")
        print(endDateText)
        
        if (criticsPickVariable == "n"){//don't use critics pick
            
            if(dateFilterHolder == false){//use date filter
                urlString = baseUrlString + "?query=" + escapedSearchText + "&api-key=" + apiKey
            } else{// dont use date filter
                if(disableEndDateHolder == true){// end date disabled; only use start date
                    urlString = baseUrlString + "?query=" + escapedSearchText + "&opening-date=" + startDateText + "&api-key=" + apiKey
                } else{// use start and end date
                    urlString = baseUrlString + "?query=" + escapedSearchText + "&opening-date=" + startDateText + ";" + endDateText + "&api-key=" + apiKey
                }
            }
            
        } else {//use critics pick
            //urlString = baseUrlString + "?query=" + escapedSearchText + "&critics-pick=" + criticsPickVariable + "&api-key=" + apiKey
            if(dateFilterHolder == false){//use date filter
                urlString = baseUrlString + "?query=" + escapedSearchText + "&critics-pick=" + criticsPickVariable + "&api-key=" + apiKey
            } else{// dont use date filter
                if(disableEndDateHolder == true){// end date disabled; only use start date
                    urlString = baseUrlString + "?query=" + escapedSearchText + "&critics-pick=" + criticsPickVariable + "&opening-date=" + startDateText + "&api-key=" + apiKey
                } else{// use start and end date
                    urlString = baseUrlString + "?query=" + escapedSearchText + "&critics-pick=" + criticsPickVariable + "&opening-date=" + startDateText + ";" + endDateText + "&api-key=" + apiKey
                }
            }
        }
        
        
        
        
        print(criticsPickVariable)

        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        
        guard let url = URL(string: urlString) else {
            dispatchQueueForHandler.async(execute: {
                completionHandler(userInfo, nil, "the url for searching is invalid")
            })
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"

        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            
            guard error == nil, let data = data else {
                var errorString = "data not available from search"
                if let error = error {
                    errorString = error.localizedDescription
                }
                dispatchQueueForHandler.async(execute: {
                    completionHandler(userInfo, nil, errorString)
                })
                return
            }
            
            let (movieReviews, errorString) = parse(with: data)
            if let errorString = errorString {
                dispatchQueueForHandler.async(execute: {
                    completionHandler(userInfo, nil, errorString)
                })
            } else {
                dispatchQueueForHandler.async(execute: {
                    completionHandler(userInfo, movieReviews, nil)
                })
            }
        }
        
        task.resume()
    }
    
    class func parse(with data: Data) -> ([MovieReview]?, String?) {
        
        // for debugging: to see json as String printed
        if let jsonString = String(data: data, encoding: String.Encoding.utf8) {
            print(jsonString)
        }
       
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []),
            let rootNode = json as? [String:Any] else {
            return (nil, "unable to parse response from news server")
        }
        
        guard let status = rootNode["status"] as? String, status == "OK" else {
            return (nil, "server did not return OK")
        }
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateTimeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        var movieReviews = [MovieReview]()
        
        if let results = rootNode["results"] as? [[String: Any]] {
            for result in results {
                if let displayTitle = result["display_title"] as? String,
                   let mpaaRating = result["mpaa_rating"] as? String,
                   let criticsPick = result["critics_pick"] as? Int,
                   let byline = result["byline"] as? String,
                   let headline = result["headline"] as? String,
                   let shortSummary = result["summary_short"] as? String,
                   let publicationDateString = result["publication_date"] as? String,
                   let publicationDate = dateFormatter.date(from: publicationDateString),
                   let openingDateString = result["opening_date"] as? String,
                   let openingDate = dateFormatter.date(from: openingDateString),
                   let dateUpdatedString = result["date_updated"] as? String,
                   let dateUpdated = dateTimeFormatter.date(from: dateUpdatedString),
                   let linkNode = result["link"] as? [String:String],
                   let linkType = linkNode["type"],
                   let linkUrlString = linkNode["url"],
                   let linkText = linkNode["suggested_link_text"],
                   let mediaNode = result["multimedia"] as? [String: Any],
                   let mediaType = mediaNode["type"] as? String,
                   let mediaSrcUrlString = mediaNode["src"] as? String,
                   let mediaWidth = mediaNode["width"] as? Int,
                   let mediaHeight = mediaNode["height"] as? Int {
                        let link = Link(type: linkType, urlString: linkUrlString, linkText: linkText)
                        let media = Media(type: mediaType, srcUrlString: mediaSrcUrlString, width: mediaWidth, height: mediaHeight)
                        let movieReview = MovieReview(displayTitle: displayTitle, mpaaRating: mpaaRating, criticsPick: criticsPick, byline: byline, headline: headline, shortSummary: shortSummary, publicationDate: publicationDate, openingDate: openingDate, dateUpdated: dateUpdated, link: link, media: media)
                        movieReviews.append(movieReview)

                }
            }
            
        }
        return (movieReviews, nil)
    }

}
