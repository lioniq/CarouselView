//
//  ViewController.swift
//  CarouselViewDemo
//
//  Created by JERRY LIU on 17/11/2015.
//  Copyright © 2015 ONTHETALL. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var carouselView: CarouselView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let imageUrls: [String] = [
            "http://img-qa.jsdapp.com/uploads/item/cover_image/39aa8016-1427-438d-ad0c-f17661f29488.jpg@!750w",
            "http://img-qa.jsdapp.com/uploads/photo/image/ef9b1fe7-b8a5-4c5f-9851-3c55e2090e41.jpg@!750w",
            "http://img-qa.jsdapp.com/uploads/photo/image/f274cb74-22fb-4605-a62b-ebb79539cdc5.jpg@!750w",
            "http://img-qa.jsdapp.com/uploads/photo/image/66e2d244-4284-4458-be5a-f458e6dbbc48.jpg@!750w",
            "http://img-qa.jsdapp.com/uploads/photo/image/2a3b4f6a-687b-466a-8db6-3b4089325583.jpg@!750w"
        ]
        
        carouselView.imageUrls = imageUrls
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

