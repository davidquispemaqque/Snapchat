//
//  ElegirUsuarioAudioViewController.swift
//  DavidQuispeMSnapchat
//
//  Created by David Quispe Maqque on 30/10/24.
//

import UIKit
import Firebase
import FirebaseStorage

class ElegirUsuarioAudioViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var listaUsuarios: UITableView!
    var usuarios: [Usuario] = []

    // Variables que recibimos desde GrabarAudioViewController
    var audioURL: URL!
    var descripcion: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        listaUsuarios.delegate = self
        listaUsuarios.dataSource = self

        // Cargar usuarios desde Firebase
        Database.database().reference().child("usuarios").observe(DataEventType.childAdded, with: { snapshot in
            let usuario = Usuario()
            usuario.email = (snapshot.value as! NSDictionary)["email"] as! String
            usuario.uid = snapshot.key
            self.usuarios.append(usuario)
            self.listaUsuarios.reloadData()
        })
    }

    // Número de filas en la tabla
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usuarios.count
    }

    // Configurar las celdas de la tabla
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let usuario = usuarios[indexPath.row]
        cell.textLabel?.text = usuario.email
        return cell
    }

    // Subir el audio y guardar el snap al seleccionar un usuario
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let usuario = usuarios[indexPath.row]

        let storageRef = Storage.storage().reference().child("audios/\(UUID().uuidString).m4a")

        // Subimos el audio usando la URL directamente
        storageRef.putFile(from: audioURL, metadata: nil) { _, error in
            if let error = error {
                print("Error al subir el audio: \(error.localizedDescription)")
                return
            }

            storageRef.downloadURL { url, error in
                guard let audioURLString = url?.absoluteString, error == nil else {
                    print("Error al obtener la URL del audio: \(error?.localizedDescription ?? "Desconocido")")
                    return
                }

                // Crear el snap
                let snap: [String: Any] = [
                    "titulo": self.descripcion,
                    "audioURL": audioURLString,
                    "from": Auth.auth().currentUser?.email ?? ""
                ]

                // Guardar en Firebase
                Database.database().reference().child("usuarios").child(usuario.uid)
                    .child("snaps").childByAutoId().setValue(snap)

                print("Audio enviado con éxito a \(usuario.email).")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
