//
//  OptionsViewController.swift
//  PictureApp
//
//  Created by Irina Gorbachenko on 26.11.2021.
//
import UIKit
import NetworkLayer

protocol OptionsViewControllerDelegate : AnyObject {
    func optionsViewController (didSelectOrderStrategy order: Order)
    func didFilterSelected()
}

enum Order: String {
    case popular
    case latest
}

class OptionsViewController: UIViewController {
    @IBOutlet var sortButton: UIButton!
    weak var delegate: PicturesViewController?
    var order = Order.popular
    var invertedOrder :Order {
        switch order {
        case .popular:
            return .latest
        case .latest:
            return .popular
        }
    }
    
    @IBAction func sortPictures() {
        switch order {
        case .popular:
            order = .latest
        case .latest:
            order = .popular
        }
        delegate?.optionsViewController(didSelectOrderStrategy: order)
        self.dismiss (animated: true, completion: nil)
    }
    
    @IBAction func filterPictures(_ sender: Any) {
        delegate?.didFilterSelected()
        self.dismiss (animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sortButton.setTitle(invertedOrder.rawValue.capitalized, for: .normal)
    }
}
