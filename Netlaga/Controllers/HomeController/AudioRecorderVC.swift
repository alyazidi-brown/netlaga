//
//  AudioRecorderVC.swift
//  DatingApp
//
//  Created by Scott Brown on 1/12/23.
//

import UIKit
import AVFAudio

protocol AudioRecorderVCDelegate {
    func uploadAudioToStorage(file: URL, user: DiscoveryStruct)
}

class AudioRecorderVC: BaseViewController {
    
    var delegate: AudioRecorderVCDelegate?
    
    var recordingSession: AVAudioSession?
    var audioRecorder: AVAudioRecorder?
    
    var discoverySetUp = DiscoveryStruct(firstName: "", email: "", ava: "", uid: "", place: "")
    
    var numberOfRecords = 0
    
    var counter = 0.0
    var lbTimeCounter = UILabel()
    var btnRecord = UIButton()
    var sendButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Send", for: .normal)
        
        //button.addTarget(self, action: #selector(sendAudio), for: .touchUpInside)
        //button.addTarget(self, action: #selector(sendAudio), for: .touchUpInside)
        
        /*
        let action = UIAction { action in
                print("howdy!")
            
            //AudioRecorderVC.sendAudio()
            }
        
        button.addAction(action, for: .touchUpInside)
         */
         
        
        button.tintColor = UIColor.blue
        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        // 2. check the idiom
        switch (deviceIdiom) {

        case .pad:
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
            //print("iPad style UI")
        case .phone:
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
           // print("iPhone and iPod touch style UI")
       // case .tv:
           // print("tvOS style UI")
        default:
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
           // print("Unspecified UI idiom")
        }
        
        return button
        }()
    var isRecording = false
    
    var fileName: URL?
    
    var timer: Timer?
    
    var imgStartRecord = UIImage(named: "ic_record")
    var imgRecording = UIImage(named: "ic_recording")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupView()
        setupSession()
        
        let action = UIAction { action in
                print("howdy!")
            
            self.sendAudio()
            }
        
        sendButton.addAction(action, for: .touchUpInside)
    }

    func setupView() {
        ivBack.isHidden = true
        view.addSubview(sendButton)
        view.addSubview(lbTimeCounter)
        view.addSubview(btnRecord)
        
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        lbTimeCounter.translatesAutoresizingMaskIntoConstraints = false
        btnRecord.translatesAutoresizingMaskIntoConstraints = false
        
        sendButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        sendButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        btnRecord.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        btnRecord.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        btnRecord.widthAnchor.constraint(equalToConstant: 150).isActive = true
        btnRecord.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        btnRecord.setImage(imgStartRecord, for: .normal)
        btnRecord.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        btnRecord.addTarget(self, action: #selector(startRecording), for: .touchUpInside)
        
        lbTimeCounter.centerXAnchor.constraint(equalTo: btnRecord.centerXAnchor).isActive = true
        lbTimeCounter.bottomAnchor.constraint(equalTo: btnRecord.topAnchor, constant: -30).isActive = true
        
        lbTimeCounter.text = String(format: "%.1f", counter)
        lbTimeCounter.font = .systemFont(ofSize: 30, weight: .semibold)
        

        sendButton.isEnabled = false
    }
    
    func setupSession() {
        recordingSession = AVAudioSession.sharedInstance()
        AVAudioSession.sharedInstance().requestRecordPermission { hasPermission in
            if hasPermission {
                print("Accepted")
            }
        }
    }
    
    @objc func startRecording() {
        
        isRecording = !isRecording
        
        if !isRecording {
            btnRecord.setImage(imgStartRecord, for: .normal)
            
            counter = 0.0
            lbTimeCounter.text = String(format: "%.1f", counter)
            
            timer?.invalidate()
            timer = nil
        } else {
            btnRecord.setImage(imgRecording, for: .normal)
            
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(countTimeRecording), userInfo: nil, repeats: true)
        }
        
        if audioRecorder == nil {
            numberOfRecords += 1
            fileName = getDirectory().appendingPathComponent("\(numberOfRecords).m4a")
            let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                          AVSampleRateKey: 12000,
                    AVNumberOfChannelsKey: 1,
                 AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
            
            // Start Audio Recording
            do {
                audioRecorder = try AVAudioRecorder(url: fileName!, settings: settings)
                audioRecorder?.delegate = self
                audioRecorder?.record()
            } catch {
                print("Not working!")
            }
            
        } else {
            // Stop audio recording
            audioRecorder?.stop()
            audioRecorder = nil
            sendButton.isEnabled = true
            print("Am I enabled?")
        }
    }
    
    @objc func countTimeRecording() {
        counter += 0.1
        lbTimeCounter.text = String(format: "%.1f", counter)
    }
    
    @objc func sendAudio() {
        print("what's wrong?")
        delegate?.uploadAudioToStorage(file: fileName!, user: discoverySetUp)
        //navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    // Function that get path to the directory
    func getDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        return documentDirectory
    }
    
}

extension AudioRecorderVC : AVAudioRecorderDelegate {
    
}


