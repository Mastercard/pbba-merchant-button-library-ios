//
//  PBBANetworkService.m
//  ZappMerchantLib
//
//  Created by Ecaterina Raducan on 25/09/2018.
//  Copyright © 2018 Vocalink. All rights reserved.
//

#import "PBBANetworkService.h"

static NSString* PBBALogosSorageLink = @"";

@implementation PBBANetworkService
@synthesize url;

+ (PBBANetworkService *)serviceWithURL:(NSURL *)url
{
    PBBANetworkService *service = [PBBANetworkService new];
    service.url = url;
    return service;
}

- (void)getBankLogosWithBlock:(serviceCompletionBlock)block
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"CDNUrl"]) {
        PBBALogosSorageLink = [[NSUserDefaults standardUserDefaults] objectForKey:@"CDNUrl"];
    }
    NSURL *url = [NSURL URLWithString:PBBALogosSorageLink];
    NSError *error = nil;
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    if (data) {
        NSMutableArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        block(array ? array : nil, error ? error : nil);
    } else block(nil,[NSError errorWithDomain:@"No URL contents" code:404 userInfo:@{NSLocalizedDescriptionKey:@"URL does not contain any data"}]);
}

        
@end
