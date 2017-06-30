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
	//@IBOutlet weak var searchBar2: UISearchBar!
	
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
	
	func iTunesURL(searchText: String) -> URL {
		let escapedSearchText = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
		let urlString = String(format: "https://itunes.apple.com/search?term=%@",escapedSearchText)
		let url = URL(string: urlString)
		return url!
	}
	
	
	//if the request from the server fails, it returns nil.
	func performStoreRequest(with url: URL) -> String? {
		do {
			return try String(contentsOf: url, encoding: .utf8)
		} catch  {
			print("Download Error: \(error)")
			return nil
		}
	}
	
	
	func parse(json: String) -> [String: Any]? {
		guard let data = json.data(using: .utf8, allowLossyConversion: false) else {
			return nil
		}
		
		do {
		return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
		} catch  {
			print("JSON error: \(error)")
			return nil
		}
	}
	
	func showNetworkError(){
		let alert = UIAlertController(
			title: "Whoops...",
			message:
			"There is an error reading from the iTunes Store. Please make a new search.",
			preferredStyle: .alert
		)
		
		let action = UIAlertAction(title: "OK", style: .default, handler: nil)
		alert.addAction(action)
		present(alert, animated: true, completion: nil) // present a manul view controller
	}
	
	
	func parse(dictionary: [String: Any]) {
		guard let  array = dictionary["results"] as? [Any] else {
			print("Expected 'result' array")
			return
		}
		
		for resultDict in array {
			if let resultDict = resultDict as? [String: Any] {
				if let wrapperType = resultDict["wrapperType"] as? String,
					let kind = resultDict["kind"] as? String {
					print("wrapperType: \(wrapperType), kind: \(kind)")
				}
			}
		}
		
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
		if !searchBar.text!.isEmpty {
			searchBar.resignFirstResponder()
			hasSearched = true
			searchResults = []
			let url = iTunesURL(searchText: searchBar.text!)
			print("URL: '\(url)'")
			
			if let jsonString = performStoreRequest(with: url) {
				if let jsonDictionary = parse(json: jsonString) {
					print("Dictionary \(jsonDictionary)")
					parse(dictionary: jsonDictionary)
					tableView.reloadData()
					return
				}
				print("Received JSON string '\(jsonString)'")
			}
			
			showNetworkError()
			
		}
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
