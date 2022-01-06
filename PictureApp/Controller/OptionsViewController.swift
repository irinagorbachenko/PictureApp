//
//  OptionsViewController.swift
//  PictureApp
//
//  Created by Irina Gorbachenko on 26.11.2021.
//
import UIKit
import NetworkLayer

protocol OptionsViewControllerDelegate : AnyObject {
    func optionsViewController ( didSelectOrderStrategy order: Order)
    func didFilterSelected()
}
enum Order: String{
    case popular
    case latest 
}

class OptionsViewController: UIViewController {
    @IBOutlet var sortButton: UIButton!
    var isTapped :Bool = true
    weak var delegate: PicturesViewController?
    
    @IBAction func sortPictures() {
        self.dismiss (animated: true, completion: nil)
        let order : Order?
        if  isTapped{
            order = Order(rawValue: "latest")
            isTapped = false
        } else {
            order = Order(rawValue: "popular")
            isTapped = true
        }
        delegate?.optionsViewController( didSelectOrderStrategy: order!)
    }
    
    @IBAction func filterPictures(_ sender: Any) {
        delegate?.didFilterSelected()
        self.dismiss (animated: true, completion: nil)
    }
    
}
