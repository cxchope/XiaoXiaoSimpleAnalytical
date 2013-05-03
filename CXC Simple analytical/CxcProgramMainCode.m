//
//  CxcProgramMainCode.m
//  CXC Simple analytical
//
//  Created by Terence Chen on 12-11-1.
//  Copyright (c) 2012年 Terence Chen. All rights reserved.
//

#import "CxcProgramMainCode.h"

@implementation CxcProgramMainCode
#pragma mark - 释放
- (void)dealloc {
	[mainSelectData release];
	[super dealloc];
}
#pragma mark - 程序启动
- (void) awakeFromNib
{
    txtStat.stringValue = [self generateTrid:@"进程" Message:@"应用程序正在初始化,请稍候..." OldMsg:txtStat.stringValue];
    indentation = @"    ";
    [self playing:NO];
    [proBar setIndeterminate:NO];
    mainSelectData=[[NSMutableArray alloc] init];
    [mainSelectData removeAllObjects];
    [mainSelectData addObject:@"操作说明："];
    [mainSelectData addObject:@"第一步：获取数据"];
    [mainSelectData addObject:@"    请在左侧“收集来源”中选择来源并填写参数。"];
    [mainSelectData addObject:@"    如果选择“网络”或者“本地文件”，请填好参数后按【获取数据】按钮。"];
    [mainSelectData addObject:@"    如果选择“输入”，请直接在左侧“待转换信息”中填写或粘贴JSON串。"];
    [mainSelectData addObject:@"    如果选择“网络”或者“本地文件”，请在【获取数据】后继续。“输入”则不用。"];
    [mainSelectData addObject:@"    字典型使用“{}”，数组型使用“[]”或“()”都可以。值使用“ "":"" ”格式。"];
    [mainSelectData addObject:@"第二步：开始解析"];
    [mainSelectData addObject:@"    检查左侧“待转换信息”中是JSON串。然后点击【开始解析】按钮。"];
    [mainSelectData addObject:@"    程序会自动修复JSON串中前后多余字符和其中的无用全/半角空格。"];
    [mainSelectData addObject:@"    如果遇到错误或警告，请查看“输出”栏显示的信息。成功的话再继续。"];
    [mainSelectData addObject:@"第三步：生成代码"];
    [mainSelectData addObject:@"    在本列表单击选中要提取的内容，然后点击【生成代码】按钮。"];
    [mainSelectData addObject:@"    在“转换结果”栏中将显示生成的 Object-C 语言代码。"];
//    [mainSelectData addObject:@"有关更多信息，请点击【关于与帮助】按钮。"];
    [mainSelectData addObject:@"  霄霄作品  www.heartunlock.com/soft/easyjson  im@chenxiaochi.com"];
    [mainSelectList reloadData];
    txtStat.stringValue = [self generateTrid:@"成功" Message:@"应用程序初始化完毕。" OldMsg:txtStat.stringValue];
}
#pragma mark 状态提示
- (NSString *)generateTrid:(NSString *)info Message:(NSString *)message OldMsg:(NSString *)his
{
    NSLog(@"[%@]%@",info,message);
    //获得当前时间
    NSDate *date = [NSDate date];
    //格式化
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    if ([info isEqualToString:@"错误"]) {
        txtE.stringValue = [NSString stringWithFormat:@"错误 = TRUE\n\n由于出现了一个或多个错误，无统计信息。\n\n错误信息(详情请看输出窗口)：\n%@",message];
    }
    return [NSString stringWithFormat:@"%@[%@ %@]\n%@\n",his,[formater stringFromDate:date],info,message];
}
#pragma mark - 行数
-(int)numberOfRowsInTableView:(NSTableView *)tv
{
	return (int)[mainSelectData count]; //以数组长度设置行数
}
#pragma mark 内容出现的时候(多次调用)
-(id)tableView:(NSTableView *)tv objectValueForTableColumn:(NSTableColumn *)tableColumn row:(int)row
{
    NSString *nsTemp = (NSString*)[mainSelectData objectAtIndex:row];
    return nsTemp;
}
#pragma mark 当被更改时
- (void)tableView:(NSTableView *)aTableView setObjectValue:(id)anObject forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
    NSLog(@"%s",__FUNCTION__);
}
#pragma mark - 生成按钮
- (IBAction)btnGenerate:(id)sender
{
    [self generateNow:textBox.stringValue];
}
#pragma mark 生成操作
- (void)generateNow:(NSString *)text
{
    txtStat.stringValue = @"";
    txtStat.stringValue = [self generateTrid:@"进程" Message:@"开始解析JSON串……" OldMsg:txtStat.stringValue];
    txtStat.stringValue = [self generateTrid:@"信息" Message:@"JSON串解析类:内建1.0" OldMsg:txtStat.stringValue];
    [btnStop setEnabled:YES];
    BOOL errorNow = FALSE;
    BOOL valueNow = FALSE;
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    NSString *tempString =  [[NSString alloc] init];
    NSString *tempString2 = [[NSString alloc] init];
    NSString *tempString3 = [[NSString alloc] init];
    NSString *tempKeyS = [[NSString alloc] init];
    NSString *tempKeyE = [[NSString alloc] init];
    NSUInteger orgChar = 0;
    NSUInteger levelnum = 0;
    NSUInteger warnings = 0;
    txtStat.stringValue = [self generateTrid:@"信息" Message:[NSString stringWithFormat:@"信息长度：%ld个字。",[text length]] OldMsg:txtStat.stringValue];
    //删除段前空格
    if (!errorNow)
    {
        errorNow = TRUE;
        txtStat.stringValue = [self generateTrid:@"进程" Message:@"正在检查数据前面是否有多余字符……" OldMsg:txtStat.stringValue];
        for (int i = 0; i < [text length]; i++) {
            NSString *nowChar = [text substringWithRange:NSMakeRange(i, 1)];
            if ([nowChar isEqualToString:@"{"] || [nowChar isEqualToString:@"["] || [nowChar isEqualToString:@"("])
            {
                errorNow = FALSE;
            } else {
                if (errorNow) {
                    orgChar++;
                }
            }
        }
        if (errorNow) {
            txtStat.stringValue = [self generateTrid:@"错误" Message:@"输入的数据不是JSON格式！操作中止。" OldMsg:txtStat.stringValue];
        } else {
            tempString = [text substringWithRange:NSMakeRange(orgChar, [text length]-orgChar)];
            if (orgChar != 0) {
                txtStat.stringValue = [self generateTrid:@"警告" Message:[NSString stringWithFormat:@"在信息前端发现%ld个无用文字。已经自动修复。",orgChar] OldMsg:txtStat.stringValue];
                warnings++;
            } else {
                txtStat.stringValue = [self generateTrid:@"成功" Message:@"数据前面没有多余字符。" OldMsg:txtStat.stringValue];
            }
            orgChar = 0;
        }
    }
    //删除段后空格
    if (!errorNow)
    {
        errorNow = TRUE;
        txtStat.stringValue = [self generateTrid:@"进程" Message:@"正在检查数据后面是否有多余字符……" OldMsg:txtStat.stringValue];
        for (NSUInteger i = [tempString length]-1; i > 0; i--) {
            NSString *nowChar = [tempString substringWithRange:NSMakeRange(i, 1)];
            if ([nowChar isEqualToString:@"}"] || [nowChar isEqualToString:@"]"] || [nowChar isEqualToString:@")"])
            {
                errorNow = FALSE;
            } else {
                if (errorNow) {
                    orgChar++;
                }
            }
        }
        if (errorNow) {
            txtStat.stringValue = [self generateTrid:@"错误" Message:@"输入的数据不是JSON格式！操作中止。" OldMsg:txtStat.stringValue];
        } else {
            tempString = [tempString substringWithRange:NSMakeRange(0, [tempString length]-orgChar)];
            if (orgChar != 0) {
                txtStat.stringValue = [self generateTrid:@"警告" Message:[NSString stringWithFormat:@"在信息尾端发现%ld个无用文字。已经自动修复。",orgChar] OldMsg:txtStat.stringValue];
                warnings++;
            } else {
                txtStat.stringValue = [self generateTrid:@"成功" Message:@"数据后面没有多余字符。" OldMsg:txtStat.stringValue];
            }
            orgChar = 0;
        }
    }
    //删除间隙空格
    if (!errorNow)
    {
        txtStat.stringValue = [self generateTrid:@"进程" Message:@"正在检查间隙中的多余空格……" OldMsg:txtStat.stringValue];
        valueNow = FALSE;
        for (int i = 0; i < [tempString length]; i++) {
            NSString *nowChar = [tempString substringWithRange:NSMakeRange(i, 1)];
            //if ([nowChar isEqualToString:@"{"] || [nowChar isEqualToString:@"["] || [nowChar isEqualToString:@"("] || [nowChar isEqualToString:@"}"] || [nowChar isEqualToString:@"]"] || [nowChar isEqualToString:@")"])
            if ([nowChar isEqualToString:@"\""]) {
                valueNow = !valueNow;
            }
            if (([nowChar isEqualToString:@" "] || [nowChar isEqualToString:@"　"]) && (!valueNow)) {
                orgChar++;
            } else {
                tempString2 = [NSString stringWithFormat:@"%@%@",tempString2,nowChar];
            }
        }
        if (orgChar != 0) {
            txtStat.stringValue = [self generateTrid:@"警告" Message:[NSString stringWithFormat:@"在信息中发现%ld个无用空格。已经自动修复。",orgChar] OldMsg:txtStat.stringValue];
            warnings++;
        } else {
            txtStat.stringValue = [self generateTrid:@"成功" Message:@"数据中没有发现无用空格。" OldMsg:txtStat.stringValue];
        }
        tempString = tempString2;
//        NSLog(@"tempString=%@",tempString);
        orgChar = 0;
    }
    //核对
    if (!errorNow)
    {
        //准备核对
        for (int i = 0; i < [tempString length]; i++) {
            NSString *nowChar = [tempString substringWithRange:NSMakeRange(i, 1)];
            if ([nowChar isEqualToString:@"{"]) {
                tempKeyS = [NSString stringWithFormat:@"%@%@",tempKeyS,nowChar];
            } else if ([nowChar isEqualToString:@"["] || [nowChar isEqualToString:@"("]) {
                tempKeyS = [NSString stringWithFormat:@"%@%@",tempKeyS,nowChar];
            } else if ([nowChar isEqualToString:@"}"]) {
                tempKeyE = [NSString stringWithFormat:@"%@%@",nowChar,tempKeyE];
            } else if ([nowChar isEqualToString:@"]"] || [nowChar isEqualToString:@")"]) {
                tempKeyE = [NSString stringWithFormat:@"%@%@",nowChar,tempKeyE];
            }
        }
        txtStat.stringValue = [self generateTrid:@"进程" Message:@"开始核对关键字标记……" OldMsg:txtStat.stringValue];
        NSUInteger arrayS = 0;
        NSUInteger arrayE = 0;
        NSUInteger dictionaryS = 0;
        NSUInteger dictionaryE = 0;
        NSString *nowCharS = @"NA";
        NSString *nowCharE = @"NA";
        NSUInteger maxLength = [tempKeyS length];
        if ([tempKeyE length] > [tempKeyS length]) {
            maxLength = [tempKeyE length];
        }
        for (int i = 0; i < maxLength; i++) {
            if (i < [tempKeyS length]) { //<=
                nowCharS = [tempKeyS substringWithRange:NSMakeRange(i, 1)];
            } else {
                nowCharS = @"NA";
            }
            if ([nowCharS isEqualToString:@"{"]) {
                dictionaryS++;
            } else if ([nowCharS isEqualToString:@"["] || [nowCharS isEqualToString:@"("]) {
                arrayS++;
            }
            if (i < [tempKeyE length]) { //<=
                nowCharE = [tempKeyE substringWithRange:NSMakeRange(i, 1)];
            } else {
                nowCharE = @"NA";
            }
            if ([nowCharE isEqualToString:@"}"]) {
                dictionaryE++;
            } else if ([nowCharE isEqualToString:@"]"] || [nowCharE isEqualToString:@")"]) {
                arrayE++;
            }
        }
        if (arrayS < arrayE) {
            errorNow = TRUE;
            txtStat.stringValue = [self generateTrid:@"错误" Message:@"语法错误：缺少数组开始“[”或“(”。" OldMsg:txtStat.stringValue];
        }
        if(dictionaryS < dictionaryE) {
            errorNow = TRUE;
            txtStat.stringValue = [self generateTrid:@"错误" Message:@"语法错误：缺少字典开始“{”。" OldMsg:txtStat.stringValue];
        }
        if (arrayS > arrayE) {
            errorNow = TRUE;
            txtStat.stringValue = [self generateTrid:@"错误" Message:@"语法错误：缺少数组结束“]”或“)”。" OldMsg:txtStat.stringValue];
        }
        if (dictionaryS > dictionaryE) {
            errorNow = TRUE;
            txtStat.stringValue = [self generateTrid:@"错误" Message:@"语法错误：缺少字典结束“}”。" OldMsg:txtStat.stringValue];
        }
        if (!errorNow) {
            txtStat.stringValue = [self generateTrid:@"成功" Message:@"核对关键字标记完成。" OldMsg:txtStat.stringValue];
        }
    }
    //列表和整理
    if (!errorNow)
    {
        txtStat.stringValue = [self generateTrid:@"进程" Message:@"正在分析层级结构……" OldMsg:txtStat.stringValue];
        valueNow = FALSE;
        [tempArray removeAllObjects];
        for (int i = 0; i < [tempString length]; i++) {
            NSString *nowChar = [tempString substringWithRange:NSMakeRange(i, 1)];
            if ([nowChar isEqualToString:@"\""]) {
                valueNow = !valueNow;
            }
            if ([nowChar isEqualToString:@"{"]) {
                tempKeyS = [NSString stringWithFormat:@"%@%@",tempKeyS,nowChar];
                if (![tempString2 isEqualToString:@""]) {
                    tempString3 = @"";
                    for (int j = 0; j < levelnum; j++) {
                        tempString3 = [NSString stringWithFormat:@"%@%@",tempString3,indentation];
                    }
                    tempString2 = [NSString stringWithFormat:@"%@%@",tempString3,tempString2];
                    [tempArray addObject:tempString2];
                }
                tempString3 = @"";
                for (int j = 0; j < levelnum; j++) {
                    tempString3 = [NSString stringWithFormat:@"%@%@",tempString3,indentation];
                }
                tempString2 = [NSString stringWithFormat:@"%@%@",tempString3,nowChar];
                [tempArray addObject:tempString2];
                tempString2 = @"";
                levelnum++;
            } else if ([nowChar isEqualToString:@"["] || [nowChar isEqualToString:@"("]) {
                tempKeyS = [NSString stringWithFormat:@"%@%@",tempKeyS,nowChar];
                if (![tempString2 isEqualToString:@""]) {
                    tempString3 = @"";
                    for (int j = 0; j < levelnum; j++) {
                        tempString3 = [NSString stringWithFormat:@"%@%@",tempString3,indentation];
                    }
                    tempString2 = [NSString stringWithFormat:@"%@%@",tempString3,tempString2];
                    [tempArray addObject:tempString2];
                }
                tempString3 = @"";
                for (int j = 0; j < levelnum; j++) {
                    tempString3 = [NSString stringWithFormat:@"%@%@",tempString3,indentation];
                }
                tempString2 = [NSString stringWithFormat:@"%@%@",tempString3,nowChar];
                [tempArray addObject:tempString2];
                tempString2 = @"";
                levelnum++;
            } else if ([nowChar isEqualToString:@"}"]) {
                tempKeyE = [NSString stringWithFormat:@"%@%@",nowChar,tempKeyE];
                if (![tempString2 isEqualToString:@""]) {
                    tempString3 = @"";
                    for (int j = 0; j < levelnum; j++) {
                        tempString3 = [NSString stringWithFormat:@"%@%@",tempString3,indentation];
                    }
                    tempString2 = [NSString stringWithFormat:@"%@%@",tempString3,tempString2];
                    [tempArray addObject:tempString2];
                }
                tempString3 = @"";
                for (int j = 0; j < levelnum-1; j++) {
                    tempString3 = [NSString stringWithFormat:@"%@%@",tempString3,indentation];
                }
                tempString2 = [NSString stringWithFormat:@"%@%@",tempString3,nowChar];
                [tempArray addObject:tempString2];
                tempString2 = @"";
                levelnum--;
            } else if ([nowChar isEqualToString:@"]"] || [nowChar isEqualToString:@")"]) {
                tempKeyE = [NSString stringWithFormat:@"%@%@",nowChar,tempKeyE];
                if (![tempString2 isEqualToString:@""]) {
                    tempString3 = @"";
                    for (int j = 0; j < levelnum; j++) {
                        tempString3 = [NSString stringWithFormat:@"%@%@",tempString3,indentation];
                    }
                    tempString2 = [NSString stringWithFormat:@"%@%@",tempString3,tempString2];
                    [tempArray addObject:tempString2];
                }
                tempString3 = @"";
                for (int j = 0; j < levelnum-1; j++) {
                    tempString3 = [NSString stringWithFormat:@"%@%@",tempString3,indentation];
                }
                tempString2 = [NSString stringWithFormat:@"%@%@",tempString3,nowChar];
                [tempArray addObject:tempString2];
                tempString2 = @"";
                levelnum--;
            } else if ([nowChar isEqualToString:@","] && (!valueNow)) {
                if (![tempString2 isEqualToString:@""]) {
                    tempString3 = @"";
                    for (int j = 0; j < levelnum; j++) {
                        tempString3 = [NSString stringWithFormat:@"%@%@",tempString3,indentation];
                    }
                    tempString2 = [NSString stringWithFormat:@"%@%@",tempString3,tempString2];
                    [tempArray addObject:tempString2];
                }
                tempString3 = @"";
                for (int j = 0; j < levelnum; j++) {
                    tempString3 = [NSString stringWithFormat:@"%@%@",tempString3,indentation];
                }
                tempString2 = [NSString stringWithFormat:@"%@%@",tempString3,nowChar];
                [tempArray addObject:tempString2];
                tempString2 = @"";
            }
            else {
                tempString2 = [NSString stringWithFormat:@"%@%@",tempString2,nowChar];
            }
        }
        txtStat.stringValue = [self generateTrid:@"成功" Message:@"分析层级结构完成。" OldMsg:txtStat.stringValue];
//        [tempArray removeObjectAtIndex:0];
    }
    //列表和整理
    if (!errorNow)
    {
        txtStat.stringValue = [self generateTrid:@"进程" Message:@"统计数据……" OldMsg:txtStat.stringValue];
        NSUInteger hangshu = 0;
        NSUInteger guolvzifu = 0;
        NSUInteger zuigaocengji = 0;
        NSUInteger shuju = 0;
        NSUInteger zidian = 0;
        [tempArray removeObjectAtIndex:0];
        txtE.stringValue=[NSString stringWithFormat:@"行数：%ld",[tempArray count]];
    } else {
        txtStat.stringValue = [self generateTrid:@"失败" Message:@"由于出现了错误，程序不再继续。请检查输入或获得的JSON串是正确的。" OldMsg:txtStat.stringValue];
    }
//    [self playing:NO];dsfhdsgiohdfsoighd
    [mainSelectData removeAllObjects];
    [mainSelectData addObjectsFromArray:tempArray];
    [mainSelectList reloadData];
}
#pragma mark - 暂停和恢复交互
- (void)playing:(BOOL)playnext
{
    [btnStop setEnabled:playnext];
    [btnStart setEnabled:!playnext];
    [btnGenerate setEnabled:!playnext];
    [btnCode setEnabled:!playnext];
    [btnRepair setEnabled:!playnext];
}
@end
