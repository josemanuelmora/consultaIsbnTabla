//
//  TVC.swift
//  Clima
//
//  Created by José Manuel Mora on 26/03/16.
//  Copyright © 2016 José Manuel Mora. All rights reserved.
//

import UIKit

class TVC: UITableViewController {

    
    @IBOutlet var Lista: UITableView!
    @IBOutlet weak var txtISBN: UITextField!
    @IBAction func btnBuscar(sender: AnyObject) {
        let libro = revisar()
        if (libro != "")
        {
            self.Libros.append([libro, self.txtISBN.text!])
            self.Lista.reloadData()
            
        }
    }
    
    private var Libros : Array<Array<String>> = Array<Array<String>>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Busca ISBN"
        self.Libros.append(["Star Trek", "9780345333513"])

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    func revisar() ->String
    {
        let dirIni = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:"
        let dir = dirIni + self.txtISBN.text!
        let url = NSURL(string: dir)
        let datos:NSData? = NSData(contentsOfURL: url!)
        
        var error = ""
        var Titulo = ""
        
        if (datos != nil){
            
            let texto = NSString(data: datos!, encoding: NSUTF8StringEncoding)
            if texto == "{}"
            {
                let alerta = UIAlertController(title: "¡ ISBN no encontrado !",
                    message: "Verifique el libro.",
                    preferredStyle: UIAlertControllerStyle.Alert)
                
                let accion2 = UIAlertAction(title: "OK",
                    style: UIAlertActionStyle.Cancel)
                    {
                        _ in
                }
                alerta.addAction(accion2)
                self.presentViewController(alerta, animated: true, completion: nil)
            }
            else
            {
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(datos!, options: NSJSONReadingOptions.MutableLeaves)
                    let dicJson = json as! NSDictionary
                
                    if let dicISBN = dicJson["ISBN:\(self.txtISBN.text!)"] as! NSDictionary! {
                    
                        Titulo = dicISBN["title"] as! NSString as String
                    }
                } catch _
                {
                    print("Ocurrió un error al obtener la información")
                    Titulo = ""
                }
            }
        }
        else
        {
            
            let alerta = UIAlertController(title: "¡ Error en la red !",
                message: "Verifique su conexión.",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            let accion2 = UIAlertAction(title: "OK",
                style: UIAlertActionStyle.Cancel)
                {
                    _ in
                }
            alerta.addAction(accion2)
            self.presentViewController(alerta, animated: true, completion: nil)
            
            error = "No hay conexión a Internet"
            self.txtISBN.text = error
            
            
        }
        
        self.txtISBN.resignFirstResponder()
        //print(texto)
        
        return Titulo
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.Libros.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Celda", forIndexPath: indexPath)

        // Configure the cell...

        //cell.textLabel?.text = self.Libros[indexPath.row][0]
        
        cell.textLabel?.text = "\(indexPath.row + 1). " + self.Libros[indexPath.row][0]
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let cc = segue.destinationViewController as! ControlCiudades
        let ip = self.tableView.indexPathForSelectedRow
        print(self.Libros[ip!.row][1])
        cc.codigoCiudad = self.Libros[ip!.row][1]
    }
}
