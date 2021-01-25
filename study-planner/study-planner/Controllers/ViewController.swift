//
//  ViewController.swift
//  study-planner
//
//  Created by Robert Overs on 24/1/21.
//

import UIKit

class ViewController: UIViewController {
    
    let studyTime: Int = 25
    
    let shortBreakTime: Int = 1
    
    let longBreakTime: Int = 20
    
    var currentTime: Int = 25*60
    
    var recentTime: Int = 25*60
    
    var playing: Bool = false
    
    var timer = Timer()
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var studyButton: UIButton!
    
    @IBOutlet weak var loopButton: UIButton!
    
    @IBOutlet weak var sbButton: UIButton!
    
    @IBOutlet weak var lbButton: UIButton!
    
    @IBOutlet weak var settingsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        
        timerLabel.text = convertSeconds(secs: currentTime)
    }
    
    func convertSeconds(secs: Int) -> String {

        let mins: Int = Int(round(Double(secs/60)))
        
        var minsString: String
        
        if mins < 10 {
            minsString = "0" + String(mins)
        } else {
            minsString = String(mins)
        }
        
        let seconds: Int = secs % 60
        
        var secondsString: String
        
        if seconds < 10 {
            secondsString = "0" + String(seconds)
        } else {
            secondsString = String(seconds)
        }
        
        let res: String = minsString + ":" + secondsString
        
        return res
    }
    
    @objc func timerAction() {
        if playing {
            if currentTime == 0 {
                playing = false
                playButton.setTitle("↩︎", for: .normal)
            } else {
                currentTime -= 1
            }
            timerLabel.text = convertSeconds(secs: currentTime)
        }
    }
    
    @IBAction func playButtonPressed(_ sender: Any) {
        if playing {
            playing = false
            playButton.setTitle("▶︎", for: .normal)
        } else if currentTime > 0 {
            playing = true
            playButton.setTitle("ll", for: .normal)
        } else if currentTime == 0 {
            playing = false
            currentTime = recentTime
            playButton.setTitle("▶︎", for: .normal)
            timerLabel.text = convertSeconds(secs: currentTime)
        }
    }
    
    @IBAction func studyButtonPressed(_ sender: Any) {
        if playing || currentTime == 0 {
            playButtonPressed(self)
        }
        currentTime = studyTime*60
        recentTime = studyTime*60
        timerLabel.text = convertSeconds(secs: currentTime)
    }
    
    @IBAction func loopButtonPressed(_ sender: Any) {
        if playing || currentTime == 0 {
            playButtonPressed(self)
        }
        currentTime = studyTime*60
        recentTime = studyTime*60
        timerLabel.text = convertSeconds(secs: currentTime)
    }
    
    @IBAction func sbButtonPressed(_ sender: Any) {
        if playing || currentTime == 0 {
            playButtonPressed(self)
        }
        currentTime = shortBreakTime*60
        recentTime = shortBreakTime*60
        timerLabel.text = convertSeconds(secs: currentTime)
    }
    
    @IBAction func lbButtonPressed(_ sender: Any) {
        if playing || currentTime == 0 {
            playButtonPressed(self)
        }
        currentTime = longBreakTime*60
        recentTime = longBreakTime*60
        timerLabel.text = convertSeconds(secs: currentTime)
    }
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(identifier: "vc_settings") as? SettingsViewController else {
            print("failed to return vc")
            return
        }
        
        present(vc, animated: true)
    }
    
}

