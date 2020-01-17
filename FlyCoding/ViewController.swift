//
//  ViewController.swift
//  FlyCoding
//
//  Created by SSBun on 19/09/2017.
//  Copyright © 2017 SSBun. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layer?.backgroundColor = NSColor.white.cgColor
        
        let imageView = NSImageView(frame: self.view.bounds)
        let image = NSImage(named: NSImage.Name("FlyCodingHomePage"))
        imageView.image = image
        self.view.addSubview(imageView)

    }

    override var representedObject: Any? {
        didSet {
        }
    }


}

