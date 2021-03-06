//
//  ImagePIX.swift
//  PixelKit
//
//  Created by Hexagons on 2018-08-07.
//  Open Source - MIT License
//

import RenderKit
import LiveValues
#if os(iOS) || os(tvOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif
#if canImport(SwiftUI)
import SwiftUI
#endif

#if canImport(SwiftUI)
@available(iOS 13.0.0, *)
@available(OSX 10.15, *)
@available(tvOS 13.0.0, *)
public struct ImagePIXUI: View, PIXUI {
    public var node: NODE { pix }
    public let pix: PIX
    let imagePix: ImagePIX
    public var body: some View {
        NODERepView(node: pix)
    }
    #if os(iOS) || os(tvOS)
    public init(image: UIImage) {
        imagePix = ImagePIX()
        imagePix.image = image
        pix = imagePix
    }
    #elseif os(macOS)
    public init(image: NSImage) {
        imagePix = ImagePIX()
        imagePix.image = image
        pix = imagePix
    }
    #endif
}
#endif

public class ImagePIX: PIXResource {
    
    #if os(iOS) || os(tvOS)
    override open var shaderName: String { return "contentResourceFlipPIX" }
    #elseif os(macOS)
    override open var shaderName: String { return "contentResourceBGRPIX" }
    #endif
    
    // MARK: - Public Properties
    
    #if os(iOS) || os(tvOS)
    public var image: UIImage? { didSet { setNeedsBuffer() } }
    #elseif os(macOS)
    public var image: NSImage? { didSet { setNeedsBuffer() } }
    #endif
    
    #if !os(macOS)
    public var resizeToFitResolution: Resolution? = nil
    #endif
    var resizedResolution: Resolution? {
        #if !os(macOS)
        guard let res = resizeToFitResolution else { return nil }
        guard let image = image else { return nil }
        return Resolution.cgSize(image.size).aspectResolution(to: .fit, in: res)
        #else
        return nil
        #endif
    }
    
    // MARK: - Life Cycle
    
    public override init() {
        super.init()
        name = "image"
        self.applyResolution {
            self.setNeedsRender()
        }
        pixelKit.render.listenToFramesUntil {
            if self.realResolution != nil {
                return .done
            }
            if self.renderResolution != ._128 {
                self.applyResolution {
                    self.setNeedsRender()
                }
                return .done
            }
            return .continue
        }
    }
    
    // MARK: Buffer
    
    func setNeedsBuffer() {
        guard var image = image else {
            pixelKit.logger.log(node: self, .debug, .resource, "Nil not supported yet.")
            return
        }
        #if !os(macOS)
        if let res = resizedResolution {
            image = Texture.resize(image, to: res.size.cg)
        }
        #endif
        if pixelKit.render.frame == 0 && frameLoopRenderThread == .main {
            pixelKit.logger.log(node: self, .debug, .resource, "One frame delay.")
            pixelKit.render.delay(frames: 1, done: {
                self.setNeedsBuffer()
            })
            return
        }
        let bits: LiveColor.Bits = pixelKit.render.bits
        guard let buffer = Texture.buffer(from: image, bits: bits) else {
            pixelKit.logger.log(node: self, .error, .resource, "Pixel Buffer creation failed.")
            return
        }
        pixelBuffer = buffer
        pixelKit.logger.log(node: self, .info, .resource, "Image Loaded.")
        applyResolution { self.setNeedsRender() }
    }
    
}
