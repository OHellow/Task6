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
    private var dataSource = [NoteModel]()
    let manager = FirebaseManager()
    private let transition = PanelTransition()
    
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
//    @objc private func handleAddNote() {
//        guard let collectionView = collectionView else {
//            return
//        }
//        addNote(collectionView: collectionView)
//    }
    
    fileprivate func addNote(collectionView: UICollectionView) {
        let key = randomString(length: 6)
        let note = NoteModel(key: key, title: "New Note \(key)", color: "blue", index: dataSource.count)
        dataSource.append(note)
        manager.uploadNote(key: key, title: note.title, color: "blue", index: dataSource.endIndex)
        let indexPath = IndexPath(item: self.dataSource.count - 1, section: 0)
        let indexPaths: [IndexPath] = [indexPath]
        collectionView.performBatchUpdates({
            collectionView.insertItems(at: indexPaths)
        }, completion: nil)
    }
    //MARK: Reorder items method
    fileprivate func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView) {
        if let item = coordinator.items.first,
           let sourceIndexPath = item.sourceIndexPath {
            collectionView.performBatchUpdates({
                self.dataSource.remove(at: sourceIndexPath.item)
                self.dataSource.insert(item.dragItem.localObject as! NoteModel, at: destinationIndexPath.item)
                
                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [destinationIndexPath])
                for i in 0..<dataSource.count {
                    dataSource[i].indexPath = i
                }
                for note in dataSource {
                    manager.uploadNote(key: note.key, title: note.title, color: "blue", index: note.indexPath)
                }
            }, completion: nil)
            coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
        }
    }
    
    func randomString(length: Int) -> String {
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
//        let navRightButton =  UIBarButtonItem(barButtonSystemItem: .add,  target: self, action: #selector(handleAddNote))
//        navItem.rightBarButtonItem = navRightButton
        navbar.items = [navItem]
        
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let width = (UIScreen.main.bounds.width -
                        15 - 15 - 5) / 2
        layout.itemSize = CGSize(width: width, height: 100)
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
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapo))
        tap.cancelsTouchesInView = false
        collectionView.addGestureRecognizer(tap)
        
        view.addSubview(collectionView)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: navbar.bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
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
        cell.cellBackgroundColor = dataSource[indexPath.row].color
        cell.layer.cornerRadius = 5
        return cell
    }
}

extension NotesBoardVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width -
                                15 - 15 - 5) / 2, height: 100)
    }
}
//MARK: Collection Drag Delegate
extension NotesBoardVC: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = dataSource[indexPath.row]
        let itemProvider = NSItemProvider(object: item.title as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }
}
//MARK: Collection Drop Delegate
extension NotesBoardVC: UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if collectionView.hasActiveDrag {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UICollectionViewDropProposal(operation: .forbidden)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        var destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            let row = collectionView.numberOfItems(inSection: 0)
            destinationIndexPath = IndexPath(item: row - 1, section: 0)
        }
        
        if coordinator.proposal.operation == .move {
            reorderItems(coordinator: coordinator, destinationIndexPath: destinationIndexPath, collectionView: collectionView)
        }
    }
}
    //MARK: Collection Delegate
extension NotesBoardVC: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let color = dataSource[indexPath.row].color
//        let key = dataSource[indexPath.row].key
//        let title = dataSource[indexPath.row].title
//        let child = NoteVC(color: color, key: key)
//        child.delegate = self
//        child.text = title
//        child.modalPresentationStyle = .custom
//        child.transitioningDelegate = self.transition
//        self.present(child, animated: true)
//    }
}
    //MARK: Note delegate
extension NotesBoardVC: NoteDelegate {
    func handleData(title: String, color: UIColor, key: String) {
        for i in 0..<dataSource.count {
            if dataSource[i].key == key {
                dataSource[i].title = title
                dataSource[i].color = color
                let color = getColorName(from: color)
                let index = dataSource[i].indexPath
                manager.uploadNote(key: key, title: title, color: color, index: index)
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
    @objc func tapo(sender: UITapGestureRecognizer){
        if let indexPath = self.collectionView?.indexPathForItem(at: sender.location(in: self.collectionView)) {
            //let cell = self.collectionView?.cellForItem(at: indexPath)
            print("you can do something with the cell or index path here")
            let color = dataSource[indexPath.row].color
            let key = dataSource[indexPath.row].key
            let title = dataSource[indexPath.row].title
            let child = NoteVC(color: color, key: key)
            child.delegate = self
            child.text = title
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

