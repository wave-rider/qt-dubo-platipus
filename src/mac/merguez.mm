#include <AppKit/NSWindow.h>

#include "libduboplatipus/merguez.h"
#include "cocoainit.h"
#include "AppleRemote.h"
#include "RemoteControl.h"

@class AppleRemote;
@interface SaucisseMain : NSObject {
//	MultiClickRemoteBehavior* remoteBehavior;
//	IBOutlet NSView*		feedbackView;
//	IBOutlet NSTextField*	feedbackText;
}

@property (atomic) RemoteControl* remoteControl;
@property (atomic) DuboPlatipus::RemoteMerguez* memere;

//- (RemoteControl*) remoteControl;
//- (void) setRemoteControl: (RemoteControl*) newControl;

- (void) setupBase: (DuboPlatipus::RemoteMerguez *) merguez;
- (void) start;
- (void) stop;

@end

@implementation SaucisseMain{

}
/*
- (void) dealloc {
    [self.remoteControl autorelease];
    [self.memere autorelease];
    [super dealloc];
}
*/
// implementation file
- (void) sendRemoteButtonEvent: (RemoteControlEventIdentifier) event
                   pressedDown: (BOOL) pressedDown
                   remoteControl: (RemoteControl*) remoteControl
{
    #pragma unused (remoteControl)
    self.memere->hello(event, pressedDown);
}

-(void) setupBase: (DuboPlatipus::RemoteMerguez *) merguez
 {
    self.memere = merguez;

    self.remoteControl = [[[AppleRemote alloc] initWithDelegate: self] autorelease];
    [self.remoteControl setDelegate: self];
/*
    AppleRemote* newRemoteControl = [[[AppleRemote alloc] initWithDelegate: self] autorelease];
    [newRemoteControl setDelegate: self];
    [self setRemoteControl: newRemoteControl];
*/
    //	// OPTIONAL CODE
//	// The MultiClickRemoteBehavior adds extra functionality.
//	// It works like a middle man between the delegate and the remote control
//	remoteBehavior = [MultiClickRemoteBehavior new];
//	[remoteBehavior setDelegate: self];
//	[newRemoteControl setDelegate: remoteBehavior];

}

// for bindings access
/*
- (RemoteControl*) remoteControl {
    return self.remoteControl;
}
- (void) setRemoteControl: (RemoteControl*) newControl {
    [self.remoteControl autorelease];
    self.remoteControl = [newControl retain];
}
*/

-(void) start
 {
    [self.remoteControl startListening: self];
 }

-(void) stop
 {
    [self.remoteControl stopListening: self];
 }
@end


class DuboPlatipus::RemoteMerguez::Private{
public:
    RemoteControl * rem;
    SaucisseMain * saucisse;
};

namespace DuboPlatipus{

RemoteMerguez::RemoteMerguez(QWidget * win, QObject *parent) :
QObject(parent)
{
    CocoaInitializer initializer;
    d = new Private();
    d->saucisse = [SaucisseMain alloc];
    [d->saucisse setupBase: this];
    if(win->isActiveWindow()){
        [d->saucisse start];
    }else{
        [d->saucisse stop];
    }
    win->installEventFilter(this);
}

bool RemoteMerguez::eventFilter(QObject */*object*/, QEvent *event)
{
    if((event->type() == QEvent::WindowDeactivate) || (event->type() == QEvent::WindowDeactivate))
        CocoaInitializer initializer;
    switch(event->type()){
    case QEvent::WindowActivate:
        [d->saucisse start];
        break;
    case QEvent::WindowDeactivate:
        [d->saucisse stop];
        break;
    default:
        break;
    }
    return false;
}

void RemoteMerguez::hello(int sig, bool pressed){
    emit merguez(sig, pressed);
}

}

