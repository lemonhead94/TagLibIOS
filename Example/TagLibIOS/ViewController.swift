//
//  ViewController.swift
//  TagLibIOS
//
//  Created by lemonhead94 on 08/14/2018.
//  Copyright (c) 2018 lemonhead94. All rights reserved.
//

import UIKit
import TagLibIOS

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let fileManager = FileManager.default
        let audioFilePath = getDocumentsDirectory().appendingPathComponent("\(randomString(length: 5)).mp3")
        
        let resourcePath = URL(fileURLWithPath: Bundle.main.path(forResource: "audio", ofType: "mp3")!)
        do {
            try fileManager.copyItem(at: resourcePath, to: audioFilePath)
        } catch{
            print("Error for file write")
        }
        
        let tagReader = TagReader.init(fileAtPath: audioFilePath.path)!
        tagReader.artist = "exampleArtist"
        let imageDataURL = URL(fileURLWithPath: Bundle.main.path(forResource: "coverArt", ofType: "png")!)
        do {
            let imageData = try Data(contentsOf: imageDataURL)
            // doesn't work for Flac
            tagReader.albumArt = imageData
        } catch {
            
        }
        
        let status = tagReader.save()
        print(status)
        
        let newTagReader = TagReader.init(fileAtPath: audioFilePath.path)!
        print(newTagReader.artist)
        print("done!")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
}

