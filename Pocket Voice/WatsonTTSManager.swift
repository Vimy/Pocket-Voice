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
    static let singletonInstance = WatsonTTSManager()
    
    
    class func sharedInstance() -> WatsonTTSManager
    {
        return WatsonTTSManager.singletonInstance
    }
    
    
    
    
    var  audioData:NSData!
    var voiceName: String! = "en-GB_KateVoice"
//    {
//        didSet
//        {
//            print("voice gezet!");
//        }
//    }
//    
   
    func downloadAudioFromText(text: String, completionHandler:(musicData: NSData)->Void)
    {
        
        

        
        
        let tts = TextToSpeech (username: "655d6e5e-c4be-470b-9ef7-e2fdb9fa6f61", password: "09QiDRXdzZn9")
        
        
        tts.synthesize(text, voice: voiceName)
            {
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
            
//            
//            tts.synthesize(text) {
//            
//            data, error in
//            if((data) != nil)
//            {
//                completionHandler(musicData: data!)
//            }
//            else
//            {
//                print("WATSONMANAGER",error)
//            }
//            
//        }
//        
//        
//        tts.listVoices({
//            voices, error in
//            print(voices)
//            
//        })
        
    }
    
    
    
    
}
