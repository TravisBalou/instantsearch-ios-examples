//
//  CustomSearchableImplementation.swift
//  IS-CustomSource
//
//  Created by Guy Daher on 12/03/2018.
//  Copyright © 2018 Robert Mogos. All rights reserved.
//

import Foundation
import AlgoliaSearch
import InstantSearchCore
import Alamofire

// Search Data Models of the custom backend

public struct ElasticSearchParameters {
    var q: String?
}

public struct ElasticSearchResults {
    var total: Int
    var hits: [[String: Any]]
}

public class ElasticImplementation: SearchTransformer<ElasticSearchParameters, ElasticSearchResults> {
    
    public override func search(_ query: ElasticSearchParameters, searchResultsHandler: @escaping SearchResultsHandler) {
        
        let user = "3nmp9kz7fh"
        let password = "gch2ewzerx"
        
        var headers: HTTPHeaders = [:]
        
        guard let authorizationHeader = Request.authorizationHeader(user: user, password: password) else {
            print("auth header wrong")
            return
        }
        
        headers[authorizationHeader.key] = authorizationHeader.value
        let queryText = query.q ?? ""
        
        Alamofire.request("https://tests-first-sandbox-9472672183.eu-west-1.bonsaisearch.net/concerts/_search?q=\(queryText)&pretty", headers: headers).responseJSON { responseJson in
            
            let result = responseJson.result
            print(result)
            
            if let json = result.value as? [String: Any] {
                let hitsJson = json["hits"] as! [String: Any]
                let total = hitsJson["total"] as! Int
                let hits = hitsJson["hits"] as! [[String: Any]]

                print("Total: \(total)")
                print("hits: \(hits)")
                
                let elasticSearchResults = ElasticSearchResults(total: total, hits: hits)
                searchResultsHandler(elasticSearchResults, nil)
            }
        }
        
    }
    
    // Transforms the Algolia params to custom backend params.
    public override func map(query: Query) -> ElasticSearchParameters {
        let queryText = query.query
        
        return ElasticSearchParameters(q: queryText)
    }
    
    // Transforms the custom backend result to an Algolia result.
    public override func map(results: ElasticSearchResults) -> SearchResults {
        let nbHits = results.total
        let hits = results.hits
        
        return SearchResults(nbHits: nbHits, hits: hits)
    }
}
