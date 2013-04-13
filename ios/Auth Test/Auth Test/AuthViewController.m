//
//  AuthViewController.m
//  Auth Test
//
//  Created by Kyle Olivo on 4/13/13.
//  Copyright (c) 2013 The Giffy Group. All rights reserved.
//

#import "AuthViewController.h"

@interface AuthViewController ()
@property (nonatomic) NSMutableArray *receivedData;
@end

@implementation AuthViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
//    NSDictionary *creds = [NSDictionary dictionaryWithObjectsAndKeys:[NSDictionary dictionaryWithObjectsAndKeys:@"kyletest", @"UserName", @"123456",  @"Password",  @"123456", @"ConfirmPassword", nil], @"data", nil];
//    NSData *json = [NSJSONSerialization dataWithJSONObject:creds options:NSJSONWritingPrettyPrinted error:nil];
//    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:json options:kNilOptions error:nil];
//    NSString *jsonUser = [[data objectForKey:@"data"] objectForKey: @"UserName"];
//    NSLog(@"json: %@", jsonUser);
//    
//    NSURL *url = [NSURL URLWithString:@"http://giffy.azurewebsites.net/api/register"];
//    
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
//                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
//    
//    [request setHTTPMethod:@"POST"];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request setValue:[NSString stringWithFormat:@"%d", [json length]] forHTTPHeaderField:@"Content-Length"];
//    [request setHTTPBody: json];
//    
//    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
//    if (connection) {
//        
//    } else {
//        NSLog(@"No connection.");
//    }
//    
//    NSLog(@"json: %@", jsonUser);
    
    // Now try to authenticate
    
    NSDictionary *creds = [NSDictionary dictionaryWithObjectsAndKeys:[NSDictionary dictionaryWithObjectsAndKeys:@"test123", @"UserName", @"test123",  @"Password", nil], @"data", nil];
    NSData *json = [NSJSONSerialization dataWithJSONObject:creds options:NSJSONWritingPrettyPrinted error:nil];
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:json options:kNilOptions error:nil];
    NSString *jsonUser = [[data objectForKey:@"data"] objectForKey: @"UserName"];
    NSLog(@"json: %@", jsonUser);
    
    NSURL *url = [NSURL URLWithString:@"http://giffy.azurewebsites.net/api/login"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [json length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: json];
    
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if (connection) {
        self.receivedData = [NSMutableData data];
        NSLog(@"%@", self.receivedData);
    } else {
        NSLog(@"No connection.");
    }
    
    // Check a page that requires authentication
    NSError *error = nil;
    NSURL *responseURL = [NSURL URLWithString:@"http://giffy.azurewebsites.net/Account/Manage"];
    NSString *jsonresponse = [NSString stringWithContentsOfURL:responseURL
                                              encoding:NSASCIIStringEncoding
                                                 error:&error];
    //NSLog(@"\nJSON: %@ \n Error: %@", jsonresponse, error);
    
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", [error localizedDescription]);
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    NSLog(@"Challenged.");
}

@end
