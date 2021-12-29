//
//  CheckTableViewCell.swift
//  PictureApp
//
//  Created by Irina Gorbachenko on 08.12.2021.
//
import UIKit

protocol CheckTableViewCellDelegate: AnyObject {
  func checkTableViewCell(_ cell: CheckTableViewCell, didChagneCheckedState checked: Bool)
}

class CheckTableViewCell: UITableViewCell {
     @IBOutlet weak var checkbox: Checkbox!
     @IBOutlet weak var label: UILabel!
     
     weak var delegate: CheckTableViewCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
  
    }
    
    override  func awakeFromNib() {
        contentView.addSubview(checkbox)
        contentView.addSubview(label)
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        checkbox.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        checkbox.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        checkbox.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        checkbox.widthAnchor.constraint(equalToConstant: 27).isActive = true
        checkbox.contentMode = .scaleAspectFit
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.trailingAnchor.constraint(equalTo: checkbox.leadingAnchor,constant: 8).isActive = true
        label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        label.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: 40).isActive = true
        label.numberOfLines = 0
    }
    
    @IBAction func checked(_ sender: Checkbox) {
        delegate?.checkTableViewCell(self, didChagneCheckedState: checkbox.checked)
     }
     
     func set(name: String, checked: Bool) {
        label.text = name
        set(checked: checked)
     }
     
     func set(checked: Bool) {
       checkbox.checked = checked
      
     }

}
