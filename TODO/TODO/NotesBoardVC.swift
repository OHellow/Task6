//
//  ViewController.swift
//  TODO
//
//  Created by Satsishur on 15.12.2020.
//

import UIKit
import FirebaseDatabase

class NotesBoardVC: UIViewController {
    //MARK: Views
    var collectionView: UICollectionView?
    private let navbar = UINavigationBar()
    
    //MARK: Properties
    internal var dataSource = [NoteModel]()
    let manager = FirebaseManager()
    private let transition = PanelTransition()
//    var expandedWidth:CGFloat {
//        return UIScreen.main.bounds.width - 30
//    }
//    var notExpandedWidth:CGFloat {
//        return (UIScreen.main.bounds.width - 15 - 15 - 5) / 2
//    }
//    var expandedHeight: CGFloat = 150
//    var notExpandedHeight: CGFloat = 100
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        manager.downloadNotes { (noteModels) in
            self.dataSource = noteModels
            self.collectionView?.reloadData()
        }
    }
    //MARK: //Add Note
    fileprivate func addNote(collectionView: UICollectionView) {
        let key = randomString(length: 6)
        let note = NoteModel(key: key, title: "New Note", color: "blue", index: dataSource.count)
        dataSource.append(note)
        manager.uploadNote(key: key, title: note.title, color: "blue", index: dataSource.endIndex, font: note.font)
        let indexPath = IndexPath(item: self.dataSource.count - 1, section: 0)
        let indexPaths: [IndexPath] = [indexPath]
        collectionView.performBatchUpdates({
            collectionView.insertItems(at: indexPaths)
        }, completion: nil)
    }
    
    
    fileprivate func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
}

extension NotesBoardVC {
    //MARK: Setup Layout
    private func setupLayout() {
        self.overrideUserInterfaceStyle = .light
        view.backgroundColor = .white
        
        navbar.barTintColor = .white
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        navbar.titleTextAttributes = textAttributes
        
        view.addSubview(navbar)
        navbar.translatesAutoresizingMaskIntoConstraints = false
        navbar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        navbar.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        navbar.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        navbar.heightAnchor.constraint(equalToConstant: 50).isActive = true

        let navItem = UINavigationItem(title: "Notes")
        navbar.items = [navItem]
        
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
//        let width = (UIScreen.main.bounds.width -
//                        15 - 15 - 5) / 2
//        layout.itemSize = CGSize(width: width, height: 100)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        guard let collectionView = collectionView else {return}
        collectionView.register(NoteCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.dragInteractionEnabled = true
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(collectionTapped))
        tap.cancelsTouchesInView = false
        tap.delegate = self
        collectionView.addGestureRecognizer(tap)
        collectionView.delaysContentTouches = false
        collectionView.isUserInteractionEnabled = true
        
        view.addSubview(collectionView)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: navbar.bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
        }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let c = touch.view is UIControl
        return !c
    }
    
}
//MARK: Collection Data source
extension NotesBoardVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! NoteCell
        cell.titleLabel.text = dataSource[indexPath.row].title
        cell.titleLabel.font = UIFont.systemFont(ofSize: CGFloat(dataSource[indexPath.row].font))
        cell.cellBackgroundColor = dataSource[indexPath.row].color
        cell.layer.cornerRadius = 5
        //cell.delegate = self
        //cell.indexPath = indexPath
        return cell
    }
}

extension NotesBoardVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width -
                                15 - 15 - 5) / 2, height: 100)
//        if dataSource[indexPath.row].isExpanded {
//            print("expand is true")
//             return CGSize(width: expandedWidth, height: expandedHeight)
//        }else{
//            return CGSize(width: notExpandedWidth, height: notExpandedHeight)
//        }
    }
}


    //MARK: Note delegate
extension NotesBoardVC: NoteDelegate {
    func handleData(title: String, color: UIColor, key: String, font: Int) {
        print(font)
        for i in 0..<dataSource.count {
            if dataSource[i].key == key {
                let color = getColorName(from: color)
                let index = dataSource[i].indexPath
                manager.uploadNote(key: key, title: title, color: color, index: index, font: font)
            }
        }
        collectionView?.reloadData()
    }
    
    func handleDeleteNote(key: String) {
        dataSource.removeAll(where: {$0.key == key})
        manager.deleteNote(key: key)
        collectionView?.reloadData()
    }
}

extension NotesBoardVC: UIGestureRecognizerDelegate {
    @objc func collectionTapped(sender: UITapGestureRecognizer){
        
        if let indexPath = self.collectionView?.indexPathForItem(at: sender.location(in: self.collectionView)) {
            print("you can do something with the cell or index path here")
            let color = dataSource[indexPath.row].color
            let key = dataSource[indexPath.row].key
            let title = dataSource[indexPath.row].title
            let child = NoteVC(color: color, key: key)
            child.delegate = self
            child.text = title
            child.fontSize = dataSource[indexPath.row].font
            child.modalPresentationStyle = .custom
            child.transitioningDelegate = self.transition
            self.present(child, animated: true)
        } else {
            guard let collectionView = collectionView else {
                return
            }
            addNote(collectionView: collectionView)
        }
    }
}

//extension NotesBoardVC: ExpandedCellDelegate{
//    func topButtonTouched(in cell: NoteCell ) {
//        if let indexPath = collectionView?.indexPath(for: cell) {
//        dataSource[indexPath.row].isExpanded = !dataSource[indexPath.row].isExpanded
//            let color = getColorName(from: dataSource[indexPath.row].color)
//            self.collectionView?.reloadItems(at: [indexPath])
//            manager.uploadNote(key: dataSource[indexPath.row].key, title: dataSource[indexPath.row].title, color: color, index: dataSource[indexPath.row].indexPath, expanded: dataSource[indexPath.row].isExpanded)
//
////        UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.9, options: UIView.AnimationOptions.curveEaseInOut, animations: {
////              self.collectionView?.reloadItems(at: [indexPath])
////            //self.collectionView?.reloadData()
////            }, completion: { success in
////                print("success")
////        })
//
//            print("aaaaaaa")
//        }
//        //self.collectionView?.reloadData()
//        //self.collectionView?.performBatchUpdates(nil, completion: nil)
//    }
//}

