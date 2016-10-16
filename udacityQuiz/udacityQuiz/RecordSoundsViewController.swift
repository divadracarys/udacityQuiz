//
//  ViewController.swift
//  udacityQuiz
//
//  Created by Divya Kabra on 9/19/16.
//  Copyright © 2016 Divya Kabra. All rights reserved.
//
import Foundation
import UIKit
import AVFoundation // changed the code according to Xcode 8!

class RecordSoundsViewController: UIViewController , AVAudioRecorderDelegate {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    
    func setUIState(isRecording:Bool, recordingText:String) {
        stopRecordingButton.isEnabled = isRecording
        recordButton.isEnabled = !isRecording
        self.recordLabel.text = recordingText
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        stopRecordingButton.isEnabled = false
        
        recordButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        stopRecordingButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(_ sender: AnyObject) {
        setUIState(isRecording: true, recordingText: "Recording Audio")
        
        print("Recording in Progress")
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURL(withPathComponents: pathArray)
        print(filePath)
        // grab the AVAudioSession: in order to either playback or record we need an audio session
        let session = AVAudioSession.sharedInstance()
        // setting up the category to play and record: audio session required (up)
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        // AVAudioRecorder does not know what classes we have in our app
        // but it can inform our RecordVC class that it has finished recording
        audioRecorder.delegate = self
        
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }

    @IBAction func stopRecording(_ sender: AnyObject) {
        setUIState(isRecording: false, recordingText: "Tap to Record")
        print("Stopped")
        // telling the audio recorder to stop recording
        audioRecorder.stop()
        // close out the session
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    override func viewWillAppear(_ animated: Bool) {
        print("In the viewWillAppear function")
    }
    
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("AVAudioRecorder finished saving recording")
        if(flag){
        self.performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("Saving of the recording failed")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // checking the segue identifier
        
        if(segue.identifier == "stopRecording"){
            // grabbing the PSVC from the handy property destination
            // because this property is of the type UIViewController, but we know it's a PSVC
            // we can downcast it (as!)
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            // grabbing the sender (which is where we pack the URL)
            let recordedAudioURL = sender as! NSURL
            // setting the recordedAudioURL property to that URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }

}
