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
	var hasSearched = false
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
		var cellNib = UINib(nibName: TableViewCellIdentifiers.searchResultCell, bundle: nil)
		tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.searchResultCell)
		
		
		// make the NothingFoundCell nib generate
		cellNib = UINib(nibName: TableViewCellIdentifiers.nothingFoundCell, bundle: nil)
		tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.nothingFoundCell)
		tableView.rowHeight = 80 // the height is equal to the
		searchBar.becomeFirstResponder()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


	struct TableViewCellIdentifiers {
		static let searchResultCell = "SearchResultCell"
		static let nothingFoundCell = "NothingFoundCell"
	}
	
}

// send search result to show
extension SearchViewController: UISearchBarDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if !hasSearched {
			return 0
		}else if searchResults.count == 0 {
			return 1
		} else{
			return searchResults.count
		}
		
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		
		//cell.textLabel!.text = searchResults[indexPath.row]
		
		
		if searchResults.count == 0 {
			return tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.nothingFoundCell, for: indexPath)
		} else {
			let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.searchResultCell, for: indexPath) as! SearchResultCell
			let searchResult = searchResults[indexPath.row]
			cell.nameLabel.text = searchResult.name
			cell.artistNameLabel.text = searchResult.artistName
			return cell
		}
		
		
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		searchBar.resignFirstResponder() // it can be used in the UITextView
		searchResults = [] // Perform every result into the variable instances
		
		
		if searchBar.text! != "Justin bieber" {
			for i in 0...2{
				let searchResult = SearchResult()
				searchResult.name = String(format: "Fake Result %d for", i)
				searchResult.artistName = searchBar.text!
				searchResults.append(searchResult)
			}
		}
		hasSearched = true
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
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
		if searchResults.count == 0{
			return nil
		} else {
			return indexPath
		}
	}
	
	
}
