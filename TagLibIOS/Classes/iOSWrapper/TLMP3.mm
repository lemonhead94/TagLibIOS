//
//  TLFlac.mm
//  TagLibIOS
//
//  Created by lemonhead94 on 08/16/2018.
//  Copyright (c) 2018 lemonhead94. All rights reserved.
//

#import "TLMP3.h"
#include "fileref.h"
#include "mpegfile.h"
#include "id3v2tag.h"
#include "id3v2frame.h"
#include "id3v2header.h"
#include "attachedpictureframe.h"

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

@interface TLMP3 () {
    FileRef fileRef;
    TagLib::MPEG::File *file;
}

@end

@implementation TLMP3
@synthesize path=_path;

- (instancetype)initWithFileAtPath:(NSString *)path {
    if (self = [super init]) {
        _path = path;
        
        if (_path != nil) {
            fileRef = FileRef([path UTF8String]);
            file = (TagLib::MPEG::File *) fileRef.file();
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
    TagLib::ID3v2::FrameList frameList = file->ID3v2Tag()->frameListMap()["APIC"];
    TagLib::ID3v2::FrameList::Iterator it;
    
    for (it = frameList.begin(); it != frameList.end(); ++it) {
        TagLib::ID3v2::AttachedPictureFrame *picture = dynamic_cast<TagLib::ID3v2::AttachedPictureFrame *>(*it);
        if(picture->type() == TagLib::ID3v2::AttachedPictureFrame::FrontCover) {
            TagLib::ByteVector bv = picture->picture();
            return [NSData dataWithBytes:bv.data() length:bv.size()];
        }
    }
    return nil;
}

- (void)setFrontCoverPicture:(NSData *)data {
    if (data != nil && [data length] > 0) {
        TagLib::ID3v2::AttachedPictureFrame *picture = new TagLib::ID3v2::AttachedPictureFrame();
        TagLib::ByteVector bv = ByteVector((const char *)[data bytes], (int)[data length]);
        picture->setPicture(bv);
        picture->setMimeType([self mimeTypeByGuessingFromData:data]);
        picture->setType(TagLib::ID3v2::AttachedPictureFrame::FrontCover);
        
        ID3v2::Tag *tag = file->ID3v2Tag();
        if (tag) {
            tag->addFrame(picture);
        }
    }
}

- (NSData *)artistPicture {
    TagLib::ID3v2::FrameList frameList = file->ID3v2Tag()->frameListMap()["APIC"];
    TagLib::ID3v2::FrameList::Iterator it;
    
    for (it = frameList.begin(); it != frameList.end(); ++it) {
        TagLib::ID3v2::AttachedPictureFrame *picture = dynamic_cast<TagLib::ID3v2::AttachedPictureFrame *>(*it);
        if(picture->type() == TagLib::ID3v2::AttachedPictureFrame::Artist) {
            TagLib::ByteVector bv = picture->picture();
            return [NSData dataWithBytes:bv.data() length:bv.size()];
        }
    }
    return nil;
}

- (void)setArtistPicture:(NSData *)data {
    if (data != nil && [data length] > 0) {
        TagLib::ID3v2::AttachedPictureFrame *picture = new TagLib::ID3v2::AttachedPictureFrame();
        TagLib::ByteVector bv = ByteVector((const char *)[data bytes], (int)[data length]);
        picture->setPicture(bv);
        picture->setMimeType([self mimeTypeByGuessingFromData:data]);
        picture->setType(TagLib::ID3v2::AttachedPictureFrame::Artist);
        
        ID3v2::Tag *tag = file->ID3v2Tag();
        if (tag) {
            tag->addFrame(picture);
        }
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
    }
    
    return "application/octet-stream"; // default type
    
}

@end
