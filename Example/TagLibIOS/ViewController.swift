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
        let audioExtension = "mp3"
        let audioFilePath = getDocumentsDirectory().appendingPathComponent("\(randomString(length: 5)).\(audioExtension)")
        
        let resourcePath = URL(fileURLWithPath: Bundle.main.path(forResource: "audio", ofType: audioExtension)!)
        do {
            try fileManager.copyItem(at: resourcePath, to: audioFilePath)
        } catch{
            print("Error for file write")
        }
        
        let audio = TLAudio(fileAtPath: audioFilePath.path)!
        audio.title = "exampleTitle"
        audio.artist = "exampleArtist"
        audio.album = "exampleAlbum"
        audio.comment = "exampleComment"
        audio.genre = "exampleGenre"
        audio.year = 2001
        audio.track = 1
        
        let imageDataURL = URL(fileURLWithPath: Bundle.main.path(forResource: "coverArt", ofType: "png")!)
        do {
            let imageData = try Data(contentsOf: imageDataURL)
            audio.frontCoverPicture = imageData
            audio.artistPicture = imageData
        } catch {
            print("error")
        }
        
        let status = audio.save()
        print("File modifications saved: \(status)")
        print("Filepath: \(audioFilePath.path)")
        print("")
        
        let newAudio = TLAudio(fileAtPath: audioFilePath.path)!
        print("Title: \(newAudio.title!)")
        print("Artist: \(newAudio.artist!)")
        print("Album: \(newAudio.album!)")
        print("Comment: \(newAudio.comment!)")
        print("Genre: \(newAudio.genre!)")
        print("Year: \(newAudio.year!)")
        print("Track: \(newAudio.track!)")
        print("FrontCover Bytes: \(newAudio.frontCoverPicture!)")

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

