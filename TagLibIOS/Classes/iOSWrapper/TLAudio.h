//
//  TLAudio.h
//  TagLibIOS
//
//  Created by lemonhead94 on 08/16/2018.
//  Copyright (c) 2018 lemonhead94. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TLAudio: NSObject

- (instancetype)initWithFileAtPath:(NSString *)path;
- (BOOL)save;

@property (readonly)  NSString *path;

// Wrappers
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *artist;
@property (nonatomic) NSString *album;
@property (nonatomic) NSString *comment;
@property (nonatomic) NSString *genre;
@property (nonatomic) NSNumber *year;
@property (nonatomic) NSNumber *track;
@property (nonatomic) NSData *frontCoverPicture;
@property (nonatomic) NSData *artistPicture;

@end
