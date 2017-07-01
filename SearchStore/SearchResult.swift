//
//  SearchResult.swift
//  SearchStore
//
//  Created by Kai Wang on 2017-06-27.
//  Copyright © 2017 Kai Wang. All rights reserved.
//

class SearchResult {
	var name = ""
	var artistName = ""
	var artworkSmallURL = ""
	var artworkLargeURL = ""
	var storeURL = ""
	var kind = ""
	var currency = ""
	var price = 0.0
	var genre = ""
}

func < (lhs:SearchResult, rhs: SearchResult) -> Bool {
	return lhs.name.localizedStandardCompare(rhs.name) == .orderedAscending
}
