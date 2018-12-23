//
//  ViewController.swift
//  DoodleCoreData
//
//  Created by Atul on 22/12/18.
//  Copyright © 2018 Atul. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var _fetchedResultsController: NSFetchedResultsController<Users>? = nil
    let nameArr = ["Atul Prakash", "Deepak Kumar", "Vasudevan S", "Malvirajan", "SatheeshKumar K"]
    var users: [Users] = []
    
    var fetchedResultsController: NSFetchedResultsController<Users>
    {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }

        let fetchRequest: NSFetchRequest<Users> = Users.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchLimit = 1 //fetch last object
//        fetchRequest.fetchBatchSize = 60
        
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        aFetchedResultsController.delegate = self
        
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableViewCell()
        //deleteAllRecords()
        fetchData()
        //saveData()
    }
    
    func registerTableViewCell() {
        tableView.rowHeight = 80
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: String(describing: UserTableViewCell.self),bundle: nil), forCellReuseIdentifier:String(describing: UserTableViewCell.self))
    }

    func fetchData() {
        
        do {
            users = try context.fetch(Users.fetchRequest())

        } catch {
            print("Fetching Failed")
        }
        
        if users.isEmpty {
            saveData()
        }
    }
    
    func saveData() {
        var recordID = 0
        if let lastRecordID = fetchedResultsController.fetchedObjects?.first?.id {
            recordID = Int(lastRecordID) + 1
        }
        
        for name in nameArr {
            let user = Users(context: context)
            user.name = name
            print(recordID)
            user.id = Int32(recordID)
            recordID += 1
        }
        
//        (UIApplication.shared.delegate as! AppDelegate).saveContext()

        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
        
        fetchData()
    }
    
    func deleteAllRecords() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        
        // Create Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
            try context.save()
        } catch {
            print("Failed Deleting")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK:- UITableViewDataSource

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
        
        let userCell = tableView.dequeueReusableCell(withIdentifier: String(describing: UserTableViewCell.self), for: indexPath) as! UserTableViewCell
        userCell.delegate = self

        let user = users[indexPath.row]
        print(user.id)
        if let userName = user.name {
            userCell.userNameLbl.text = userName
        }
        userCell.addBtn.tag = Int(user.id)
        userCell.familyCountBtn.tag = Int(user.id)
        userCell.familyCountBtn.setTitle(String(describing: user.family?.count ?? 0), for: .normal)
        
        cell = userCell
        
        cell?.selectionStyle = .none
        return cell!
    }
}

//MARK:- UITableViewDelegate

extension ViewController: UITableViewDelegate {
    
}

//MARK:- UserTableDelegate

extension ViewController: UserTableDelegate {
    func cellBtnAction(for family: Bool, of id: Int) {
        print(id)
        if family {
            
        }else {
            performse
        }
    }
}

//MARK:- NSFetchedResultsControllerDelegate

extension ViewController : NSFetchedResultsControllerDelegate
{
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // Whenever a change occours on our data, we refresh the table view.
        self.tableView.reloadData()
    }
}
