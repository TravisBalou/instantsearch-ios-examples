//
//  ViewController.swift
//  IS-CustomSource
//
//  Created by Robert Mogos on 06/10/2017.
//  Copyright © 2017 Robert Mogos. All rights reserved.
//

import UIKit
import InstantSearch
import InstantSearchCore

class ViewController: UIViewController, HitsTableViewDataSource {

  var hitsController: HitsController!
  var instantSearch: InstantSearch!
  var searchBar: SearchBarWidget!
  
  lazy var tableView: HitsTableWidget = {
    HitsTableWidget(frame: .zero, style: .plain)
  }()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    searchBar = SearchBarWidget(frame: .zero)
    
    self.navigationItem.titleView = searchBar
    self.edgesForExtendedLayout = []
    tableView.frame = self.view.frame
    self.view.addSubview(tableView)
    hitsController = HitsController(table: tableView)
    tableView.dataSource = hitsController
    tableView.delegate = hitsController
    hitsController.tableDataSource = self
    configureInstantSearch()
    
    tableView.estimatedRowHeight = 80
  }
  
  func configureInstantSearch() {
    
    // Initialising an Index
    
    //let index = CustomSearchableImplementation()
    let index = ElasticImplementation()
    
    let searcher = Searcher(index: index)
    instantSearch = InstantSearch.init(searcher: searcher)
    instantSearch.registerAllWidgets(in: self.view)
    instantSearch.register(widget: searchBar)
  }
    
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, containing hit: [String: Any]) -> UITableViewCell {
    var cell = tableView.dequeueReusableCell(withIdentifier: "cellID")
    if cell == nil {
        cell = UITableViewCell(style: .value1, reuseIdentifier: "cellID")
    }
    
    let source = hit["_source"] as! [String: Any]
    
    let name = source["name"] as! String
    let location = source["location"] as! String
    
    cell!.textLabel?.text = name
    cell!.detailTextLabel?.text = location
    
    return cell!
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}
