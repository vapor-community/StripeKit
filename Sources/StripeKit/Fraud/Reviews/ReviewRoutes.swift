//
//  ReviewRoutes.swift
//  Stripe
//
//  Created by Andrew Edwards on 3/26/19.
//

import NIO
import NIOHTTP1

public protocol ReviewRoutes {
    /// Approves a `Review` object, closing it and removing it from the list of reviews.
    ///
    /// - Parameter review: The identifier of the review to be approved.
    /// - Parameter expand: An array of properties to expand.
    /// - Returns: A `StripeReview`.
    func approve(review: String, expand: [String]?) -> EventLoopFuture<StripeReview>
    
    /// Retrieves a Review object.
    ///
    /// - Parameter review: The identifier of the review to be retrieved.
    /// - Parameter expand: An array of properties to expand.
    /// - Returns: A `StripeReview`.
    func retrieve(review: String, expand: [String]?) -> EventLoopFuture<StripeReview>
    
    /// Returns a list of `Review` objects that have `open` set to `true`. The objects are sorted in descending order by creation date, with the most recently created object appearing first.
    ///
    /// - Parameter filter: A dictionary that will be used for the query parameters. [See More →](https://stripe.com/docs/api/radar/reviews/list).
    /// - Returns: A `StripeReviewList`.
    func listAll(filter: [String: Any]?) -> EventLoopFuture<StripeReviewList>
    
    /// Headers to send with the request.
    var headers: HTTPHeaders { get set }
}

extension ReviewRoutes {
    func approve(review: String, expand: [String]? = nil) -> EventLoopFuture<StripeReview> {
        return approve(review: review, expand: expand)
    }
    
    func retrieve(review: String, expand: [String]? = nil) -> EventLoopFuture<StripeReview> {
        return retrieve(review: review, expand: expand)
    }
    
    func listAll(filter: [String: Any]? = nil)  -> EventLoopFuture<StripeReviewList> {
        return listAll(filter: filter)
    }
}

public struct StripeReviewRoutes: ReviewRoutes {
    public var headers: HTTPHeaders = [:]
    
    private let apiHandler: StripeAPIHandler
    private let reviews = APIBase + APIVersion + "reviews"
    
    init(apiHandler: StripeAPIHandler) {
        self.apiHandler = apiHandler
    }    
    
    public func approve(review: String, expand: [String]?) -> EventLoopFuture<StripeReview> {
        var body: [String: Any] = [:]
        
        if let expand = expand {
            body["expand"] = expand
        }
        
        return apiHandler.send(method: .POST, path: "\(reviews)\(review)/approve", body: .string(body.queryParameters), headers: headers)
    }
    
    public func retrieve(review: String, expand: [String]?) -> EventLoopFuture<StripeReview> {
        var queryParams = ""
        if let expand = expand {
            queryParams = ["expand": expand].queryParameters
        }
        
        return apiHandler.send(method: .GET, path: "\(reviews)\(review)", query: queryParams, headers: headers)
    }
    
    public func listAll(filter: [String: Any]?) -> EventLoopFuture<StripeReviewList> {
        var queryParams = ""
        if let filter = filter {
            queryParams = filter.queryParameters
        }
        return apiHandler.send(method: .GET, path: reviews, query: queryParams, headers: headers)
    }
}
