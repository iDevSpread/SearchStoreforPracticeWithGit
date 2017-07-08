//
//  DetailViewController.swift
//  SearchStore
//
//  Created by Kai Wang on 2017-07-05.
//  Copyright © 2017 Kai Wang. All rights reserved. 
//

import UIKit

class DetailViewController: UIViewController {

	var searchResult: SearchResult!
	//it should be operated at one ViewController
	
	@IBOutlet weak var popup: UIView!
	@IBOutlet weak var artworkImageView: UIImageView!
	
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var artistNameLabel: UILabel!
	
	@IBOutlet weak var kindLabel: UILabel!
	@IBOutlet weak var genreLabel: UILabel!
	@IBOutlet weak var priceButton: UIButton!
	
	@IBAction func close() {
		dismiss(animated: true, completion: nil)
	}

    override func viewDidLoad() {
        super.viewDidLoad()
				view.tintColor = UIColor(red: 20/255, green: 160/255, blue: 160/255, alpha: 1)
        // Do any additional setup after loading the view.
				popup.layer.cornerRadius = 10
			let gestureRecoginizer = UITapGestureRecognizer(target: self, action: #selector(close))
			gestureRecoginizer.cancelsTouchesInView = false
			gestureRecoginizer.delegate = self
			view.addGestureRecognizer(gestureRecoginizer)
			
			if searchResult != nil {
				updateUI()
			}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		modalPresentationStyle = .custom
		transitioningDelegate = self
	}
	
	
	func updateUI() {
		nameLabel.text = searchResult.name
		if searchResult.artistName.isEmpty {
			artistNameLabel.text = "Unkown"
		} else {
			artistNameLabel.text = searchResult.artistName
		}
		
		kindLabel.text = searchResult.kind
		genreLabel.text = searchResult.genre
	}
}


extension DetailViewController: UIViewControllerTransitioningDelegate {
	func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
		return DimmingPresentationController(presentedViewController: presented, presenting: presenting)
	}
}

// this method can be used in any view which was designed to perform the same animation
extension DetailViewController: UIGestureRecognizerDelegate {
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
		return (touch.view === self.view)
	}
}
