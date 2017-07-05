//
//  DetailViewController.swift
//  SearchStore
//
//  Created by Kai Wang on 2017-07-05.
//  Copyright © 2017 Kai Wang. All rights reserved. 
//

import UIKit

class DetailViewController: UIViewController {

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
}


extension DetailViewController: UIViewControllerTransitioningDelegate {
	func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
		return DimmingPresentationController(presentedViewController: presented, presenting: presenting)
	}
}
