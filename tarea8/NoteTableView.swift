import UIKit
import CoreData

var noteList = [Note]()
class NoteTableView: UITableViewController
{
    var firstLoad = true
    var selectedNote: Note? = nil
    func nonDeleteNotes() -> [Note]
    {
        var noDeleteNoteList = [Note]()
        for note in noteList
        {
            if(note.deletedDate == nil)
            {
                noDeleteNoteList.append(note)
            }
        }
        return noDeleteNoteList
    }
    
    
    override func viewDidLoad() {
        if (firstLoad)
        {
            firstLoad = false
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
            do{
                let results:NSArray = try context.fetch(request) as NSArray
                for result in results
                {
                    let note = result as! Note
                    noteList.append(note)
                }
            }
            catch
            {
                print("Fetch Failed")
            }
            
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let noteCell = tableView.dequeueReusableCell(withIdentifier: "noteCellID", for: indexPath) as! NoteCell
        
        let thisNote: Note!
        thisNote = nonDeleteNotes()[indexPath.row]
        
        noteCell.nameCursoLabel.text = thisNote.curso
        noteCell.prompracLabel.text = thisNote.promprac
        noteCell.promlabLabel.text = thisNote.promlab
        noteCell.examfinalLabel.text = thisNote.examfinal
       
        // Convertir las variables de String a Double
           let promprac = Double(thisNote.promprac ?? "0") ?? 0.0
           let promlab = Double(thisNote.promlab ?? "0") ?? 0.0
           let examfinal = Double(thisNote.examfinal ?? "0") ?? 0.0
           
           // Calcular el promedio
           let promedio = (promprac + promlab + examfinal) / 3
           
           // Cambiar el color de fondo de la celda si el promedio es mayor o igual a 13
           if promedio >= 13 {
               //noteCell.backgroundColor = UIColor.green
               noteCell.backgroundColor = UIColor(red: 119/255, green: 221/255, blue: 119/255, alpha: 1)


           }else if (promedio < 13 ){
               //noteCell.backgroundColor = UIColor.red
               noteCell.backgroundColor = UIColor(red: 248/255, green: 111/255, blue: 111/255, alpha: 1.0)

           }
            else {
               noteCell.backgroundColor = UIColor.white
           }
        //letras
         if thisNote.promprac.lowercased() == "aprobado" ||
                     thisNote.promlab.lowercased() == "aprobado" ||
                     thisNote.examfinal.lowercased() == "aprobado"  {
             noteCell.backgroundColor = UIColor(red: 119/255, green: 221/255, blue: 119/255, alpha: 1)
         }
        
        return noteCell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return nonDeleteNotes().count
    }
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.performSegue(withIdentifier: "editNote", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "editNote")
        {
            let indexPath = tableView.indexPathForSelectedRow!
            
            let noteDetail = segue.destination as? NoteDetailVC
            
            let SelectedNote : Note!
            SelectedNote = nonDeleteNotes()[indexPath.row]
            noteDetail!.selectedNote = SelectedNote
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
                
                // Obtenemos la nota seleccionada
                let selectedNote = nonDeleteNotes()[indexPath.row]
                
                // Configuramos el objeto de eliminación y lo guardamos
                selectedNote.deletedDate = Date()
                do {
                    try context.save()
                } catch {
                    print("Error al guardar la nota eliminada: \(error)")
                }
                
                // Eliminamos la nota de la lista y actualizamos la tabla
                noteList.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }

    }
}
