//
//  NetWork.h
//

#import <Foundation/Foundation.h>

@protocol NetWorkDelegate <NSObject>
- (void)requestDidFinished:(NSDictionary *)dic Error:(NSError *)error;
- (void)requestDidFailed:(NSDictionary *)dic;
- (void)connentStop;
@end


@interface NetWork : NSObject <NSURLConnectionDelegate>

@property (nonatomic, retain) NSMutableData *receiveData;
@property (nonatomic, assign) id<NetWorkDelegate> delegate;
@property (nonatomic, retain) NSURLConnection *urlConnection;
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, assign) NSInteger timeCon;
@property (nonatomic, assign)BOOL connentpage;

- (id)initWithURL:(NSString *)urlStr Method:(NSString *)method Params:(NSData *)params;

+ (id)netWorkWithUrl:(NSString *)urlStr Method:(NSString *)method Params:(NSData *)params;

- (void)cancelRequest;
@end
