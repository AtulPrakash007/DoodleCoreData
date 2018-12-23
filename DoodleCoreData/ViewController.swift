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
    
    var fetchedResultsController: NSFetchedResultsController<Task>
    {
        // If the variable is already initialized we return that instance.
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        // If not, lets build the required elements for the fetched
        // results controller.
        
        // First we need to create a fetch request with the pretended type.
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        // Set the batch size to a suitable number (optional).
        fetchRequest.fetchBatchSize = 20
        
        // Create at least one sort order attribute and type (ascending\descending)
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: false)
        
        // Set the sort objects to the fetch request.
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Optionally, let's create a filter\predicate.
        // The goal of this predicate is to fetch Tasks that are not yet completed.
        let predicate = NSPredicate(format: "completed == FALSE")
        
        // Set the created predicate to our fetch request.
        fetchRequest.predicate = predicate
        
        // Create the fetched results controller instance with the defined attributes.
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        
        // Set the delegate of the fetched results controller to the view controller.
        // with this we will get notified whenever occurs changes on the data.
        aFetchedResultsController.delegate = self
        
        // Setting the created instance to the view controller instance.
        _fetchedResultsController = aFetchedResultsController
        
        do {
            // Perform the initial fetch to Core Data.
            // After this step, the fetched results controller
            // will only retrieve more records if necessary.
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
        //fetchData()
        saveData()
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
        if let lastRecordID = fetchedResultsController?.fetchedObjects?.first?.id {
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
        
        let user = users[indexPath.row]
        print(user.id)
        if let userName = user.name {
            userCell.userNameLbl.text = userName
        }
        
        userCell.addBtn.tag = indexPath.row
        userCell.familyCountBtn.tag = indexPath.row
        userCell.delegate = self
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
    func cellBtnAction(for isFamily: Bool, at index: Int) {
        if isFamily {
            
        }else {
            
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
