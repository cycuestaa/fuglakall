//
//  Results.swift
//  SoundClassifier
//
//  Created by Camila Y Cuesta Arcentales on 3/18/21.
//  Copyright © 2021 M'haimdat omar. All rights reserved.
//
//

import UIKit
import AVFoundation
import CoreML
import UIKit

class Results: UIViewController {
    
    
    @IBOutlet var birdImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("instance of VC view did load")
        
        let imageUrlString = "https://www.allaboutbirds.org/guide/assets/photo/63741611-1280px.jpg"
        
        guard let imageUrl:URL = URL(string: imageUrlString) else {
            return
        }
        
        guard (try? Data(contentsOf: imageUrl)) != nil else {
          return
        }
        
        // Start background thread so that image loading does not make app unresponsive
          DispatchQueue.global().async { [weak self] in
            
            guard let self = self else { return }
            
            guard let imageData = try? Data(contentsOf: imageUrl) else {
                return
            }

        
            // When from a background thread, UI needs to be updated on main_queue
           DispatchQueue.main.async {
                let image = UIImage(data: imageData)
            self.birdImageView.image = image
            //self.birdImageView.contentMode = UIView.ContentMode.scaleAspectFit
            //self.view.addSubview(self.birdImageView)
            }
        }
        
    }
    
    var infoCornellUrl = "https://ebird.org/species/grhowl"
    
    @IBAction func didTapLearnMore(_ sender: UIButton) {
        
        UIApplication.shared.openURL(NSURL(string: infoCornellUrl)! as URL)
    }
    
    
}

