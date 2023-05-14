import UIKit
import CoreData

class NoteDetailVC: UIViewController {

    
    @IBOutlet weak var nameCursoTF: UITextField!
    @IBOutlet weak var prompracTF: UITextField!
    @IBOutlet weak var promlabTF: UITextField!
    @IBOutlet weak var examfinalTF: UITextField!
    
    
    var selectedNote: Note? = nil
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if(selectedNote != nil)
        {
            nameCursoTF.text = selectedNote?.curso
            prompracTF.text = selectedNote?.promprac
            promlabTF.text = selectedNote?.promlab
            examfinalTF.text = selectedNote?.examfinal
        }
    }


    @IBAction func saveAction(_ sender: Any)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        if(selectedNote == nil)
        {
            let entity = NSEntityDescription.entity(forEntityName: "Note", in: context)
            let newNote = Note(entity: entity!, insertInto: context)
            newNote.id = noteList.count as NSNumber
            newNote.curso = nameCursoTF.text
            newNote.promprac = prompracTF.text
            newNote.promlab = promlabTF.text
            newNote.examfinal = examfinalTF.text
            
            do
            {
                try context.save()
                noteList.append(newNote)
                navigationController?.popViewController(animated: true)
            }
            catch
            {
                print("context save error")
            }
        }
        else //edit
        {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
            do{
                let results:NSArray = try context.fetch(request) as NSArray
                for result in results
                {
                    let note = result as! Note
                    if(note == selectedNote)
                    {
                        note.curso = nameCursoTF.text
                        note.promprac = prompracTF.text
                        note.promlab = promlabTF.text
                        note.examfinal = examfinalTF.text
                        try context.save()
                        navigationController?.popViewController(animated: true)
                    }
                }
            }
            catch
            {
                print("Fetch Failed")
            }
        }
    }
    
    
}

