//
//  PreviewViewController.swift
//  PictureApp
//
//  Created by Irina Gorbachenko on 04.12.2021.
//

import UIKit
import NetworkLayer

class PreviewViewController: UIViewController {

    @IBOutlet private weak var imageViewPreview: UIImageView!
    @IBOutlet var tagsLabel: UILabel!
    
    var selectedPicture: Post?
    var tagText : String?
    
    
    @IBAction func sharePics(_ sender: Any) {
         
        let image = imageViewPreview.image
        let text = tagsLabel.text
        
        var share = [Any]()
        share.append(image)
        share.append(text)
        
        let shareController = UIActivityViewController(activityItems: share, applicationActivities: nil)
        present(shareController, animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        guard let selectedPicture = selectedPicture else {
            return
        }
        guard let tagText = tagText else {
            return
        }

        
        configureUI(with: selectedPicture, tagText: tagText)
     
    }
        
    
    func configureUI (with selectedPicture : Post ,tagText:String){
        
        self.selectedPicture = selectedPicture
        self.tagText =  tagText
        
        
        guard isViewLoaded else {
            return
        
    }
        
        guard let url = URL(string:selectedPicture.image) else { return }
        
            ImageLoader(with: URLHTTPClient(session: URLSession.shared)).load(from: url) { (image) in
                DispatchQueue.main.async {
                self.imageViewPreview.image = image
                self.tagsLabel.text = tagText
                }
            
        }
}
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       
    }

   
}


