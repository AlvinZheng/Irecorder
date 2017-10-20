//
//  ViewController.swift
//  Irecorder
//
//  Created by alvin zheng on 17/10/20.
//  Copyright © 2017年 alvin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let startButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.blue
        btn.layer.cornerRadius = 40
        btn.setTitle("start", for: .normal)
        return btn
    }()

    let textView: UITextView = {
        let v = UITextView()
        v.textColor = UIColor.black
        v.font = UIFont.systemFont(ofSize: 18)
        return v
    }()

    override func loadView() {
        super.loadView()
        view.addSubview(textView)
        view.addSubview(startButton)
        startButton.frame = CGRect(origin: CGPoint(x: 0, y:0), size: CGSize(width: 80, height: 80))
        startButton.addTarget(self, action: #selector(startRecord), for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.center = view.center
        textView.frame = CGRect(x: 0, y: 0, width: 300, height: 200)
        textView.center = CGPoint(x: view.bounds.size.width*0.5, y: 250)
        let recognizer = IFlySpeechRecognizer.sharedInstance()
        recognizer?.delegate = self

        recognizer?.setParameter("iat", forKey: IFlySpeechConstant.ifly_DOMAIN())
        recognizer?.setParameter("iat.pcm", forKey: IFlySpeechConstant.asr_AUDIO_PATH())


        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func startRecord() {
        IFlySpeechRecognizer.sharedInstance().startListening()
    }

}

extension ViewController: IFlySpeechRecognizerDelegate {
    func onCancel() {
        print("cancel")
    }

    func onBeginOfSpeech() {
        print("begin")
    }

    func onEndOfSpeech() {
        print("end")
    }

    func onVolumeChanged(_ volume: Int32) {
    }

    func onError(_ errorCode: IFlySpeechError!) {
        print("error: \(errorCode.errorDesc), code: \(errorCode.errorCode)")
        startRecord()
    }

    func onResults(_ results: [Any]!, isLast: Bool) {
//        print("result: \(results)")
        guard results != nil else {
            return
        }
        guard let dic = results[0] as? [String : Any] else {
            return
        }
        var result: String = ""
        var resultString = ""
        for key in dic.keys {
            result = result.appending(key)
            let resultFromJSON = ISRDataHelper.string(fromABNFJson: result) ?? ""
//            print("json: \(resultFromJSON)")
            resultString = resultString.appending(resultFromJSON)
        }
        print("recognized: \(resultString)")
        let text = textView.text
        textView.text = text?.appending(resultString)
    }

}
