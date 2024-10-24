//
//  registrarseViewController.swift
//  DavidQuispeMSnapchat
//
//  Created by David Quispe Maqque on 23/10/24.
//
import UIKit
import FirebaseAuth
import FirebaseDatabase

class CrearUsuarioViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func crearCuentaTapped(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }

                Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                    if let error = error {
                        print("Error al crear usuario: \(error.localizedDescription)")
                        self.mostrarAlerta(titulo: "Error", mensaje: "No se pudo crear el usuario.")
                    } else {
                        print("Usuario creado exitosamente")
                        Database.database().reference().child("usuarios").child(user!.user.uid).child("email").setValue(email)
                        self.mostrarAlerta(titulo: "Éxito", mensaje: "Usuario creado correctamente.") { _ in
                            self.performSegue(withIdentifier: "crearUsuarioANavigationSegue", sender: nil)
                        }
                    }
                }
            }

            func mostrarAlerta(titulo: String, mensaje: String, accion: ((UIAlertAction) -> Void)? = nil) {
                let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
                let btnOK = UIAlertAction(title: "Aceptar", style: .default, handler: accion)
                alerta.addAction(btnOK)
                self.present(alerta, animated: true, completion: nil)
            }
        }
