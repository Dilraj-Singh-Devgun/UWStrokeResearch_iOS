//
//  ModularButtonView.swift
//  UWStrokeResearch
//
//  Created by Dilraj Devgun on 2/2/17.
//  Copyright © 2017 Dilraj Devgun. All rights reserved.
//

import UIKit


//Modular
protocol ModularButtonViewDeleate {
    func modularButtonViewViewDidPressButton(sender:UIButton, pressed:Int, view:UIView, options:[String])
    func modularButtonViewTappedInactive(sender:ModularButtonView)
}

class ModularButtonView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var QuestionLabel: UILabel!
    @IBOutlet weak var buttonAreaView: UIView!
    var delegate:ModularButtonViewDeleate?
    var coverView:UIView?
    var buttonOptions:[String]!
    var pickerView:UIPickerView?
    var bttns:[UIButton]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    init(frame:CGRect, question:String) {
        super.init(frame: frame)
        setUp()
        //add the question to the question label and adjust the font size to fit within the width of the view
        self.QuestionLabel.text = question
        self.QuestionLabel.adjustsFontSizeToFitWidth = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    override func prepareForInterfaceBuilder() {
        setUp()
    }
    
    // a setup method which gets the view from the xib file we created. This will allow us to put that xib in our view
    func setUp() {
        //get the bundle of our project
        let bundle = Bundle(for: type(of: self))
        //get the nib class from our project
        let nib = UINib(nibName: "ModularButtonView", bundle: bundle)
        //get the view we designed in the nib file and then add it as a subview to the uiview with the approproate constraints
        let viewFromNib = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        addSubview(viewFromNib)
        viewFromNib.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|[v]|",
                options: NSLayoutFormatOptions(rawValue: 0),
                metrics: nil,
                views: ["v":viewFromNib]
            )
        )
        self.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|[v]|",
                options: NSLayoutFormatOptions(rawValue: 0),
                metrics: nil, views: ["v":viewFromNib]
            )
        )
    }
    
    //Manually set the question to be displayed
    func setQuestion(question:String) {
        self.QuestionLabel.text = question
    }
    
    //Makes the view inactive by placing a faded view ontop to act as a cover and then blocks any interaction with the controls in the view
    func setInactive() {
        if let _ = self.coverView {
            return
        }
        //make the cover view with a white background and a transparancy to act as a faded vie
        self.coverView = UIView(frame: self.bounds)
        self.coverView!.backgroundColor = UIColor.white
        self.coverView!.alpha = 0.8
        self.addSubview(coverView!)
        //let tap = UITapGestureRecognizer(target: self, action: #selector(DiscreteQuestionView.didTapOldView))
        //coverView!.addGestureRecognizer(tap)
    }
    
    func didTapOldView(){
        if let _ = self.delegate {
            delegate?.modularButtonViewTappedInactive(sender: self)
        }
    }
    
    //make the view active and interactive again by removing the cover view and making all the buttons visable again
    func setActive(){
        if let cv = self.coverView {
            cv.removeFromSuperview()
            self.coverView = nil
        }
        
        let v1 = viewWithTag(1)
        let v2 = viewWithTag(2)
        let v3 = viewWithTag(3)
        v1?.alpha = 1
        v2?.alpha = 1
        v3?.alpha = 1
    }
    
    func setButtons(buttons:[String], width:CGFloat) {
        print(buttons)
        if (buttons.count > 4) {
            //make picker view with the button strings
//            var pickerView:UIPickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: width, height: self.buttonAreaView.frame.height))
//            pickerView.dataSource = self;
//            pickerView.dataSource = self;
//            self.buttonOptions = buttons
//            self.buttonAreaView.addSubview(pickerView)
        }
        else {
            //make upto 4 or so buttons with the button strings
            let buttonSpacing:CGFloat = 20;
            self.buttonOptions = buttons
            let bttnWidth:CGFloat = ((width*0.8)-buttonSpacing*CGFloat(buttons.count-1))/CGFloat(buttons.count)
            var bttnHeight:CGFloat = 100
            if(bttnWidth/bttnHeight < 0.9) {
                bttnHeight = bttnWidth
            }
            for i in 0 ..< buttons.count {
                let bttn = UIButton(frame: CGRect(x: width*0.1 + CGFloat(i)*CGFloat(buttonSpacing+bttnWidth), y: 65-(bttnHeight/2), width: bttnWidth, height: bttnHeight))
                switch buttons[i].lowercased() {
                case "yes":
                    bttn.backgroundColor = UIColor(red: 60/255, green: 209/255, blue: 152/255, alpha: 1)
                case "no":
                    bttn.backgroundColor = UIColor(red: 255/255, green: 94/255, blue: 100/255, alpha: 1)
                case "maybe":
                    bttn.backgroundColor = UIColor(red: 188/255, green: 182/255, blue: 182/255, alpha: 1)
                case "unknown":
                    bttn.backgroundColor = UIColor(red: 188/255, green: 182/255, blue: 182/255, alpha: 1)
                default:
                    bttn.backgroundColor = UIColor(red: 110/255, green: 207/255, blue: 205/255, alpha: 1)
                }
                bttn.layer.cornerRadius = 10
                bttn.setTitle(buttons[i], for: UIControlState.normal)
                bttn.titleLabel?.adjustsFontSizeToFitWidth = true
                bttn.titleLabel?.textColor = UIColor.white
                bttn.tag = i+1
                bttn.addTarget(self, action: #selector(pressedButton(sender:)), for: UIControlEvents.touchUpInside)
                self.buttonAreaView.addSubview(bttn)
                self.bttns?.append(bttn)
            }
        }
    }
    
    //sets up number of rows in a pickerview
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.buttonOptions.count
    }
    
    //notify the delegate that the pickerview option was picked
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    //the title for the row in the pickerview
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.buttonOptions[row]
    }
    
    //Row height for each picker view
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44
    }
    
    //number of components
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //when an option button is pressed
    func pressedButton(sender:UIButton) {
        let pressedTag = sender.tag
        if let buttons = self.bttns {
            for i in 0 ..< buttons.count {
                if buttons[i].tag != pressedTag {
                    buttons[i].alpha = 0
                }
            }
        }
        if let _ = self.delegate {
            delegate?.modularButtonViewViewDidPressButton(sender: sender, pressed: pressedTag, view: self, options: self.buttonOptions)
        }
    }
}
