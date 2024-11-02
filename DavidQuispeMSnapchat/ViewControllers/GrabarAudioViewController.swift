//
//  GrabarAudioViewController.swift
//  DavidQuispeMSnapchat
//
//  Created by David Quispe Maqque on 30/10/24.
//

import UIKit
import AVFoundation
import Firebase
import FirebaseStorage

class GrabarAudioViewController: UIViewController {

    @IBOutlet weak var tituloTextField: UITextField!
    @IBOutlet weak var grabarButton: UIButton!
    
    var audioRecorder: AVAudioRecorder?
    var audioURL: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        configurarSesionAudio()  // Preparamos la sesión de audio.
    }
    
    // Configuramos la sesión de audio al cargar la vista
    func configurarSesionAudio() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try session.setActive(true)
        } catch {
            print("Error al configurar la sesión de audio: \(error.localizedDescription)")
        }
    }

    @IBAction func grabarButtonTapped(_ sender: UIButton) {
        if audioRecorder == nil {
            iniciarGrabacion()  // Inicia la grabación
            sender.setTitle("Pausar", for: .normal)
        } else {
            audioRecorder?.pause()  // Pausa la grabación si ya está activa
            sender.setTitle("Grabar", for: .normal)
        }
    }
    
    func iniciarGrabacion() {
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent("audio.m4a")
        audioURL = fileURL
        
        do {
            audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
            audioRecorder?.record()
            print("Grabación iniciada: \(fileURL)")
        } catch {
            print("Error al iniciar la grabación: \(error.localizedDescription)")
        }
    }

    @IBAction func detenerButtonTapped(_ sender: UIButton) {
        audioRecorder?.stop()
        audioRecorder = nil

        if let audioURL = audioURL {
            print("Audio guardado en: \(audioURL)")
            
            // Prueba de reproducción inmediata para verificar la grabación
            do {
                let audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
                audioPlayer.prepareToPlay()
                audioPlayer.play()
                print("Reproduciendo audio grabado.")
            } catch {
                print("Error al reproducir el audio: \(error.localizedDescription)")
            }
        } else {
            print("Error: No se encontró la URL del audio.")
        }
    }
    
    @IBAction func seleccionarContactoTapped(_ sender: UIButton) {
        guard let _ = audioURL, let titulo = tituloTextField.text, !titulo.isEmpty else {
                print("Falta el título o el audio no fue grabado.")
                return
            }

            // Realizar el segue hacia ElegirUsuarioAudioViewController
            performSegue(withIdentifier: "elegirUsuarioAudioSegue", sender: nil)
        }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "elegirUsuarioAudioSegue" {
            let elegirUsuarioVC = segue.destination as! ElegirUsuarioAudioViewController
            
            // Asignar la URL de forma segura
            if let audioURL = self.audioURL {
                elegirUsuarioVC.audioURL = audioURL  // Pasamos el URL directamente
            } else {
                print("Error: No se encontró la URL del audio.")
            }

            elegirUsuarioVC.descripcion = self.tituloTextField.text ?? "Sin título"
        }
    }

}

