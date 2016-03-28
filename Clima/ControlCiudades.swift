//
//  ControlCiudades.swift
//  Clima
//
//  Created by José Manuel Mora on 27/03/16.
//  Copyright © 2016 José Manuel Mora. All rights reserved.
//

import UIKit

class ControlCiudades: UIViewController {

    var codigoCiudad = ""

    @IBOutlet weak var txtTitulo: UITextField!
    @IBOutlet weak var txtAutores: UITextView!
    @IBOutlet weak var imgPortada: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        revisar(codigoCiudad)
    }

    func revisar(isbn: String)
    {
        let dirIni = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:"
        let dir = dirIni + isbn
        let url = NSURL(string: dir)
        let datos:NSData? = NSData(contentsOfURL: url!)
    
        
        if (datos != nil){

            do {
                let json = try NSJSONSerialization.JSONObjectWithData(datos!, options: NSJSONReadingOptions.MutableLeaves)
                let dicJson = json as! NSDictionary
                
                if let dicISBN = dicJson["ISBN:\(isbn)"] as! NSDictionary! {
                    
                    txtTitulo.text = dicISBN["title"] as! NSString as String
                    
                    let dicAutores = dicISBN["authors"] as! NSArray
                    var autores = ""
                    
                    for autor in dicAutores {
                        autores += "- \(autor["name"]!!)\n"
                    }
                    txtAutores.text = autores
                    
                    
                    imgPortada.image = nil
                    
                    if let dicCover = dicISBN["cover"] as! NSDictionary! {
                        if let url  = NSURL(string: dicCover["medium"] as! NSString as String), data = NSData(contentsOfURL: url) {
                            imgPortada.image = UIImage(data: data)
                        }
                    }
                }
            } catch _
            {
                let alerta = UIAlertController(title: "¡ Error con el libro !",
                    message: "Verifique la informació.",
                    preferredStyle: UIAlertControllerStyle.Alert)
                
                let accion2 = UIAlertAction(title: "OK",
                    style: UIAlertActionStyle.Cancel)
                    {
                        _ in
                }
                alerta.addAction(accion2)
                self.presentViewController(alerta, animated: true, completion: nil)
            }
        }
        else
        {
            let alerta = UIAlertController(title: "¡ Error en la conexión !",
                message: "Verifique conexión a Internet.",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            let accion2 = UIAlertAction(title: "OK",
                style: UIAlertActionStyle.Cancel)
                {
                    _ in
            }
            alerta.addAction(accion2)
            self.presentViewController(alerta, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
