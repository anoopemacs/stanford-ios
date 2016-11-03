//
//  ImageViewController.swift
//  Cassini-L9
//
//  Created by Anoop G R on 04/04/16.
//  Copyright © 2016 Anoop. All rights reserved.
//

//Controller 

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {

    // Model is below var
    // url to a jpeg file
    var imageURL: NSURL? {
        didSet {
            image = nil
            if view.window != nil {
                 fetchImage()
            }
        }
    }
    
    private func fetchImage() {
        if let url = imageURL {// imageURL is not nil
            let imageData = NSData(contentsOfURL: url)
            if imageData != nil {
                image = UIImage(data: imageData!)
            }
            else {
                image = nil
            }
        }
    }
    
    //creating a view in code example
    private var imageView = UIImageView()
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.contentSize = imageView.frame.size
            scrollView.delegate = self
            scrollView.minimumZoomScale = 0.03
            scrollView.maximumZoomScale = 1.00
        }
    }
    
    // what to zoom: as part of the UIScrollViewDelegate protocol, it is an optinal method of the old Obj-C delegate
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    private var image: UIImage? {
        get {return imageView.image}
        set {
            imageView.image = newValue
            imageView.sizeToFit()

            // ? allows to set imageView even when outlets have not yet been set
            scrollView?.contentSize = imageView.frame.size
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imageView)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if image == nil {
            fetchImage()
        }
    }
}
