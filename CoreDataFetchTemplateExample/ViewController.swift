
import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var people: [NSManagedObject] = []
    let model: NSManagedObjectModel = (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.managedObjectModel
    let fetchAllRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Member")



    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Fight Club"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.fetchData(with: fetchAllRequest)

    }

    func fetchData(with fetchRequest:NSFetchRequest<NSFetchRequestResult>){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext


        do {
            people = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    @IBAction func addName(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Member", message: "Add a new member", preferredStyle: .alert)

        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in

            guard let nameTextField = alert.textFields?.first, let occupationTextField = alert.textFields?[1],
                  let nameToSave = nameTextField.text, let occupationToSave = occupationTextField.text  else {
                return
            }


            self.save(name: nameToSave, occupation: occupationToSave)
            self.tableView.reloadData()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addTextField { (textField) in
            textField.placeholder = "Name"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Occupation"
        }
        alert.addAction(saveAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }
    func save(name: String, occupation: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Member", in: managedContext)!
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        person.setValue(name, forKeyPath: "name")
        person.setValue(occupation, forKeyPath: "occupation")

        do {
            try managedContext.save()
            people.append(person)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    @IBAction func showNamesStartWith_B(_ sender: Any) {
        let fetchRequest = model.fetchRequestTemplate(forName: "StartsWith_B")

        self.fetchData(with: fetchRequest!)
        self.tableView.reloadData()
    }
    @IBAction func showNamesStartWith_R(_ sender: Any) {
        let fetchRequest = model.fetchRequestTemplate(forName: "StartsWith_R")

        self.fetchData(with: fetchRequest!)
        self.tableView.reloadData()
    }
    @IBAction func showEngineers(_ sender: Any) {
        let fetchRequest = model.fetchRequestTemplate(forName: "Engineers")

        self.fetchData(with: fetchRequest!)
        self.tableView.reloadData()
    }
    @IBAction func showDoctors(_ sender: Any) {
        let fetchRequest = model.fetchRequestTemplate(forName: "Doctors")

        self.fetchData(with: fetchRequest!)
        self.tableView.reloadData()
    }
    @IBAction func showAll(_ sender: Any) {
        self.fetchData(with: fetchAllRequest)
        self.tableView.reloadData()

    }


}


// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let person = people[indexPath.row]
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "Cell")
        cell.textLabel?.text = person.value(forKeyPath: "name") as? String
        cell.detailTextLabel?.text = person.value(forKeyPath: "occupation") as? String
        return cell
    }
}
