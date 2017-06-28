//
//  ViewController.swift
//  SearchStore
//
//  Created by Kai Wang on 2017-06-25.
//  Copyright © 2017 Kai Wang. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var tableView: UITableView!
	
	var searchResults: [SearchResult] = []
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

// send search result to show
extension SearchViewController: UISearchBarDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return searchResults.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cellIdentifier = "SearchResultCell"
		var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
		if cell == nil {
			cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
		}
		
		//cell.textLabel!.text = searchResults[indexPath.row]
		let searchResult = searchResults[indexPath.row]
		cell.textLabel!.text = searchResult.name
		cell.detailTextLabel!.text = searchResult.artistName
		return cell
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		searchBar.resignFirstResponder() // it can be used in the UITextView
		searchResults = [] // Perform every result into the variable instances
		for i in 0...2{
			let searchResult = SearchResult()
			searchResult.name = String(format: "Fake Result %d for", i)
			searchResult.artistName = searchBar.text!
			searchResults.append(searchResult)
		}
		tableView.reloadData()
	}
	
	
	// a good UI layout
	func position(for bar: UIBarPositioning) -> UIBarPosition {
		return .topAttached
	}
}

extension SearchViewController: UITableViewDataSource {
	
}

extension SearchViewController: UITableViewDelegate {
	
}
