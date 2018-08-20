//
//  TLAudioe.mm
//  TagLibIOS
//
//  Created by lemonhead94 on 08/16/2018.
//  Copyright (c) 2018 lemonhead94. All rights reserved.
//

#import "TLAudio.h"
#import "TLFlac.h"
#import "TLMP3.h"

@interface TLAudio () {
    TLAudio *file;
}

@end

@implementation TLAudio
@synthesize path=_path;

- (instancetype)initWithFileAtPath:(NSString *)path {
    
    if (self = [super init]) {
        _path = path;
        
        if (_path != nil) {
            [self setAudioTypeFromData: path];
        }
    }
    return self;
}

- (NSString *)title {
    return file.title;
}

- (void)setTitle:(NSString *)title {
    file.title = title;
}

- (NSString *)artist {
    return file.artist;
}

- (void)setArtist:(NSString *)artist {
    file.artist = artist;
}

- (NSString *)album {
    return file.album;
}

- (void)setAlbum:(NSString *)album {
    file.album = album;
}

- (NSString *)comment {
    return file.comment;
}

- (void)setComment:(NSString *)comment {
    file.comment = comment;
}

- (NSString *)genre {
    return file.genre;
}

- (void)setGenre:(NSString *)genre {
    file.genre = genre;
}

- (NSNumber *)year {
    return file.year;
}

- (void)setYear:(NSNumber *)year {
    file.year = year;
}

- (NSNumber *)track {
    return file.track;
}

- (void)setTrack:(NSNumber *)track {
    file.track = track;
}

- (NSData *)frontCoverPicture {
    return file.frontCoverPicture;
}

- (void)setFrontCoverPicture:(NSData *)data {
    file.frontCoverPicture = data;
}

- (NSData *)artistPicture {
    return file.artistPicture;
}

- (void)setArtistPicture:(NSData *)data {
    file.artistPicture = data;
}

- (BOOL)save {
    return file.save;
}

// Private helper functions
- (void)setAudioTypeFromData:(NSString *)path {
    
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
    char bytes[4] = {0};
    [data getBytes:&bytes length:4];
    
    const char flac[4] = {0x66, 0x4C, 0x61, 0x43};
    const char mp3_1[3] = {0x49, 0x44, 0x33};
    const char mp3_2[2] = {static_cast<char>(0xFF), 0xF};

    if (!memcmp(bytes, flac, 4)) {
        file = [[TLFlac alloc] initWithFileAtPath: path];
    } else if (!memcmp(bytes, mp3_1, 3) || !memcmp(bytes, mp3_2, 2)) {
        file = [[TLMP3 alloc] initWithFileAtPath: path];
    }
}

@end
