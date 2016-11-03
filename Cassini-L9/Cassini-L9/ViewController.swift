//
//  ViewController.swift
//  Cassini-L9
//
//  Created by Anoop G R on 04/04/16.
//  Copyright © 2016 Anoop. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //prepare for segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let ivc = segue.destinationViewController as? ImageViewController {
            if let identifier = segue.identifier {
                switch identifier {
                case "earth":
                    ivc.imageURL = DemoURL.NASA.Earth
                    ivc.title = "Earth"
                case "saturn":
                    ivc.imageURL = DemoURL.NASA.Saturn
                    ivc.title = "Saturn"
                case "cassini":
                    ivc.imageURL = DemoURL.NASA.Cassini
                    ivc.title = "Cassini"
                default:
                    break
                }
            }
        }
    }
}

