//
//  NetWork.m
//

#import "NetWork.h"

@implementation NetWork

- (id)initWithURL:(NSString *)urlStr Method:(NSString *)method Params:(NSData *)params
{
    self = [super init];
    if (self) {
        self.timeCon = 0;
        if ([method isEqualToString:@"GET"]) {
            self.connentpage=NO;
            //请求路径
            NSURL *url = [NSURL URLWithString:urlStr];
            //定义请求
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
            //定义请求方式
            [request setHTTPMethod:method];
            //发送请求
            self.urlConnection = [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
        }else if ([method isEqualToString:@"POST"]){
            self.connentpage=YES;
            //请求路径
            NSURL *url = [NSURL URLWithString:urlStr];
            //定义请求
             NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
            //定义请求方式
            [request setHTTPMethod:method];
            //定义请求参数
            [request setHTTPBody:params];
            //发送请求
            self.urlConnection = [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
//            [NSURLConnection connectionWithRequest:request delegate:self];
        }
        self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(urlConnectionStop) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)urlConnectionStop
{
    [self.urlConnection cancel];
    [self.timer invalidate];
}

+ (id)netWorkWithUrl:(NSString *)urlStr Method:(NSString *)method Params:(NSData *)params
{
    NetWork *net_work=[[NetWork alloc] initWithURL:urlStr Method:method Params:params];
    return [net_work autorelease];
}

#pragma - connection delegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.receiveData = [NSMutableData data];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receiveData appendData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error;
    
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:self.receiveData options:NSJSONWritingPrettyPrinted error:&error];
    
    if (self.connentpage) {
        [self.delegate requestDidFinished:data Error:error];
    }else{
         /* 由于此处接收到的data,并不是标准的json格式,所以需要对其进⾏行修改 */
        NSMutableString *receiveStr = [[NSMutableString alloc] initWithData:self.receiveData encoding:NSUTF8StringEncoding];
        //******此处开始 对json字符串进⾏行修改
        NSRange ra;
        ra = [receiveStr rangeOfString:@"{"]; NSRange delRa;
        delRa.location = 0;
        if (ra.length == 0){
            delRa.length = 0;
        }else{
            delRa.length = ra.location;
        }
        [receiveStr deleteCharactersInRange:delRa]; //******修改结束
        //转化成可⽤用的字典
        NSDictionary *dic = (NSDictionary *)[receiveStr mutableObjectFromJSONString];
        [receiveStr release];
        
        [self.delegate requestDidFinished:dic Error:error];
    }
    
    [self cancelRequest];
   
}

- (void)cancelRequest
{
    [self.urlConnection cancel];
    [self.timer invalidate];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
//    NSError *serverError;
//    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:self.receiveData options:NSJSONWritingPrettyPrinted error:&serverError];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:self.receiveData,@"receiveData",error,@"request_error", nil];
    [self.delegate requestDidFailed:dic];
    [dic release];
}

- (void)dealloc
{
    [_receiveData release];
    [_urlConnection release];
    [_timer release];
    [super dealloc];
}
@end
