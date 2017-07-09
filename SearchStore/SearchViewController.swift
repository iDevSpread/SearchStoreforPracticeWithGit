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
	
	@IBOutlet weak var segmentedControl: UISegmentedControl!
		
	@IBAction func segmentedChanged(_ sender: UISegmentedControl) {
		performSearch()
	}
	var searchResults: [SearchResult] = []
	var hasSearched = false
	var isLoading = false
	var dataTask: URLSessionDataTask?
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		tableView.contentInset = UIEdgeInsetsMake(108, 0, 0, 0)
		var cellNib = UINib(nibName: TableViewCellIdentifiers.searchResultCell, bundle: nil)
		tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.searchResultCell)
		
		
		// make the NothingFoundCell nib generate
		cellNib = UINib(nibName: TableViewCellIdentifiers.nothingFoundCell, bundle: nil)
		tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.nothingFoundCell)
		tableView.rowHeight = 80 // the height is equal to the
		searchBar.becomeFirstResponder()
		
		// make the LoadingCell nib generate
		cellNib = UINib(nibName: TableViewCellIdentifiers.loadingCell, bundle: nil)
		tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.loadingCell)
		
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "ShowDetail" {
			let detailViewController = segue.destination as! DetailViewController
			let indexPath = sender as! IndexPath
			let searchResult = searchResults[indexPath.row]
			detailViewController.searchResult = searchResult
		}
	}

	struct TableViewCellIdentifiers {
		static let searchResultCell = "SearchResultCell"
		static let nothingFoundCell = "NothingFoundCell"
		static let loadingCell = "LoadingCell"
	}
	
	func iTunesURL(searchText: String, category: Int) -> URL {
		let entityName: String
		switch category {
		case 1:
			entityName = "musicTrack"
		case 2:
			entityName = "software"
		case 3:
			entityName = "ebook"
		default:
			entityName = ""
		}
		
		
		let escapedSearchText = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
		let urlString = String(format: "https://itunes.apple.com/search?term=%@&limit=200&entity=%@",escapedSearchText,entityName)
		let url = URL(string: urlString)
		return url!
	}
	
	
	//if the request from the server fails, it returns nil.
	
	
	
	func parse(json data: Data) -> [String: Any]? {
		
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
	
	
	func parse(dictionary: [String: Any]) -> [SearchResult]{
		guard let  array = dictionary["results"] as? [Any] else {
			print("Expected 'result' array")
			return []
		}
		
		var searchResults: [SearchResult] = []
		for resultDict in array {
			if let resultDict = resultDict as? [String: Any] {
				var searchResult: SearchResult?
				
				if let wrapperType = resultDict["wrapperType"] as? String{
					switch wrapperType {
					case "track":
						searchResult = parse(track: resultDict)
					case "audiobook":
						searchResult = parse(audiobook: resultDict)
					case "software":
						searchResult = parse(software: resultDict)
					default:
						break
					}
				} else if let kind = resultDict["kind"] as? String, kind == "ebook" {
					searchResult = parse(ebook: resultDict)
				}
				
				// using the declaration of local instance, searchResult
				if let result = searchResult {
					searchResults.append(result)
				}
			}
			
		}
		
		return searchResults
	}
	
	func parse(track dictionary: [String: Any]) -> SearchResult {
		let searchResult = SearchResult()
		
		searchResult.name = dictionary["trackName"] as! String
		searchResult.artistName = dictionary["artistName"] as! String
		searchResult.artworkSmallURL = dictionary["artworkUrl60"] as! String
		searchResult.artworkLargeURL = dictionary["artworkUrl100"] as! String
		searchResult.storeURL = dictionary["trackViewUrl"] as! String
		searchResult.kind = dictionary["kind"] as! String
		searchResult.currency = dictionary["currency"] as! String
		
		if let price = dictionary["trackPrice"] as? Double {
			searchResult.price = price
		}
		if let genre = dictionary["primaryGenreName"] as? String {
			searchResult.genre = genre
		}
		return searchResult
	}
	
	func parse(audiobook dictionary: [String: Any]) -> SearchResult {
		let searchResult = SearchResult()
		
		searchResult.name = dictionary["collectionName"] as! String
		searchResult.artistName = dictionary["artistName"] as! String
		searchResult.artworkSmallURL = dictionary["artworkUrl60"] as! String
		searchResult.artworkLargeURL = dictionary["artworkUrl100"] as! String
		searchResult.storeURL = dictionary["collectionViewUrl"] as! String
		searchResult.kind = "audiobook"
		searchResult.currency = dictionary["currency"] as! String
		
		if let price = dictionary["trackPrice"] as? Double {
			searchResult.price = price
		}
		if let genre = dictionary["primaryGenreName"] as? String {
			searchResult.genre = genre
		}
		return searchResult
	}
	
	func parse(software dictionary: [String: Any]) -> SearchResult {
		let searchResult = SearchResult()
		
		searchResult.name = dictionary["trackName"] as! String
		searchResult.artistName = dictionary["artistName"] as! String
		searchResult.artworkSmallURL = dictionary["artworkUrl60"] as! String
		searchResult.artworkLargeURL = dictionary["artworkUrl100"] as! String
		searchResult.storeURL = dictionary["trackViewUrl"] as! String
		searchResult.kind = dictionary["kind"] as! String
		searchResult.currency = dictionary["currency"] as! String
		
		if let price = dictionary["trackPrice"] as? Double {
			searchResult.price = price
		}
		if let genre = dictionary["primaryGenreName"] as? String {
			searchResult.genre = genre
		}
		return searchResult
	}
	
	func parse(ebook dictionary: [String: Any]) -> SearchResult {
		let searchResult = SearchResult()
		
		searchResult.name = dictionary["trackName"] as! String
		searchResult.artistName = dictionary["artistName"] as! String
		searchResult.artworkSmallURL = dictionary["artworkUrl60"] as! String
		searchResult.artworkLargeURL = dictionary["artworkUrl100"] as! String
		searchResult.storeURL = dictionary["trackViewUrl"] as! String
		searchResult.kind = dictionary["kind"] as! String
		searchResult.currency = dictionary["currency"] as! String
		
		if let price = dictionary["trackPrice"] as? Double {
			searchResult.price = price
		}
		if let genre: Any = dictionary["genres"] as? String {
			searchResult.genre = (genre as! [String]).joined(separator: ", ")
		}
		return searchResult
	}
	
}

// send search result to show
extension SearchViewController: UISearchBarDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if isLoading{
			return 1
		} else if !hasSearched {
			return 0
		} else if searchResults.count == 0 {
			return 1
		} else{
			return searchResults.count 
		}
		
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		
		//cell.textLabel!.text = searchResults[indexPath.row]
		
		if isLoading {
			let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.loadingCell, for: indexPath)
			let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
			spinner.startAnimating()
			return cell
		}
		else if searchResults.count == 0 {
			return tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.nothingFoundCell, for: indexPath)
		} else {
			let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.searchResultCell, for: indexPath) as! SearchResultCell
			let searchResult = searchResults[indexPath.row]
			cell.nameLabel.text = searchResult.name
			if searchResult.artistName.isEmpty {
				cell.artistNameLabel.text = "Unknown"
			} else {
				cell.artistNameLabel.text = String(format: "%@ (%@)", searchResult.artistName, searchResult.kind)
			}
			
			cell.artistNameLabel.text = searchResult.artistName
			
			return cell
		}
		
		
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		performSearch()
	}
	
	func performSearch() {
		if !searchBar.text!.isEmpty {
			searchBar.resignFirstResponder()
			dataTask?.cancel()
			
			hasSearched = true
			searchResults = []
			
			isLoading = true
			tableView.reloadData()
			
			let url = iTunesURL(searchText: searchBar.text!, category: segmentedControl.selectedSegmentIndex)
			let session = URLSession.shared
			dataTask = session.dataTask(with: url, completionHandler: {
				data, response, error in
			if let error = error as NSError?, error.code == -999 {
				return
			} else if let httpResponse = response as? HTTPURLResponse,
										httpResponse.statusCode == 200 {
				if let data = data, let jsonDictionary = self.parse(json: data) {
					self.searchResults = self.parse(dictionary: jsonDictionary)
					self.searchResults.sort(by: <)
					
					DispatchQueue.main.async {
						self.isLoading = false
						self.tableView.reloadData()
					}
					return
				}
			} else {
				print("Failure! \(response!)")
				}
				
				DispatchQueue.main.async {
					self.hasSearched = false
					self.isLoading = false
					self.tableView.reloadData()
					self.showNetworkError()
				}
			})
			
			
			
			dataTask?.resume()
			
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
		performSegue(withIdentifier: "ShowDetail", sender: indexPath)
	}
	
	func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
		if searchResults.count == 0 || isLoading{
			return nil
		} else {
			return indexPath
		}
	}
	
	
}
