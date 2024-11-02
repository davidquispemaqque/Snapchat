//
//  SnapsViewController.swift
//  DavidQuispeMSnapchat
//
//  Created by David Quispe Maqque on 21/10/24.
//

import UIKit
import Firebase

class SnapsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var tablaSnaps: UITableView!
    var snaps:[Snap] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tablaSnaps.delegate = self
        tablaSnaps.dataSource = self

        Database.database().reference().child("usuarios").child((Auth.auth().currentUser?
            .uid)!).child("snaps").observe(DataEventType.childAdded, with: { (snapshot) in
                let snap = Snap()
                let snapData = snapshot.value as? [String: Any] ?? [:]

                // Asignar valores con unwrapping seguro
                snap.imagenURL = snapData["imagenURL"] as? String ?? ""
                snap.audioURL = snapData["audioURL"] as? String ?? ""  // Carga segura del audioURL
                snap.from = snapData["from"] as? String ?? "Desconocido"
                snap.descrip = snapData["descripcion"] as? String ?? "Sin descripción"
                snap.id = snapshot.key
                snap.imagenID = snapData["imagenID"] as? String ?? ""

                self.snaps.append(snap)
                self.tablaSnaps.reloadData()
            })
        
        Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!)
            .child("snaps").observe(DataEventType.childRemoved, with: { (snapshot) in
            var iterator = 0
            for snap in self.snaps {
                if snap.id == snapshot.key {
                    self.snaps.remove(at: iterator)
                }
                iterator += 1
            }
            self.tablaSnaps.reloadData()
        })


        // Do any additional setup after loading the view.
    }
    

    @IBAction func cerrarSesionTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if snaps.count == 0{
            return 1
        }else{
            return snaps.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if snaps.count == 0 {
            cell.textLabel?.text = "No Tienes Snaps 😭"
        } else {
            let snap = snaps[indexPath.row]
            cell.textLabel?.text = snap.from
            
            if !snap.imagenURL.isEmpty {
                cell.textLabel?.text = "\(snap.from) te envió una imagen 📷"
            } else if !snap.audioURL.isEmpty {
                cell.textLabel?.text = "\(snap.from) te envió un audio 🎵"
            }

        }
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snap = snaps[indexPath.row]
        if !snap.imagenURL.isEmpty {
            performSegue(withIdentifier: "versnapsegue", sender: snap)
        } else if !snap.audioURL.isEmpty {
            performSegue(withIdentifier: "verAudioSegue", sender: snap)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "versnapsegue"{
            let siguienteVC = segue.destination as! VerSnapViewController
            siguienteVC.snap = sender as! Snap
            
        }else if segue.identifier == "verAudioSegue" {
            let siguienteVC = segue.destination as! VerAudioViewController
            siguienteVC.snap = sender as! Snap
        }

    }

}
