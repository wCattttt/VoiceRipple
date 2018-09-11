//
//  ViewController.m
//  VoiceRipple
//
//  Created by 魏唯隆 on 2018/9/10.
//  Copyright © 2018年 魏唯隆. All rights reserved.
//

#import "ViewController.h"
#import "RippleView.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()<AVAudioRecorderDelegate>
{
    __weak IBOutlet RippleView *_rippleView;
    __weak IBOutlet UILabel *_valueLabel;
    __weak IBOutlet UIButton *_voiceBt;
    
    AVAudioRecorder *audioRecorder;
    NSTimer *_timer;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initVoice];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [self detectionVoice];
    }];
}

- (void)_initVoice {
    // 初始化录音参数
    NSDictionary *recordSetting = [self audioParamSetting];
    
    NSString *strUrl = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Video.pcm", strUrl]];
    
    NSError *error;
    //初始化
    audioRecorder = [[AVAudioRecorder alloc]initWithURL:url settings:recordSetting error:&error];
    
    //开启音量检测
    audioRecorder.meteringEnabled = YES;

    audioRecorder.delegate = self;
    
    // 设备开启录音模式
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
    
    //创建录音文件，准备录音
    BOOL prepareSuccess = [audioRecorder prepareToRecord];
    NSLog(@"准备录音: %d", prepareSuccess);
}

- (NSDictionary *)audioParamSetting {
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc]init];
    //设置录音格式
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM ] forKey:AVFormatIDKey];
    //设置录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
    [recordSetting setValue:[NSNumber numberWithFloat:8000] forKey:AVSampleRateKey];
    //录音通道数  1 或 2
    [recordSetting setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    //线性采样位数  8、16、24、32
    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    //录音的质量
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
    
    return recordSetting;
}

#pragma mark 获取音量值
- (void)detectionVoice {
    [audioRecorder updateMeters];//刷新音量数据
    
    //获取音量的平均值  [recorder averagePowerForChannel:0];
    //音量的最大值  [recorder peakPowerForChannel:0];
    double lowPassResults = pow(10, (0.1 * [audioRecorder peakPowerForChannel:0]));
    NSLog(@"%f", lowPassResults);
    
    _valueLabel.text = [NSString stringWithFormat:@"%f", lowPassResults];
    _rippleView.kRippleYMax = lowPassResults*30;
}

#pragma mark 开始/停止录音
- (IBAction)voiceAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    if(button.selected){
        BOOL seccess = [audioRecorder record];
        NSLog(@"开始是否成功: %d", seccess);
        [_rippleView startAnimation];
    }else {
        [audioRecorder stop];
        [_rippleView stopAnimation];
    }
}

- (void)dealloc {
    [_timer invalidate];
    _timer = nil;
}

@end
