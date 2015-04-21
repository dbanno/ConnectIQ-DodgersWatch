using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.ActivityMonitor as Act;

class ConnectIQDodgersWatchView extends Ui.WatchFace {

var img;
var isSleep;
var updateCount = 0;
var step;

    //! Load your resources here
    function onLayout(dc) {
        //setLayout(Rez.Layouts.WatchFace(dc));
        img = Ui.loadResource(Rez.Drawables.DodgerLogo); 
        step = Ui.loadResource(Rez.Drawables.id_step);
    }

    //! Restore the state of the app and prepare the view to be shown
    function onShow() {
    }

    //! Update the view
    function onUpdate(dc) {
    	// Call the parent onUpdate function to redraw the layout
//Vivoactive 205 x 148 
        View.onUpdate(dc);
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_WHITE);
        dc.clear();
		dc.drawBitmap(1,1,img);
        // Get and show the current time
        var clockTime = Sys.getClockTime();
        var screenY = dc.getHeight();
        var screenX = dc.getWidth();
        
        var hour = clockTime.hour;
        //12-hour support
        if (hour > 12 || hour == 0)
        {
	        var deviceSettings = Sys.getDeviceSettings();
	        
	        if (!deviceSettings.is24Hour) {
	        	if (hour == 0) {
	        		hour = 12;
	        	}
	        	else {
	        		hour = hour - 12;
	        	}
	        }
        }
        var minute = clockTime.min.toString();
        if (minute.toNumber() < 10) {
        	minute = "0" + minute;
        }
        var timeString = Lang.format("$1$:$2$", [hour, minute]);
        
        dc.setColor(Gfx.COLOR_DK_BLUE, Gfx.COLOR_TRANSPARENT);
        //Vivoactive 205 x 148 
		//FONT_NUMBER_HOT - Can't use since it removes leading 0
        dc.drawText((screenX-60),(screenY-70), Gfx.FONT_NUMBER_HOT,timeString , Gfx.TEXT_JUSTIFY_CENTER);
        
        //Show battery info when Awake
        if(isSleep == 0){ 
	    	var stats = Sys.getSystemStats();
	      	var battery = stats.battery;
	    
	  		dc.setColor(Gfx.COLOR_DK_BLUE, Gfx.COLOR_TRANSPARENT);
	  		//Large Battery Rectangle

	  		dc.drawRectangle((screenX-90), 10,80,29);
	  		//Positive battery Terminal
	  		dc.drawRectangle((screenX-11), 20,5,10);
	  		//Battery %
			
	        dc.drawText((screenX-50), 10, Gfx.FONT_MEDIUM, battery.format("%4.2f") + "%", Gfx.TEXT_JUSTIFY_CENTER);
    	}
    	else {
    		var date = Time.Gregorian.info(Time.now(),0);
    		var month = date.month;
    		var day = date.day;
    		dc.setColor(Gfx.COLOR_DK_BLUE, Gfx.COLOR_TRANSPARENT);
    		dc.drawText((screenX-40), 10, Gfx.FONT_MEDIUM, month + "/" + day, Gfx.TEXT_JUSTIFY_CENTER);
    	}
    	
    	//Show step information
		dc.setColor(Gfx.COLOR_DK_BLUE, Gfx.COLOR_TRANSPARENT);
		dc.drawBitmap(5,screenY-20,step);
		
		var activity = Act.getInfo();
		if(updateCount == 2 && isSleep == 0) { //When update count is 2 (every 2 minutes or 2 seconds when awake) switch values
			dc.drawText(30, screenY-25, Gfx.FONT_MEDIUM, activity.steps.toString(), Gfx.TEXT_JUSTIFY_LEFT);
			updateCount = 0;
		}
		else{
			dc.drawText(30, screenY-25, Gfx.FONT_MEDIUM, (((activity.steps.toFloat() / activity.stepGoal.toFloat())*100)).format("%4.2f") + "%", Gfx.TEXT_JUSTIFY_LEFT);
		}
		
    	updateCount += 1;
    	
    	if (updateCount > 2){
    		updateCount = 0;
    	}

        
    }

    //! The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    	isSleep = 0;
	}
    //! Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    	isSleep = 1;
    }

}