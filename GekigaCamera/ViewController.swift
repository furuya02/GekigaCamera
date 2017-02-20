//
//  ViewController.swift
//  GekigaCamera
//
//  Created by hirauchi.shinichi on 2017/02/19.
//  Copyright © 2017年 SAPPOROWORKS. All rights reserved.
//

import UIKit

class ViewController: UIViewController, AVCaptureDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var opView: UIView!

    @IBOutlet weak var blur0Slider: UISlider!
    @IBOutlet weak var blur1Slider: UISlider!
    @IBOutlet weak var adaptiveThreshold0Slider: UISlider!
    @IBOutlet weak var adaptiveThreshold1Slider: UISlider!
    
    let avCapture = AVCapture()
    let openCv = OpenCv()
    var isChecking = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        avCapture.delegate = self
        opView.layer.cornerRadius = 20
        opView.isHidden = true
    }
    
    func capture(image: UIImage) {
        if !isChecking {
            imageView.image = openCv.filter(image)
        }
    }
    
    @IBAction func tapShutterButton(_ sender: Any) {

        isChecking = true
        let alert: UIAlertController = UIAlertController(title: "撮影完了", message: "保存しますか？", preferredStyle:  UIAlertControllerStyle.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            (action: UIAlertAction!) -> Void in
            //let resize = self.resizeImage(image: self.imageView.image!, width: Int(UIScreen.main.bounds.width), height: Int(UIScreen.main.bounds.height) * 2)
            UIImageWriteToSavedPhotosAlbum(self.imageView.image!, self, nil, nil)
            self.isChecking = false
        })
        alert.addAction(UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
            (action: UIAlertAction!) -> Void in
            self.isChecking = false
        }))
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
    // Mark - OperationView
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // ImageView上でのタッチのみで反応する
        if (touches.first?.view?.tag)! == 1 {
            if opView.isHidden {
                opView.isHidden = false
            }
        }
    }

    @IBAction func tapOpCloseButton(_ sender: Any) {
        opView.isHidden = true
    }
    
    // Blur ぼかし
    @IBAction func changeBlurSwitch(_ sender: UISwitch) {
        openCv.useBlur = sender.isOn
        blur0Slider.isEnabled = sender.isOn
        blur1Slider.isEnabled = sender.isOn
    }

    @IBAction func changeBlur0Slider(_ sender: UISlider) {
        openCv.blur0 = Int32(sender.value)
    }
    
    @IBAction func changeBlur1Slider(_ sender: UISlider) {
        openCv.blur1 = Int32(sender.value)
    }
    
    // Treshold 閾値
    @IBAction func changeTresholdSwitch(_ sender: UISwitch) {
        openCv.useTreshold = sender.isOn
    }

    // AdaptiveTreshold 適応閾値
    @IBAction func changeAdaptiveTresholdSwitch(_ sender: UISwitch) {
        openCv.useAdaptiveTreshold = sender.isOn
        adaptiveThreshold0Slider.isEnabled = sender.isOn
        adaptiveThreshold1Slider.isEnabled = sender.isOn
    }
    
    @IBAction func changeAdaptiveTreshold0Slider(_ sender: UISlider) {
        openCv.adaptiveThreshold0 = Int32(sender.value)
    }
    
    @IBAction func changeAdaptiveTreshold1Slider(_ sender: UISlider) {
        openCv.adaptiveThreshold1 = Int32(sender.value)
    }
    
    
}

