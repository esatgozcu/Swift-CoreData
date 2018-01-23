//
//  flimEkleVC.swift
//  flimListesi
//
//  Created by Esat Gözcü on 28.11.2017.
//  Copyright © 2017 Esat Gözcü. All rights reserved.
//

import UIKit
import CoreData

class filmEkleVC: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    

    @IBOutlet weak var puanText: UITextField!
    @IBOutlet weak var yilText: UITextField!
    @IBOutlet weak var isimText: UITextField!
    @IBOutlet weak var resimView: UIImageView!
    
    var gösterilecekFilmAdi = ""
    var gösterilecekFilmYili = Int()
    var gösterilecekFilmPuani = Double()
    var gösterilecekFilmResimi = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Önceki sayfada bir flim seçilirse değerleri aktarıyoruz
        isimText.text = gösterilecekFilmAdi
        puanText.text = String(gösterilecekFilmPuani)
        yilText.text = String(gösterilecekFilmYili)
        resimView.image = gösterilecekFilmResimi
        
        //Tıklanabilirliği aktif hale getiriyoruz
        resimView.isUserInteractionEnabled = true
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(filmEkleVC.choosePhoto))
        resimView.addGestureRecognizer(recognizer)

       
    }
    @objc func choosePhoto()
    {
        let picker = UIImagePickerController()
        picker.delegate = self
        //Kamerayıda seçebiliriz  picker.sourceType = .camera
        //Resim galerisine gidiyoruz
        picker.sourceType = .photoLibrary
        //Fotoğrafı düzenlemeyi aktif hale getiriyoruz
        picker.allowsEditing = true
        present(picker,animated: true,completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //Resimi seçtikten sonra..
        resimView.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func ekleButton(_ sender: Any) {
        
        //Core Dataya verileri ekliyoruz

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //Appdelegate'deki core data için oluşturulan fonksiyona erişiyoruz
        let context = appDelegate.persistentContainer.viewContext
        let newMovie = NSEntityDescription.insertNewObject(forEntityName: "Movie", into: context)
        
        
            newMovie.setValue(isimText.text!, forKey: "name")
        
        if let year = Int(yilText.text!)
        {
            newMovie.setValue(year, forKey: "year")
        }
        if let puan = Double(puanText.text!)
        {
            newMovie.setValue(puan, forKey: "imdb")
        }
        let data = UIImageJPEGRepresentation(resimView.image!, 0.5)
        newMovie.setValue(data, forKey: "image")
        
        do {
            //Context'i kayıt ediyoruz
            try context.save()
            print("succesful")
        }
        catch{
            //Hata olduğu error yazdırıyoruz
            print("error")
        }
        
        //Diğer sayfaya geçiş yapıyoruz
        self.navigationController?.popViewController(animated: true)
        
    }
    
}
