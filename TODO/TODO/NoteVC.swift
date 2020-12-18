//
//  NoteVC.swift
//  TODO
//
//  Created by Satsishur on 16.12.2020.
//

import UIKit

protocol NoteDelegate {
    func handleData(title: String, color: UIColor, key: String, font: Int)
    
    func handleDeleteNote(key: String)
}

class NoteVC: UIViewController {
    //MARK: Views
    let textView: UITextView = {
         let textView = UITextView()
         textView.translatesAutoresizingMaskIntoConstraints = false
         textView.text = "New Note"
         textView.textAlignment = .left
         textView.backgroundColor = .clear
//         textView.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.light)
         textView.isEditable = true
         //textView.allowsEditingTextAttributes = true
         return textView
     }()
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 20).isActive = true
        button.widthAnchor.constraint(equalToConstant: 20).isActive = true
        button.setImage(UIImage(systemName: "trash.circle"), for: .normal)
        button.addTarget(self, action: #selector(handleDeleteButton), for: .touchUpInside)
        return button
    }()
    
    let sizeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "16"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor(red: 0.078, green: 0.08, blue: 0.087, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    
    let increaseFontButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 8).isActive = true
        button.widthAnchor.constraint(equalToConstant: 8).isActive = true
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.addTarget(self, action: #selector(handleIncrease), for: .touchUpInside)
        return button
    }()
    
    let decreaseFontButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 8).isActive = true
        button.widthAnchor.constraint(equalToConstant: 8).isActive = true
        button.setImage(UIImage(systemName: "minus"), for: .normal)
        button.addTarget(self, action: #selector(handleDecrease), for: .touchUpInside)
        return button
    }()
    
    let blueButton = RoundColorButton()
    let pinkButton = RoundColorButton()
    let yellowButton = RoundColorButton()
    
    //MARK: Properties
    var noteBackgroundColor: UIColor
    var text: String = ""
    var keyOfNote: String
    var fontSize: Int = 16
    var delegate: NoteDelegate?
    
    init(color: UIColor, key: String) {
        noteBackgroundColor = color
        keyOfNote = key
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = noteBackgroundColor
        //view.layer.cornerRadius = 24
        textView.delegate = self
        hideMenuOnSwipe()
        setupLayout()
        blueButton.addTarget(self, action: #selector(handleColorChange(sender:)), for: .touchUpInside)
        pinkButton.addTarget(self, action: #selector(handleColorChange(sender:)), for: .touchUpInside)
        yellowButton.addTarget(self, action: #selector(handleColorChange(sender:)), for: .touchUpInside)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.handleData(title: text, color: noteBackgroundColor, key: keyOfNote, font: fontSize)
        super.viewWillDisappear(true)
        print("AAAAAAAAAAAAAAAAAA")
        print(text)
    }
    //MARK: Handle methods
    @objc func handleDeleteButton() {
        print("delete")
        delegate?.handleDeleteNote(key: keyOfNote)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleColorChange(sender: UIButton) {
        switch sender {
        case blueButton:
            blueButton.isSet = true
            pinkButton.isSet = false
            yellowButton.isSet = false
            noteBackgroundColor = NoteColors.blue
            view.backgroundColor = NoteColors.blue
        case pinkButton:
            blueButton.isSet = false
            pinkButton.isSet = true
            yellowButton.isSet = false
            noteBackgroundColor = NoteColors.pink
            view.backgroundColor = NoteColors.pink
        case yellowButton:
            blueButton.isSet = false
            pinkButton.isSet = false
            yellowButton.isSet = true
            noteBackgroundColor = NoteColors.yellow
            view.backgroundColor = NoteColors.yellow
        default:
            print("failed to set color")
        }
    }
    
    @objc func handleIncrease() {
        print("increase")
        fontSize += 1
        textView.font = UIFont.systemFont(ofSize: CGFloat(fontSize))
        sizeLabel.text = "\(fontSize)"
    }
    
    @objc func handleDecrease() {
        print("decrease")
        fontSize -= 1
        textView.font = UIFont.systemFont(ofSize: CGFloat(fontSize))
        sizeLabel.text = "\(fontSize)"
    }
}
    //MARK: Setup Layout
extension NoteVC {
    private func setupLayout() {
        let topContainer = UIView()
        view.addSubview(topContainer)
        topContainer.backgroundColor = .white
        topContainer.translatesAutoresizingMaskIntoConstraints = false
        topContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        topContainer.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        topContainer.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        topContainer.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        topContainer.addSubview(deleteButton)
        deleteButton.centerYAnchor.constraint(equalTo: topContainer.centerYAnchor).isActive = true
        deleteButton.rightAnchor.constraint(equalTo: topContainer.rightAnchor, constant: -15).isActive = true
        
        topContainer.addSubview(blueButton)
        blueButton.translatesAutoresizingMaskIntoConstraints = false
        topContainer.addSubview(pinkButton)
        pinkButton.translatesAutoresizingMaskIntoConstraints = false
        topContainer.addSubview(yellowButton)
        yellowButton.translatesAutoresizingMaskIntoConstraints = false
        
        blueButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        blueButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        blueButton.centerYAnchor.constraint(equalTo: topContainer.centerYAnchor).isActive = true
        blueButton.leftAnchor.constraint(equalTo: topContainer.leftAnchor, constant: 15).isActive = true
        blueButton.cornerRadius = 10
        blueButton.backgroundColor = NoteColors.blue
        
        
        pinkButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        pinkButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        pinkButton.centerYAnchor.constraint(equalTo: topContainer.centerYAnchor).isActive = true
        pinkButton.leftAnchor.constraint(equalTo: blueButton.rightAnchor, constant: 15).isActive = true
        pinkButton.cornerRadius = 10
        pinkButton.backgroundColor = NoteColors.pink
        
        yellowButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        yellowButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        yellowButton.centerYAnchor.constraint(equalTo: topContainer.centerYAnchor).isActive = true
        yellowButton.leftAnchor.constraint(equalTo: pinkButton.rightAnchor, constant: 15).isActive = true
        yellowButton.cornerRadius = 10
        yellowButton.backgroundColor = NoteColors.yellow
        
        switch noteBackgroundColor {
        case NoteColors.blue:
            blueButton.isSet = true
        case NoteColors.pink:
            pinkButton.isSet = true
        case NoteColors.yellow:
            yellowButton.isSet = true
        default:
            blueButton.isSet = true
        }
        
        topContainer.addSubview(sizeLabel)
        sizeLabel.text = "\(fontSize)"
        sizeLabel.centerYAnchor.constraint(equalTo: topContainer.centerYAnchor).isActive = true
        sizeLabel.centerXAnchor.constraint(equalTo: topContainer.centerXAnchor, constant: -30).isActive = true
        topContainer.addSubview(increaseFontButton)
        increaseFontButton.leftAnchor.constraint(equalTo: sizeLabel.rightAnchor, constant: 5).isActive = true
        increaseFontButton.bottomAnchor.constraint(equalTo: sizeLabel.topAnchor, constant: 5).isActive = true
        topContainer.addSubview(decreaseFontButton)
        decreaseFontButton.leftAnchor.constraint(equalTo: sizeLabel.rightAnchor, constant: 5).isActive = true
        decreaseFontButton.topAnchor.constraint(equalTo: sizeLabel.bottomAnchor, constant: -5).isActive = true
        
        view.addSubview(textView)
        textView.text = text
        textView.font = UIFont.systemFont(ofSize: CGFloat(fontSize), weight: UIFont.Weight.light)
        textView.topAnchor.constraint(equalTo: topContainer.bottomAnchor).isActive = true
        textView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 15).isActive = true
        textView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -15).isActive = true
        textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
    }
}
    //MARK: TextView delegate
extension NoteVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        text = textView.text
    }
}
    //MARK: Keyboard gesture
extension NoteVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func hideKeyboardOnSwipeDown() {
        view.endEditing(true)
    }
    
    func hideMenuOnSwipe() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.hideKeyboardOnSwipeDown))
         swipeDown.delegate = self
         swipeDown.direction =  UISwipeGestureRecognizer.Direction.down
         self.view.addGestureRecognizer(swipeDown)
    }
}


