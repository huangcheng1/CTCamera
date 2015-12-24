//
//  Configuration.h
//  Pods
//
//  Created by 黄成 on 15/12/21.
//
//

#ifndef Configuration_h
#define Configuration_h

#define CTCameraLoc(key) NSLocalizedStringWithDefaultValue((key), @"localization", [NSBundle bundleWithPath:[[NSBundle mainBundle]pathForResource:@"CTCamera" ofType:@"bundle"]]?:[NSBundle mainBundle], nil, nil)

#define CTCameraImage(key) [NSString stringWithFormat:@"CTCamera.bundle/%@",(key)]


#define RGBColor(rgbValue, alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue]


#define IS_RETINA_4 ( [[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2 && [[UIScreen mainScreen] bounds].size.height > 480)

#endif /* Configuration_h */
