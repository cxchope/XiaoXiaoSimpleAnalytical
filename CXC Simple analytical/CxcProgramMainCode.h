//
//  CxcProgramMainCode.h
//  CXC Simple analytical
//
//  Created by Terence Chen on 12-11-1.
//  Copyright (c) 2012年 Terence Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CxcProgramMainCode : NSObject {
    IBOutlet NSTableView *mainSelectList; //列表框
    NSMutableArray *mainSelectData; //列表框数据
    
    IBOutlet NSButton *btnStart; //获取数据按钮
    IBOutlet NSButton *btnStop; //停止任务按钮
    IBOutlet NSButton *btnGenerate; //开始解析按钮
    IBOutlet NSButton *btnCode; //生成代码按钮
    IBOutlet NSButton *btnRepair; //数据修复按钮
    
    IBOutlet NSSegmentedControl *setMode; //模式
    IBOutlet NSProgressIndicator *proBar; //进度条
    IBOutlet NSButton *btnHelp; //帮助按钮
    IBOutlet NSSegmentedControl *setData; //设置来源
    IBOutlet NSTextField *txtAddress; //参数路径
    IBOutlet NSButton *isPost; //需要隐式提交
    IBOutlet NSTextField *txtPost; //隐式提交的参数
    IBOutlet NSButton *sendFirst; //发送预先指令
    IBOutlet NSTextField *textBox; //待转换信息
    IBOutlet NSTextField *txtOutput; //转换结果
    IBOutlet NSTextField *txtStat; //状态输出
    IBOutlet NSTextField *helpTitle; //帮助标题
    IBOutlet NSTextField *helpTxt; //帮助内容
    IBOutlet NSTextField *txtE; //统计信息
    NSUInteger BugCheck;
    NSString *indentation; //缩进字符
}


@end
