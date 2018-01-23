//
//  ViewController.swift
//  flimListesi
//
//  Created by Esat Gözcü on 28.11.2017.
//  Copyright © 2017 Esat Gözcü. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController , UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var tableView: UITableView!

    //Film bilgileri için Arraylar oluşturuyoruz
    var isimArray=[String]()
    var yilArray = [Int]()
    var puanArray=[Double]()
    var resimArray = [Data]()
    
    //Diğer sayfaya Film bilgilerini diğer sayfaya göndermek için değişken oluşturuyoruz
    var secilenFilmAdi = ""
    var secilenFilmYili = Int()
    var secilenFilmPuani = Double()
    var secilenFilmResimi = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        isimlerigetir()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        //ViewControlller her çalıştığında harekete geçer
        isimlerigetir()
        //Böylelikle flim eklendiği zaman tekrardan tableView'deki veriler güncellenir
    }
    func isimlerigetir(){
        
        //İsimArray'in içini boşaltıyoruz
        isimArray.removeAll(keepingCapacity: false)
        yilArray.removeAll(keepingCapacity: false)
        puanArray.removeAll(keepingCapacity: false)
        resimArray.removeAll(keepingCapacity: false)
        
        //Core Datadan verileri çekiyoruz
        //AppDelegate'deki fonskiyona erişiyoruz
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        //Verileri "Movie" entities'ten çekiyoruz
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Movie")
        fetchRequest.returnsObjectsAsFaults=false
        
        do{
            let results = try context.fetch(fetchRequest)
            if results.count >  0
            {
                for result in results as! [NSManagedObject]
                {
                    if let isim = result.value(forKey: "name") as? String
                    {
                        //Elde ettiğimiz isimleri isimArray'e aktarıyoruz
                        self.isimArray.append(isim)
                    }
                    self.tableView.reloadData()
                    if let yil = result.value(forKey: "year") as? Int
                    {
                        //Elde ettiğimiz yılı yilArray'e aktarıyoruz
                        self.yilArray.append(yil)
                    }
                    if let puan = result.value(forKey: "imdb") as? Double
                    {
                        //Elde ettiğimiz puanları puanArray'e aktarıyoruz
                        self.puanArray.append(puan)
                    }
                    if let resim = result.value(forKey: "image") as? Data
                    {
                        //Elde ettiğimiz resimleri resimArray'e aktarıyoruz
                        self.resimArray.append(resim)
                    }
                    self.tableView.reloadData()
                }
            }
        }
        catch{
            print("Error")
        }
    
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //İsimArray'deki eleman sayısını belirtiyoruz
        return isimArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        //isimArray'deki verileri TableView'e aktarıyoruz
        cell.textLabel?.text=isimArray[indexPath.row]
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Eğer listeden bir filme veya ekle butonuna basılırsa
        if segue.identifier == "segue"
        {
            //filmEkleVC'deki değişkenlerin değerlerini değiştiriyoruz
            let destinationVC = segue.destination as! filmEkleVC
        
            destinationVC.gösterilecekFilmAdi = secilenFilmAdi
            destinationVC.gösterilecekFilmYili = secilenFilmYili
            destinationVC.gösterilecekFilmPuani = secilenFilmPuani
            destinationVC.gösterilecekFilmResimi = secilenFilmResimi
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TableView'de bir flim seçtiğimizde çalışacak
        //Değişkenlere bilgileri aktarıyoruz
        secilenFilmAdi = isimArray[indexPath.row]
        secilenFilmYili = yilArray[indexPath.row]
        secilenFilmPuani = puanArray[indexPath.row]
        secilenFilmResimi = UIImage(data: resimArray[indexPath.row])!
        performSegue(withIdentifier: "segue", sender: nil)
        
    }
    @IBAction func ekleButton(_ sender: Any) {
        secilenFilmAdi = ""
        secilenFilmYili = Int()
        secilenFilmPuani = Double()
        secilenFilmResimi = UIImage(named: "resimekle.png")!
        //Diğer sayfaya geçiş yapıyoruz
        performSegue(withIdentifier: "segue", sender: nil)
    }
}

