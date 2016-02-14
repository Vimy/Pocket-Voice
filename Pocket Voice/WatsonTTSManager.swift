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
    
    
    func downloadAudioFromText(text: String, completionHandler:(musicData: NSData)->Void)
    {
        
        
        
        
        let tts = TextToSpeech (username: "655d6e5e-c4be-470b-9ef7-e2fdb9fa6f61", password: "09QiDRXdzZn9")

        
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
    
    
//    func concatenateAudioFiles(audioFiles: NSMutableArray ->NSString)
//    {
//        
//        // Concatenate audio files into one file
//        var nextClipStartTime = kCMTimeZero
//        let composition = AVMutableComposition()
//        let track = composition.addMutableTrackWithMediaType(AVMediaTypeAudio, preferredTrackID: kCMPersistentTrackID_Invalid)
//        
//        // Add each track
//        for recording in audioFiles {
//            let asset = AVURLAsset(URL: NSURL(fileURLWithPath: recording.path!), options: nil)
//            if let assetTrack = asset.tracksWithMediaType(AVMediaTypeAudio).first {
//                let timeRange = CMTimeRange(start: kCMTimeZero, duration: asset.duration)
//                do {
//                    try track.insertTimeRange(timeRange, ofTrack: assetTrack, atTime: nextClipStartTime)
//                    nextClipStartTime = CMTimeAdd(nextClipStartTime, timeRange.duration)
//                } catch {
//                    print("Error concatenating file - \(error)")
//                    completion(concatenatedFile: nil)
//                    return
//                }
//            }
//        }
//        
//        // Export the new file
//        if let exportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetPassthrough) {
//            let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
//            let documents = NSURL(string: paths.first!)
//            
//            if let fileURL = documents?.URLByAppendingPathComponent("file_name.caf") {
//                // Remove existing file
//                do {
//                    try NSFileManager.defaultManager().removeItemAtPath(fileURL.path!)
//                    print("Removed \(fileURL)")
//                } catch {
//                    print("Could not remove file - \(error)")
//                }
//                
//                // Configure export session output
//                exportSession.outputURL = NSURL.fileURLWithPath(fileURL.path!)
//                exportSession.outputFileType = AVFileTypeCoreAudioFormat
//                
//                // Perform the export
//                exportSession.exportAsynchronouslyWithCompletionHandler() { handler -> Void in
//                    if exportSession.status == .Completed {
//                        print("Export complete")
//                        dispatch_async(dispatch_get_main_queue(), {
//                            completion(file: fileURL)
//                        })
//                        return
//                    } else if exportSession.status == .Failed {
//                        print("Export failed - \(exportSession.error)")
//                    }
//                    
//                    completion(concatenatedFile: nil)
//                    return
//                }
//            }
//        }
//    
//    }
    
}
