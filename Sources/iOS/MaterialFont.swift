/*
* Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.io>.
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
*
*	*	Redistributions of source code must retain the above copyright notice, this
*		list of conditions and the following disclaimer.
*
*	*	Redistributions in binary form must reproduce the above copyright notice,
*		this list of conditions and the following disclaimer in the documentation
*		and/or other materials provided with the distribution.
*
*	*	Neither the name of Material nor the names of its
*		contributors may be used to endorse or promote products derived from
*		this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
* AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
* FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
* DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
* CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
* OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
* OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import UIKit

public protocol MaterialFontType {}

public struct MaterialFont : MaterialFontType {
	/**
	:name:	pointSize
	*/
	public static let pointSize: CGFloat = 16
	
	/**
	:name:	systemFontWithSize
	*/
	public static func systemFontWithSize(size: CGFloat) -> UIFont {
		return UIFont.systemFontOfSize(size)
	}
	
	/**
	:name:	boldSystemFontWithSize
	*/
	public static func boldSystemFontWithSize(size: CGFloat) -> UIFont {
		return UIFont.boldSystemFontOfSize(size)
	}
	
	/**
	:name:	italicSystemFontWithSize
	*/
	public static func italicSystemFontWithSize(size: CGFloat) -> UIFont {
		return UIFont.italicSystemFontOfSize(size)
	}
    
    public static func loadFontIfNeeded(fontName:String) {
        FontLoader.loadFontIfNeeded(fontName)
    }
}


private class FontLoader {
    
    static var loadedFonts:[String: String] = [:]
    
    static func loadFontIfNeeded(fontName:String) {
        let loadedFont = FontLoader.loadedFonts[fontName]
        if (loadedFont == nil && UIFont(name: fontName, size: 1) == nil) {
            FontLoader.loadedFonts[fontName] = fontName
            
            let bundle = NSBundle(forClass: FontLoader.self)
            var fontURL:NSURL? = nil
            let identifier = bundle.bundleIdentifier
            
            if identifier?.hasPrefix("org.cocoapods") == true {
                
                fontURL = bundle.URLForResource(fontName, withExtension: "ttf", subdirectory: "io.cosmicmind.material.fonts.bundle")
            } else {
                fontURL = bundle.URLForResource(fontName, withExtension: "ttf")
            }
            if fontURL != nil {
                let data = NSData(contentsOfURL: fontURL!)!
                
                let provider = CGDataProviderCreateWithCFData(data)
                let font = CGFontCreateWithDataProvider(provider)!
                
                var error: Unmanaged<CFError>?
                if !CTFontManagerRegisterGraphicsFont(font, &error) {
                    
                    let errorDescription: CFStringRef = CFErrorCopyDescription(error!.takeUnretainedValue())
                    let nsError = error!.takeUnretainedValue() as AnyObject as! NSError
                    NSException(name: NSInternalInconsistencyException, reason: errorDescription as String, userInfo: [NSUnderlyingErrorKey: nsError]).raise()
                }
            }
            
        }
    }
}