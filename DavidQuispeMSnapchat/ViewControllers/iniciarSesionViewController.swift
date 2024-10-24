//
//  ViewController.swift
//  DavidQuispeMSnapchat
//
//  Created by David Quispe Maqque on 16/10/24.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class iniciarSesionViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func iniciarSesionTapped(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }

                Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                    if let error = error {
                        print("Error al iniciar sesión: \(error.localizedDescription)")

                        // Mostrar alerta para crear un usuario
                        let alerta = UIAlertController(
                            title: "Usuario no encontrado",
                            message: "¿Deseas crear una nueva cuenta?",
                            preferredStyle: .alert
                        )

                        let btnCrear = UIAlertAction(title: "Crear", style: .default) { _ in
                            self.performSegue(withIdentifier: "loginACrearUsuarioSegue", sender: nil)
                        }
                        let btnCancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)

                        alerta.addAction(btnCrear)
                        alerta.addAction(btnCancelar)
                        self.present(alerta, animated: true, completion: nil)
                    } else {
                        print("Inicio de sesión exitoso")
                        self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)
                    }
                }
            }
        }
