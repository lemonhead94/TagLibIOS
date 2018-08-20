//
//  TLFlac.mm
//  TagLibIOS
//
//  Created by lemonhead94 on 08/16/2018.
//  Copyright (c) 2018 lemonhead94. All rights reserved.
//

#import "TLFlac.h"
#include "fileref.h"
#include "flacfile.h"

using namespace TagLib;

static inline NSString *NSStr(TagLib::String _string) {
    if (_string.isNull() == false) {
        return [NSString stringWithUTF8String:_string.toCString(true)];
    } else {
        return @"";
    }
}
static inline TagLib::String TLStr(NSString *_string) {
    return TagLib::String([_string UTF8String], TagLib::String::UTF8);
}

@interface TLFlac () {
    FileRef fileRef;
    TagLib::FLAC::File *file;
}

@end

@implementation TLFlac
@synthesize path=_path;

- (instancetype)initWithFileAtPath:(NSString *)path {
    if (self = [super init]) {
        _path = path;
        
        if (_path != nil) {
            fileRef = FileRef([path UTF8String]);
            file = (TagLib::FLAC::File *) fileRef.file();
        }
    }
    return self;
}

- (NSString *)title {
    return NSStr(file->tag()->title());
}

- (void)setTitle:(NSString *)title {
    file->tag()->setTitle(TLStr(title));
}

- (NSString *)artist {
    return NSStr(file->tag()->artist());
}

- (void)setArtist:(NSString *)artist {
    file->tag()->setArtist(TLStr(artist));
}

- (NSString *)album {
    return NSStr(file->tag()->album());
}

- (void)setAlbum:(NSString *)album {
    file->tag()->setAlbum(TLStr(album));
}

- (NSString *)comment {
    return NSStr(file->tag()->comment());
}

- (void)setComment:(NSString *)comment {
    file->tag()->setComment(TLStr(comment));
}

- (NSString *)genre {
    return NSStr(file->tag()->genre());
}

- (void)setGenre:(NSString *)genre {
    file->tag()->setGenre(TLStr(genre));
}

- (NSNumber *)year {
    return [NSNumber numberWithUnsignedInt:file->tag()->year()];
}

- (void)setYear:(NSNumber *)year {
    file->tag()->setYear([year unsignedIntValue]);
}

- (NSNumber *)track {
    return [NSNumber numberWithUnsignedInt:file->tag()->track()];
}

- (void)setTrack:(NSNumber *)track {
    file->tag()->setTrack([track unsignedIntValue]);
}

- (NSData *)frontCoverPicture {
    List<TagLib::FLAC::Picture *> pictureList = file->pictureList();
    List<TagLib::FLAC::Picture *>::Iterator it;
    for (it = pictureList.begin(); it != pictureList.end(); ++it){
        TagLib::FLAC::Picture *picture = dynamic_cast<TagLib::FLAC::Picture *>(*it);
        if(picture->type() == TagLib::FLAC::Picture::FrontCover) {
            TagLib::ByteVector bv = picture->data();
            return [NSData dataWithBytes:bv.data() length:bv.size()];
        }
    }
    return nil;
}

- (void)setFrontCoverPicture:(NSData *)data {
    if (data != nil && [data length] > 0) {
        TagLib::FLAC::Picture *picture = new TagLib::FLAC::Picture();
        TagLib::ByteVector bv = ByteVector((const char *)[data bytes], (int)[data length]);
        picture->setData(bv);
        picture->setType(TagLib::FLAC::Picture::FrontCover);
        picture->setMimeType([self mimeTypeByGuessingFromData:data]);
        file->addPicture(picture);
    }
}

- (NSData *)artistPicture {
    List<TagLib::FLAC::Picture *> pictureList = file->pictureList();
    List<TagLib::FLAC::Picture *>::Iterator it;
    for (it = pictureList.begin(); it != pictureList.end(); ++it){
        TagLib::FLAC::Picture *picture = dynamic_cast<TagLib::FLAC::Picture *>(*it);
        if(picture->type() == TagLib::FLAC::Picture::Artist) {
            TagLib::ByteVector bv = picture->data();
            return [NSData dataWithBytes:bv.data() length:bv.size()];
        }
    }
    return nil;
}

- (void)setArtistPicture:(NSData *)data {
    if (data != nil && [data length] > 0) {
        TagLib::ByteVector bv = ByteVector((const char *)[data bytes], (int)[data length]);
        TagLib::FLAC::Picture *picture = new TagLib::FLAC::Picture(bv);
        picture->setType(TagLib::FLAC::Picture::Artist);
        picture->setMimeType([self mimeTypeByGuessingFromData:data]);
        file->addPicture(picture);
    }
}

- (BOOL)save {
    return (BOOL) file->save();
}

// Private helper functions
- (String)mimeTypeByGuessingFromData:(NSData *)data {
    
    char bytes[12] = {0};
    [data getBytes:&bytes length:12];
    
    const char bmp[2] = {'B', 'M'};
    const char gif[3] = {'G', 'I', 'F'};
    const char swf[3] = {'F', 'W', 'S'};
    const char swc[3] = {'C', 'W', 'S'};
    const char jpg[3] = {static_cast<char>(0xff), static_cast<char>(0xd8), static_cast<char>(0xff)};
    const char psd[4] = {'8', 'B', 'P', 'S'};
    const char iff[4] = {'F', 'O', 'R', 'M'};
    const char webp[4] = {'R', 'I', 'F', 'F'};
    const char ico[4] = {0x00, 0x00, 0x01, 0x00};
    const char tif_ii[4] = {'I','I', 0x2A, 0x00};
    const char tif_mm[4] = {'M','M', 0x00, 0x2A};
    const char png[8] = {static_cast<char>(0x89), 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a};
    const char jp2[12] = {0x00, 0x00, 0x00, 0x0c, 0x6a, 0x50, 0x20, 0x20, 0x0d, 0x0a, static_cast<char>(0x87), 0x0a};
    const char flac[4] = {0x66, 0x4C, 0x61, 0x43};
    const char mp3_1[3] = {0x49, 0x44, 0x33};
    const char mp3_2[2] = {static_cast<char>(0xFF), 0xF};
    
    
    
    if (!memcmp(bytes, bmp, 2)) {
        return "image/x-ms-bmp";
    } else if (!memcmp(bytes, gif, 3)) {
        return "image/gif";
    } else if (!memcmp(bytes, jpg, 3)) {
        return "image/jpeg";
    } else if (!memcmp(bytes, psd, 4)) {
        return "image/psd";
    } else if (!memcmp(bytes, iff, 4)) {
        return "image/iff";
    } else if (!memcmp(bytes, webp, 4)) {
        return "image/webp";
    } else if (!memcmp(bytes, ico, 4)) {
        return "image/vnd.microsoft.icon";
    } else if (!memcmp(bytes, tif_ii, 4) || !memcmp(bytes, tif_mm, 4)) {
        return "image/tiff";
    } else if (!memcmp(bytes, png, 8)) {
        return "image/png";
    } else if (!memcmp(bytes, jp2, 12)) {
        return "image/jp2";
    } else if (!memcmp(bytes, flac, 4)) {
        return "audio/x-flac";
    } else if (!memcmp(bytes, mp3_1, 3) || !memcmp(bytes, mp3_2, 2)) {
        return "audio/mpeg";
    }
    
    return "application/octet-stream"; // default type
    
}

@end
