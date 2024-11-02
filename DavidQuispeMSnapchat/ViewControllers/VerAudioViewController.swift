//
//  VerAudioViewController.swift
//  DavidQuispeMSnapchat
//
//  Created by David Quispe Maqque on 30/10/24.
//

import UIKit
import AVFoundation

class VerAudioViewController: UIViewController {

    @IBOutlet weak var tituloLabel: UILabel!
    var audioPlayer: AVAudioPlayer?
    var snap: Snap?

    override func viewDidLoad() {
        super.viewDidLoad()
        tituloLabel.text = snap?.descrip

        // Intentar reproducir el audio al cargar la vista
        if let audioURLString = snap?.audioURL, let url = URL(string: audioURLString) {
            descargarYReproducirAudio(desde: url)
        } else {
            print("Error: No se encontró la URL del audio.")
        }
    }

    func descargarYReproducirAudio(desde url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data, error == nil {
                DispatchQueue.main.async {
                    do {
                        self.audioPlayer = try AVAudioPlayer(data: data)
                        self.audioPlayer?.prepareToPlay()
                        self.audioPlayer?.play()
                        print("Reproduciendo audio.")
                    } catch {
                        print("Error al reproducir el audio: \(error.localizedDescription)")
                    }
                }
            } else {
                print("Error al descargar el audio: \(error?.localizedDescription ?? "Desconocido")")
            }
        }.resume()
    }
}
