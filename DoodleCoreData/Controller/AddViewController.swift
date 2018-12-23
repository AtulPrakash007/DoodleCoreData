//
//  AddViewController.swift
//  DoodleCoreData
//
//  Created by Atul on 23/12/18.
//  Copyright © 2018 Atul. All rights reserved.
//

import UIKit
import CoreData

class AddViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveBtn: UIButton!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var _fetchedResultsController: NSFetchedResultsController<Families>? = nil
    let cellReuseIdentifier = "AddCell" //FamilyCell
    var familyName = [String]()
    var user: Users!
    
    var fetchedResultsController: NSFetchedResultsController<Families>
    {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<Families> = Families.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchLimit = 1 //fetch last object
        //        fetchRequest.fetchBatchSize = 60
        
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }
    
    //MARK:- View Life
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - ButtonAction
    
    @IBAction func backAction(_ sender: UIButton) {
        dismissView()
    }
    
    @IBAction func addAction(_ sender: UIButton) {
        addNewFamilyName()
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        saveFamilyName()
        dismissView()
    }
    
    //MARK: - Custom Functions
    
    func addNewFamilyName() {
        familyName.append(textField.text!)
        
        let indexPath = IndexPath(row: familyName.count - 1, section: 0)
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
        
        textField.text = ""
        self.view.endEditing(true)
    }
    
    func saveFamilyName() {
        var recordID = 0
        if let lastRecordID = fetchedResultsController.fetchedObjects?.first?.id {
            recordID = Int(lastRecordID) + 1
        }
        
        for name in familyName {
            let family = Families(context: context)
            family.name = name
            print(recordID)
            family.id = Int32(recordID)
            recordID += 1
        }
        
        //        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    func dismissView() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource

extension AddViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return familyName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!

        cell.textLabel?.text = familyName[indexPath.row]
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension AddViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            familyName.remove(at: indexPath.row)
            
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
}
