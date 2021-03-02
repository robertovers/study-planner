//
//  ViewController.swift
//  study-planner
//
//  Created by Robert Overs on 24/1/21.
//

import UIKit

class ViewController: UIViewController {
    
    let studyTime: Int = 10
    
    let shortBreakTime: Int = 2
    
    let longBreakTime: Int = 8
    
    var currentTime: Int = 0
    
    var recentTime: Int = 0
    
    var recentMode: Int = 0
    
    var playing: Bool = false
    
    var timer = Timer()
    
    var inloop: Int = -1
    
    var breakCount: Int = 2
    
    var loopCount: Int = 1
    
    var wasInLoop: Bool = false
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var studyButton: UIButton!
    
    @IBOutlet weak var loopButton: UIButton!
    
    @IBOutlet weak var sbButton: UIButton!
    
    @IBOutlet weak var lbButton: UIButton!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        for b in [studyButton, loopButton, sbButton, lbButton] {
            b?.layer.cornerRadius = 10
        }
        
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        
        currentTime = studyTime*60
        
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
        if playing && inloop <= 0 {
            if currentTime == 0 {
                playing = false
                playButton.setImage(UIImage(systemName: "gobackward"), for: .normal)
            } else {
                currentTime -= 1
            }
        } else if playing {
            if currentTime == 0 && ((inloop-1) % (breakCount*2+2) == 0) {
                inloop -= 1
                currentTime = longBreakTime*60
                statusLabel.text = "Loop (Long Break)"
            } else if currentTime == 0 && ((inloop % 2) == 1) {
                inloop -= 1
                currentTime = shortBreakTime*60
                statusLabel.text = "Loop (Short Break)"
            } else if currentTime == 0 {
                inloop -= 1
                currentTime = studyTime*60
                statusLabel.text = "Loop (Study)"
            }
            currentTime -= 1
        }
        timerLabel.text = convertSeconds(secs: currentTime)
    }
    
    @IBAction func playButtonPressed(_ sender: Any) {
        if playing {
            playing = false
            playButton.setImage(UIImage(systemName: "play.fill"), for: .normal) // pause
            timerLabel.textColor = UIColor.black
        } else if currentTime > 0 {
            playing = true
            playButton.setImage(UIImage(systemName: "pause"), for: .normal) // play
            timerLabel.textColor = UIColor.systemGray
        } else if currentTime == 0 {
            playing = false
            if inloop == 0 {
                loopButtonPressed(self)
            } else {
                currentTime = recentTime
                playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)  // pause
                timerLabel.text = convertSeconds(secs: currentTime)
                timerLabel.textColor = UIColor.black
            }
        }
    }
    
    @IBAction func studyButtonPressed(_ sender: Any) {
        inloop = -1
        if playing || currentTime == 0 {
            playButtonPressed(self)
        }
        currentTime = studyTime*60
        recentTime = studyTime*60
        timerLabel.text = convertSeconds(secs: currentTime)
        statusLabel.text = "Study"
    }
    
    @IBAction func loopButtonPressed(_ sender: Any) {
        inloop = loopCount*(breakCount*2+2)-1
        if playing || currentTime == 0 {
            playButtonPressed(self)
        }
        currentTime = studyTime*60
        recentTime = studyTime*60
        timerLabel.text = convertSeconds(secs: currentTime)
        statusLabel.text = "Loop (Study)"
    }
    
    @IBAction func sbButtonPressed(_ sender: Any) {
        inloop = -1
        if playing || currentTime == 0 {
            playButtonPressed(self)
        }
        currentTime = shortBreakTime*60
        recentTime = shortBreakTime*60
        timerLabel.text = convertSeconds(secs: currentTime)
        statusLabel.text = "Short Break"
    }
    
    @IBAction func lbButtonPressed(_ sender: Any) {
        inloop = -1
        if playing || currentTime == 0 {
            playButtonPressed(self)
        }
        currentTime = longBreakTime*60
        recentTime = longBreakTime*60
        timerLabel.text = convertSeconds(secs: currentTime)
        statusLabel.text = "Long Break"
    }
    
}

