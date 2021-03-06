//
//  ViewController.swift
//  PixelKitTestDemo
//
//  Created by Anton Heestand on 2019-10-17.
//  Copyright © 2019 Hexagons. All rights reserved.
//

import Cocoa
import LiveValues
import RenderKit
import PixelKit

class ViewController: NSViewController, NODEDelegate/*, NDIPIXDelegate*/ {
    
    var finalPix: (PIX & NODEOut)!
    var syphonOutPix: SyphonOutPIX!

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        PixelKit.main.logger.logDebug()
//        PixelKit.main.render.logger.logDebug()
//        PixelKit.main.render.engine.logger.logDebug()
        
        let polygonPix = PolygonPIX(at: ._1080p)
        polygonPix.rotation = .live
        
        finalPix = polygonPix
        finalPix.delegate = self
        
        syphonOutPix = SyphonOutPIX()
        syphonOutPix.input = finalPix
        
        view.addSubview(finalPix.view)
        finalPix.view.translatesAutoresizingMaskIntoConstraints = false
        finalPix.view.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        finalPix.view.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        finalPix.view.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        finalPix.view.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
//        try! PixelKit.main.render.engine.manuallyRender {
//            self.save()
//        }
        
    }
    
    func nodeDidRender(_ node: NODE) {}
    
//    func ndiPIXUpdated(sources: [String]) {
//        guard let source = sources.first else { return }
//        print("NDI >>>>>>>>>>", source)
//        ndiPix.connect(to: source)
//    }
    
//    func save() {
//        print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
//        guard let image = self.finalPix.renderedTileImage else { print("xxxxxx"); return }
//        let desktopUrl = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!
//        let imageUrl = desktopUrl.appendingPathComponent("pix_tiles.png")
//        guard image.savePNG(to: imageUrl) else { fatalError() }
//        print("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<")
//    }
    
//    func log() {
//        guard let pixels = self.finalPix.renderedPixels else { return }
//        var text = ""
//        for row in pixels.raw {
//            if text != "" {
//                text += "\n"
//            }
//            for pixel in row {
//                let c = pixel.color.lum.cg
//                text += c <= 0.0 ? "◾️" : c <= 0.25 ? "▫️" : c <= 0.5 ? "◽️" : c <= 0.75 ? "◻️" : "⬜️"
//            }
//        }
//        print(text)
//    }
    
}

