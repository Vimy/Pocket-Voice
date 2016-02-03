//
//  WatsonTTSManager.swift
//  Pocket Voice
//
//  Created by Matthias Vermeulen on 3/02/16.
//  Copyright © 2016 Noizy. All rights reserved.
//


import UIKit
import WatsonDeveloperCloud
import AVFoundation



@objc class WatsonTTSManager: NSObject
{
    var  audioData:NSData!
    
    
    func downloadAudioFromText(text: String, completionHandler:(musicData: NSData)->Void) {
        
        
        
        
        let tts = TextToSpeech (username: "", password: "")
        
        tts.synthesize(text) {
            
            data, error in
            if((data) != nil)
            {
            completionHandler(musicData: data!)
            }
            else
            {
                print("WATSONMANAGER",error)
            }
            
        }
    }
}
