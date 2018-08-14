//
//  TagReader.h
//  TagLib-ObjC
//
//  Created by Me on 01/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TagReader : NSObject

- (id)initWithFileAtPath:(NSString *)path;  //Designated initializer
- (void)loadFileAtPath:(NSString *)path;

- (BOOL)save;
- (BOOL)doubleSave; //Some filetypes require being saved twice (unknown reasons), if saving with - save doesn't work, try -doubleSave.

@property (readonly) NSString *path;

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *artist;
@property (nonatomic) NSString *album;
@property (nonatomic) NSNumber *year;
@property (nonatomic) NSString *comment;
@property (nonatomic) NSNumber *track;
@property (nonatomic) NSString *genre;
@property (nonatomic) NSData *albumArt;

/*
 Audio properties section
 */

/*!
 * Returns the length of the file in seconds.
 */
- (NSNumber *)duration;

/*!
 * Returns the sample rate in Hz.
 */
- (NSNumber *)sampleRate;

/*!
 * Returns the most appropriate bit rate for the file in kb/s.  For constant
 * bitrate formats this is simply the bitrate of the file.  For variable
 * bitrate formats this is either the average or nominal bitrate.
 */
- (NSNumber *)bitRate;

/*!
 * Returns the number of audio channels.
 */
- (NSNumber *)channels;
@end
