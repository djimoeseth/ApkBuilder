//
//  ViewController.swift
//  ApkBuilder
//
//  Created by Amit Shekhar on 08/05/16.
//  Copyright © 2016 Amit Shekhar. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    
    @IBOutlet weak var textParentProjectDir: NSTextField!
    
    
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
    
    
    @IBAction func parentProjectDirChooser(sender: AnyObject) {
        let openPanel = NSOpenPanel()
        openPanel.canChooseFiles = false
        openPanel.canChooseDirectories = true
        openPanel.resolvesAliases = true
        openPanel.allowsMultipleSelection = false
        openPanel.title = "Choose"
        openPanel.beginWithCompletionHandler({(result:Int) in
            if(result == NSFileHandlingPanelOKButton){
                let folderURL = openPanel.URL!.path
                self.textParentProjectDir.stringValue = folderURL!
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
        buildApk()
    }
    
    func buildApk() {
        self.progress.hidden = false
        self.progress.startAnimation(self)
        let taskQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)
        dispatch_async(taskQueue) {
            
            let task:NSTask = NSTask()
            let pipe:NSPipe = NSPipe()
            
            //        task.launchPath = "/bin/ls"
            //        task.arguments = ["-la"]
            task.launchPath = "/Users/amitshekhar/Desktop/dex2jar-0.0.9.15/dex2jar.sh"
            
            task.arguments = ["/Users/amitshekhar/Desktop/apk/bobble_apk.apk"]
            
            task.standardOutput = pipe
            task.launch()
            
            let handle = pipe.fileHandleForReading
            let data = handle.readDataToEndOfFile()
            let result_s = NSString(data: data, encoding: NSUTF8StringEncoding)
            
            
            dispatch_async(dispatch_get_main_queue(), {
                self.progress.stopAnimation(self)
                self.progress.hidden = true
                self.textTerminal.documentView?.textStorage??.appendAttributedString(NSAttributedString(string: "\(result_s)"))
                print(result_s)
            })
            
        }
    }
    
}

