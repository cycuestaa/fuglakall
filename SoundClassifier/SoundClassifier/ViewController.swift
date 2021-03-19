//
//  ViewController.swift
//  SoundClassifier
//
//  Created by M'haimdat omar on 24-08-2019.
//  Copyright © 2019 M'haimdat omar. All rights reserved.
//

import UIKit
import AVFoundation
import CoreML
import UIKit

class ViewController: UIViewController, AVCaptureAudioDataOutputSampleBufferDelegate {
    
    @IBOutlet var recordButton: UIButton!
    @IBOutlet var stopRedButton: UIButton!
    @IBOutlet var stopGrayButton: UIButton!
    @IBOutlet var listenButton: UIButton!
    @IBOutlet var loadBirdButton: UIButton!
    @IBOutlet var recordingLabel: UILabel!
    @IBOutlet var instrLabel: UILabel!
    
    @IBOutlet var activityload: UIActivityIndicatorView!
    
    
    let rest = RestManager()
    let server_host = "http://45.33.19.27:5000/hello"
    let server_post = "http://45.33.19.27:5000/predict"

    /////////////////////////////
    // MARK: - Class's attributes
    lazy var label = UILabel()
    private enum classes: String {
        case dog = "dog"
        case rooster = "rooster"
        case helicopter = "helicopter"
        case sneezing = "sneezing"
    }
    
    lazy var output = ["dog", "rooster", "helicopter", "sneezing"]

    var instanceOfVC = CustomViewController()
    
    var isReady: Bool = false
    var species = "amecro"
    var infoCornellUrl = "https://ebird.org/species/grhowl"
    var isRecording: Bool = false
     //timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) {_ in}
    
    // Button title string.
    //let BTN_TITLE_START = "Start"
    //let BTN_TITLE_STOP = "Stop"
    
    // Button tag values.
   // let TAG_ONE = 1
   // let TAG_TWO = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setupLabel()
        // getInference()
        instanceOfVC.customOutputFileURL()
        instanceOfVC.recordSwift()
        instanceOfVC.customRecordSettings()
        self.activityload.hidesWhenStopped = true
        self.activityload.stopAnimating()
        
        // instanceOfVC.
        print("instance of VC view did load")
        uploadSingleFile()
       // Set button1's tag value.
        loadBirdButton.setTitle("Show Me Bird Caller ID!!", for: UIControl.State.normal)
        // Set button1's touchDown event process function.
        loadBirdButton.addTarget(self, action: #selector(processBtn), for: UIControl.Event.touchDown)
        
        loadBirdButton.addTarget(self, action: #selector(pploaded), for: UIControl.Event.valueChanged)
        
        
    
        
        
    }
    
    var runtime = "0"
    var startTime = TimeInterval()
    
    @objc func updateTime() {

        var currentTime = NSDate.timeIntervalSinceReferenceDate

        //Find the difference between current time and start time.

        var elapsedTime: TimeInterval = currentTime - startTime

        //calculate the minutes in elapsed time.

        let minutes = UInt8(elapsedTime / 60.0)

            elapsedTime -= (TimeInterval(minutes) * 60)

        //calculate the seconds in elapsed time.

        let seconds = UInt8(elapsedTime)

        elapsedTime -= TimeInterval(seconds)

        //find out the fraction of milliseconds to be displayed.

        let fraction = UInt8(elapsedTime * 100)

        //add the leading zero for minutes, seconds and millseconds and store them as string constants

        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strFraction = String(format: "%02d", fraction)

        //concatenate minuets, seconds and milliseconds as assign it to the UILabel

        runtime = "\(strMinutes):\(strSeconds):\(strFraction)"

        self.instrLabel.text = "Recording... " + runtime
        
    }
      
    var timer = Timer()
    
    /* This function will process button event. */
    @objc func processBtn(_ sender: UIButton) {
        
        // Get button tag property value.
        //let btnTag = sender.tag
        self.isReady = false
        self.activityload.startAnimating()
        sender.setTitle("Looking through our call book...", for: UIControl.State.normal)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
            
            sender.setTitleColor(UIColor.green, for: UIControl.State.normal)
            self.pploaded()
        }
        
        
        // Get button title text string.
        //let btnTitleText = sender.titleLabel?.text
        //if(btnTitleText == self.BTN_TITLE_START){
            //if(btnTag == TAG_ONE){
              //  btnTag == TAG_ONE
            //}
            //sender.setTitle(self.BTN_TITLE_STOP, for: UIControl.State.normal)
            //if(btnTag == TAG_TWO){
              //  activityload.stopAnimating()
           // }
            //sender.setTitle(self.BTN_TITLE_START, for: UIControl.State.normal)
    }
    
    @objc func pploaded() {
        self.activityload.stopAnimating()
        performSegue(withIdentifier: "segue_res", sender: nil)
    }

    @IBAction func didTapRecord(_ sender: UIButton) {
        isRecording = !isRecording
        
        print(self.recordButton.state)
        if !isRecording {
            self.recordButton.setImage(UIImage(named: "mic-orange.png"), for: .normal)
            //self.recordButton.setTitle("RECORD", for: self.recordButton.state)
            self.stopRedButton.isHidden = true
            self.stopGrayButton.isHidden = false
            self.recordingLabel.text = "Click button to start a new recording."
            self.listenButton.isHidden = false
            self.loadBirdButton.isHidden = false
            timer.invalidate()
            timer == nil
        } else {
            //self.recordButton.state = 2
            runtime = ""
            self.recordButton.setImage(UIImage(named: "mic-green.png"), for: .normal)
            //self.recordButton.setTitle("RECORDING...", for: self.recordButton.state)
            self.stopRedButton.isHidden = false
            self.stopGrayButton.isHidden = !self.stopGrayButton.isHidden
            self.recordingLabel.text = "Recording call..."
            self.listenButton.isHidden = true
            self.loadBirdButton.isHidden = true
            
            if !timer.isValid {
                let aSelector : Selector = #selector(updateTime)
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
            startTime = NSDate.timeIntervalSinceReferenceDate
            }
        }
    }
    
    @IBAction func didTapStopRed(_ sender: Any) {
        if !stopRedButton.isHidden {
            self.recordButton.setImage(UIImage(named: "mic-orange.png"), for: .normal)
            //self.recordButton.setTitle("RECORD", for: self.recordButton.state)
            self.stopRedButton.isHidden = true
            self.stopGrayButton.isHidden = false
            self.recordingLabel.text = "Click button to start a new recording"
            self.listenButton.isHidden = false
            self.loadBirdButton.isHidden = false
        }
    }
    
    
    ///////////////////////////////////////////////////////////
    // MARK: - Setup the label layout and add it to the subview
    private func setupLabel() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir-Heavy", size: 70)
        view.addSubview(label)
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    
    /////////////////////////////////////////////////////////////////////////////
    // MARK: - Get the inference for each sound and change the layout accordingly
    private func getInference() {
        //200 layers 100 iterations
        /*
        let model = SoundClassification()
        
        var count = 0
        _ = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { t in
            
            var wav_file: AVAudioFile!
            do {
                let fileUrl = URL(fileReferenceLiteralResourceName: "\(self.output[count])_1_converted.wav")
                wav_file = try AVAudioFile(forReading:fileUrl)
            } catch {
                fatalError("Could not open wav file.")
            }
            
            print("wav file length: \(wav_file.length)")
            assert(wav_file.fileFormat.sampleRate==16000.0, "Sample rate is not right!")
            
            let buffer = AVAudioPCMBuffer(pcmFormat: wav_file.processingFormat,
                                          frameCapacity: UInt32(wav_file.length))
            do {
                try wav_file.read(into:buffer!)
            } catch{
                fatalError("Error reading buffer.")
            }
            guard let bufferData = buffer?.floatChannelData else { return }
            
            // Chunk data and set to CoreML model
            let windowSize = 15600
            guard let audioData = try? MLMultiArray(shape:[windowSize as NSNumber],
                                                    dataType:MLMultiArrayDataType.float32)
                else {
                    fatalError("Can not create MLMultiArray")
            }
            
            // Ignore any partial window at the end.
            var results = [Dictionary<String, Double>]()
            let windowNumber = wav_file.length / Int64(windowSize)
            for windowIndex in 0..<Int(windowNumber) {
                let offset = windowIndex * windowSize
                for i in 0...windowSize {
                    audioData[i] = NSNumber.init(value: bufferData[0][offset + i])
                }
                let modelInput = SoundClassificationInput(audio: audioData)
                
                guard let modelOutput = try? model.prediction(input: modelInput) else {
                    fatalError("Error calling predict")
                }
                results.append(modelOutput.categoryProbability)
            }
            
            var prob_sums = Dictionary<String, Double>()
            for r in results {
                for (label, prob) in r {
                    prob_sums[label] = (prob_sums[label] ?? 0) + prob
                }
            }
            
            var max_sum = 0.0
            var max_sum_label = ""
            for (label, sum) in prob_sums {
                if sum > max_sum {
                    max_sum = sum
                    max_sum_label = label
                }
            }
            
            let most_probable_label = max_sum_label
            let probability = max_sum / Double(results.count)
            print("\(most_probable_label) predicted, with probability: \(probability)")
            
            let prediction: classes = classes.init(rawValue: most_probable_label)!
            
            switch prediction {
            case .dog:
                self.label.text = most_probable_label
                self.view.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            case .helicopter:
                self.label.text = most_probable_label
                self.view.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
            case .rooster:
                self.label.text = most_probable_label
                self.view.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            case .sneezing:
                self.label.text = most_probable_label
                self.view.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            }
            print(count)
            if count >= 3 {
                t.invalidate()
            }
            count += 1
        }
        */
    }
    
    
    
    func uploadSingleFile() {
        let fileURL = Bundle.main.url(forResource: "sampleText", withExtension: "txt")
        let fileInfo = RestManager.FileInfo(withFileURL: fileURL, filename: "sampleText.txt", name: "uploadedFile", mimetype: "text/plain", bytes: 5)
        
        rest.httpBodyParameters.add(value: "Hello 😀 !!!", forKey: "greeting")
        rest.httpBodyParameters.add(value: "AppCoda", forKey: "user")
        
        upload(files: [fileInfo], toURL: URL(string: server_post)) //+ "/upload"))
    }
    
    
    
    func uploadMultipleFiles() {
        let textFileURL = Bundle.main.url(forResource: "sampleText", withExtension: "txt")
        let textFileInfo = RestManager.FileInfo(withFileURL: textFileURL, filename: "sampleText.txt", name: "uploadedFile", mimetype: "text/plain", bytes: 5)
        
        let pdfFileURL = Bundle.main.url(forResource: "samplePDF", withExtension: "pdf")
        let pdfFileInfo = RestManager.FileInfo(withFileURL: pdfFileURL, filename: "samplePDF.pdf", name: "uploadedFile", mimetype: "application/pdf", bytes: 5)
        
        let imageFileURL = Bundle.main.url(forResource: "sampleImage", withExtension: "jpg")
        let imageFileInfo = RestManager.FileInfo(withFileURL: imageFileURL, filename: "sampleImage.jpg", name: "uploadedFile", mimetype: "image/jpg", bytes: 5)
        
        upload(files: [textFileInfo, pdfFileInfo, imageFileInfo], toURL: URL(string: server_post))// + "/multiupload"))
    }
    
    
    
    func upload(files: [RestManager.FileInfo], toURL url: URL?) {
        //print(u)
        if let uploadURL = url {
            rest.upload(files: files, toURL: uploadURL, withHttpMethod: .post) { (results, failedFilesList) in
                print("HTTP status code:", results.response?.httpStatusCode ?? 0)
                
                if let error = results.error {
                    print(error)
                }
                
                if let data = results.data {
                    if let toDictionary = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
                        print(toDictionary)
                    }
                }
                
                if let failedFiles = failedFilesList {
                    for file in failedFiles {
                        print(file)
                    }
                }
            }
        }
    }
    
}

