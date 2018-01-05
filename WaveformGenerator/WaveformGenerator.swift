//
//  WaveformGenerator.swift
//  WaveformGenerator
//
//  Created by Alexey Savchenko on 04.01.2018.
//  Copyright © 2018 Alexey Savchenko. All rights reserved.
//

import Foundation
import Cocoa

class WaveformGenerator {
  
  public func drawItems(bounds: CGRect, block: (CGRect, CGContext) -> () ) -> NSImage? {
    var outputImage: NSImage? = nil
    let insetSize = CGSize(width: -20, height: -20)
    let insetBounds = bounds.insetBy(dx: insetSize.width, dy: insetSize.height)
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
    let bitmapContext = CGContext(
      data: nil,
      width: Int(insetBounds.size.width),
      height: Int(insetBounds.size.height),
      bitsPerComponent: 8,
      bytesPerRow: 0,
      space: colorSpace,
      bitmapInfo: bitmapInfo.rawValue)
    
    if let context = bitmapContext {
      context.concatenate(CGAffineTransform(translationX: -insetSize.width, y: -insetSize.height))
      context.concatenate(CGAffineTransform(translationX: -bounds.origin.x, y: -bounds.origin.y))
      
      block(bounds, context)
      
      if let image = context.makeImage() {
        outputImage = NSImage(cgImage: image, size: insetBounds.size)
      }
    }
    
    return outputImage
  }
  
  // example drawing function
  func drawSquare(bounds: CGRect, context: CGContext) {
    
    let path = CGPath(rect: bounds, transform: nil)
    
    context.addPath(path)
    context.setStrokeColor(NSColor.red.cgColor)
    context.setLineWidth(20)
    context.setLineJoin(.round)
    context.setLineCap(.round)
    
    let dashArray:[CGFloat] = [16, 32]
    context.setLineDash(phase: 0, lengths: dashArray)
    context.replacePathWithStrokedPath()
    
    context.setFillColor(NSColor.red.cgColor)
    context.fillPath()
    
  }
  
  func drawWaveform(bounds: CGRect, context: CGContext) {
    
    
    

    
  }
  
  func generateWaveformFromAudioData(_ audioData: [Float],
                                     metadata: AudioMetadata) -> NSImage? {
    
    
    let baseDataCount = audioData.count
    
    let baseRect = CGRect(x: 0, y: 0, width: baseDataCount, height: lrintf(audioData.max()!))
    
    let workingRect = baseRect.applying(CGAffineTransform(scaleX: 1.1, y: 1.1))
    
    var outputImage: NSImage? = nil
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
    let bitmapContext = CGContext(
      data: nil,
      width: Int(workingRect.size.width),
      height: Int(workingRect.size.height),
      bitsPerComponent: 8,
      bytesPerRow: 0,
      space: colorSpace,
      bitmapInfo: bitmapInfo.rawValue)
    
    var offset: CGFloat = 0
    
    if let context = bitmapContext {

      for dataPoint in audioData {
        
        let barRect = CGRect(x: offset,
                             y: workingRect.midY - CGFloat(dataPoint),
                             width: CGFloat(1.0),
                             height: CGFloat(dataPoint))
        
        let barPath = CGPath(rect: barRect, transform: nil)
        
        context.addPath(barPath)
        offset += 1
      }
      
      context.setFillColor(NSColor.red.cgColor)
      context.fillPath()
      
      if let image = context.makeImage() {
        outputImage = NSImage(cgImage: image, size: workingRect.size)
      }
      
    }
    
    return outputImage
    
    
    
    
    
    
    
    
    

    


    
    
  }
  
}