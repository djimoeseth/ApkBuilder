//
//  ViewController.swift
//  ApkBuilder
//
//  Created by Amit Shekhar on 08/05/16.
//  Copyright © 2016 Amit Shekhar. All rights reserved.
//

import Cocoa

import Foundation

import SwiftShell

class ViewController: NSViewController {

    
    @IBOutlet weak var textParentFolderLocation: NSTextField!
    
    
    @IBOutlet weak var textJsonSeedFileLocation: NSTextField!
    
    
    @IBOutlet weak var textJavaSeedFileLocation: NSTextField!
    
    
    @IBOutlet weak var textResHdpiFolderLocation: NSTextField!
    
    
    @IBOutlet weak var textResXHdpiFolderLocation: NSTextField!
    
    
    @IBOutlet weak var textSeededPackIds: NSTextField!
    
    
    @IBOutlet weak var textApkVersions: NSTextField!
    
    
    @IBOutlet weak var textTerminal: NSScrollView!
    
    
    @IBOutlet weak var progress: NSProgressIndicator!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.progress.hidden = true
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    
    
    @IBAction func parentFolderLocationChooser(sender: AnyObject) {
        let openPanel = NSOpenPanel()
        openPanel.canChooseFiles = false
        openPanel.canChooseDirectories = true
        openPanel.resolvesAliases = true
        openPanel.allowsMultipleSelection = false
        openPanel.title = "Choose"
        openPanel.beginWithCompletionHandler({(result:Int) in
            if(result == NSFileHandlingPanelOKButton){
                let folderURL = openPanel.URL!.path
                self.textParentFolderLocation.stringValue = folderURL!
                print(folderURL!)
            }
        })
    }
    
    
    @IBAction func jsonSeedFileLocationChooser(sender: AnyObject) {
        let openPanel = NSOpenPanel()
        openPanel.allowedFileTypes = ["json"]
        openPanel.canChooseFiles = true
        openPanel.canChooseDirectories = false
        openPanel.resolvesAliases = true
        openPanel.allowsMultipleSelection = false
        openPanel.title = "Choose"
        openPanel.beginWithCompletionHandler({(result:Int) in
            if(result == NSFileHandlingPanelOKButton){
                let folderURL = openPanel.URL!.path
                self.textJsonSeedFileLocation.stringValue = folderURL!
                print(folderURL!)
            }
        })
    }
    
    
    @IBAction func javaSeedFileLocationChooser(sender: AnyObject) {
        let openPanel = NSOpenPanel()
        openPanel.allowedFileTypes = ["java"]
        openPanel.canChooseFiles = true
        openPanel.canChooseDirectories = false
        openPanel.resolvesAliases = true
        openPanel.allowsMultipleSelection = false
        openPanel.title = "Choose"
        openPanel.beginWithCompletionHandler({(result:Int) in
            if(result == NSFileHandlingPanelOKButton){
                let folderURL = openPanel.URL!.path
                self.textJavaSeedFileLocation.stringValue = folderURL!
                print(folderURL!)
            }
        })
    }
    

    @IBAction func resHdpiFolderLocationChooser(sender: AnyObject) {
        let openPanel = NSOpenPanel()
        openPanel.canChooseFiles = false
        openPanel.canChooseDirectories = true
        openPanel.resolvesAliases = true
        openPanel.allowsMultipleSelection = false
        openPanel.title = "Choose"
        openPanel.beginWithCompletionHandler({(result:Int) in
            if(result == NSFileHandlingPanelOKButton){
                let folderURL = openPanel.URL!.path
                self.textResHdpiFolderLocation.stringValue = folderURL!
                print(folderURL!)
            }
        })
    }

    @IBAction func resXHdpiFolderLocationChooser(sender: AnyObject) {
        let openPanel = NSOpenPanel()
        openPanel.canChooseFiles = false
        openPanel.canChooseDirectories = true
        openPanel.resolvesAliases = true
        openPanel.allowsMultipleSelection = false
        openPanel.title = "Choose"
        openPanel.beginWithCompletionHandler({(result:Int) in
            if(result == NSFileHandlingPanelOKButton){
                let folderURL = openPanel.URL!.path
                self.textResXHdpiFolderLocation.stringValue = folderURL!
                print(folderURL!)
            }
        })
    }
    
    @IBAction func build(sender: AnyObject) {
        if textParentFolderLocation.stringValue.isEmpty{
            self.textTerminal.documentView?.textStorage??.appendAttributedString(NSAttributedString(string: "\nPlease provide parent directory path of project"))
            return
        }
        getPermission()
        createDirForMapping()
        buildApk()
    }
    
    
    @IBAction func buildWithNewSeed(sender: AnyObject) {
        if textParentFolderLocation.stringValue.isEmpty{
            self.textTerminal.documentView?.textStorage??.appendAttributedString(NSAttributedString(string: "\nPlease provide parent directory path of project"))
            return
        }
        getPermission()
        createDirForMapping()
        if isValid(){
            deleteOldResources()
            replaceSeedJSONFile()
            replaceSeedJAVAFile()
            addNewResources()
            doCodeChangesForSeed()
            buildApk()
        }
    }
    
    func isValid() -> Bool {
        if textJsonSeedFileLocation.stringValue.isEmpty{
            self.textTerminal.documentView?.textStorage??.appendAttributedString(NSAttributedString(string: "\nPlease provide path of JSON seed"))
            return false
        }else if textJavaSeedFileLocation.stringValue.isEmpty{
            self.textTerminal.documentView?.textStorage??.appendAttributedString(NSAttributedString(string: "\nPlease provide path of JAVA seed"))
            return false
        }else if textResHdpiFolderLocation.stringValue.isEmpty{
            self.textTerminal.documentView?.textStorage??.appendAttributedString(NSAttributedString(string: "\nPlease provide path of HDPI resources"))
            return false
        }else if textResXHdpiFolderLocation.stringValue.isEmpty{
            self.textTerminal.documentView?.textStorage??.appendAttributedString(NSAttributedString(string: "\nPlease provide path of XHDPI resources"))
            return false
        }
        return true
    }
    
    func deleteOldResources(){
        self.textTerminal.documentView?.textStorage??.appendAttributedString(NSAttributedString(string: "\nDeleting Old Resources"))
        let filemanager:NSFileManager = NSFileManager()

        let pathHdpi = self.textParentFolderLocation.stringValue+"/app/src/main/res/drawable-hdpi/"
        let filesHdpi = filemanager.enumeratorAtPath(pathHdpi)
        while let fileHdpi = filesHdpi?.nextObject() {
            if fileHdpi.hasPrefix("seed_"){
                do{
                    try filemanager.removeItemAtPath(pathHdpi+(fileHdpi as! String))
                    print("File deleted")
                }catch{
                    print("File delete failed")
                }
            }
        }
        
        let pathXHdpi = self.textParentFolderLocation.stringValue+"/app/src/main/res/drawable-xhdpi/"
        let filesXHdpi = filemanager.enumeratorAtPath(pathXHdpi)
        while let fileXHdpi = filesXHdpi?.nextObject() {
            if fileXHdpi.hasPrefix("seed_"){
                do{
                    try filemanager.removeItemAtPath(pathXHdpi+(fileXHdpi as! String))
                    print("File deleted")
                }catch{
                    print("File delete failed")
                }
            }
        }
        self.textTerminal.documentView?.textStorage??.appendAttributedString(NSAttributedString(string: "\nOld Resources Deletion done"))
    }
    
    func addNewResources(){
        self.textTerminal.documentView?.textStorage??.appendAttributedString(NSAttributedString(string: "\nAdding New Resources"))
        let filemanager:NSFileManager = NSFileManager()
        
        let pathHdpiProject = self.textParentFolderLocation.stringValue+"/app/src/main/res/drawable-hdpi/"

        let pathHdpiProvided = self.textResHdpiFolderLocation.stringValue+"/"
        
        let filesHdpiProvided = filemanager.enumeratorAtPath(pathHdpiProvided)
        
        while let fileHdpiProvided = filesHdpiProvided?.nextObject() {
            do{
                try filemanager.copyItemAtPath(pathHdpiProvided+(fileHdpiProvided as! String), toPath: pathHdpiProject+(fileHdpiProvided as! String))
                print("Copy successful")
            }catch{
                print("Copy failed")
            }
        }
        
        
        let pathXHdpiProject = self.textParentFolderLocation.stringValue+"/app/src/main/res/drawable-xhdpi/"
        
        let pathXHdpiProvided = self.textResXHdpiFolderLocation.stringValue+"/"
        
        let filesXHdpiProvided = filemanager.enumeratorAtPath(pathXHdpiProvided)
        
        while let fileXHdpiProvided = filesXHdpiProvided?.nextObject() {
            do{
                try filemanager.copyItemAtPath(pathXHdpiProvided+(fileXHdpiProvided as! String), toPath: pathXHdpiProject+(fileXHdpiProvided as! String))
                print("Copy successful")
            }catch{
                print("Copy failed")
            }
        }
        self.textTerminal.documentView?.textStorage??.appendAttributedString(NSAttributedString(string: "\nNew Resources Addition done"))
    }
    
    func replaceSeedJSONFile(){
        
    }
    
    func replaceSeedJAVAFile(){
        
    }
    
    func doCodeChangesForSeed(){
        
    }
    
    func doCodeChangesForAPKBuild(){
        
    }
    
    func createDirForMapping(){
        do {
            self.textTerminal.documentView?.textStorage??.appendAttributedString(NSAttributedString(string: "\nCreating Mapping Directory"))
            try NSFileManager.defaultManager().createDirectoryAtPath(self.textParentFolderLocation.stringValue+"/app/build/outputs/mapping/release", withIntermediateDirectories: true, attributes: nil)
            self.textTerminal.documentView?.textStorage??.appendAttributedString(NSAttributedString(string: "\nMapping Directory Created"))
        } catch let error as NSError {
            self.textTerminal.documentView?.textStorage??.appendAttributedString(NSAttributedString(string: "\nMapping Directory Creation Failed"))
            print(error.localizedDescription);
        }
    }
    
    func getPermission(){
        
        run("chmod","+x",self.textParentFolderLocation.stringValue+"/gradlew")
        
        self.textTerminal.documentView?.textStorage??.appendAttributedString(NSAttributedString(string: "\nPermission Granted"))
    }
    
    
    func buildApk() {
        self.progress.hidden = false
        self.progress.startAnimation(self)
        self.textTerminal.documentView?.textStorage??.appendAttributedString(NSAttributedString(string: "\nBuild Started"))
        let taskQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)
        dispatch_async(taskQueue) {

            let command = runAsync(self.textParentFolderLocation.stringValue+"/gradlew","--build-file",self.textParentFolderLocation.stringValue+"/build.gradle","--settings-file",self.textParentFolderLocation.stringValue+"/settings.gradle","assembleRelease")
            
            do{
                try command.finish()
                print("Build Ready")
                self.textTerminal.documentView?.textStorage??.appendAttributedString(NSAttributedString(string: "\nBuild Ready"))
            }catch {
                print("Build Failed")
                self.textTerminal.documentView?.textStorage??.appendAttributedString(NSAttributedString(string: "\nBuild Failed"))
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                self.progress.stopAnimation(self)
                self.progress.hidden = true
            })
            
        }
        
    }
    
}

