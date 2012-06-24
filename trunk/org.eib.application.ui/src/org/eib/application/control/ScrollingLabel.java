package org.eib.application.control;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;

import org.eclipse.swt.SWT;
import org.eclipse.swt.events.ControlAdapter;
import org.eclipse.swt.events.ControlEvent;
import org.eclipse.swt.events.DisposeEvent;
import org.eclipse.swt.events.DisposeListener;
import org.eclipse.swt.events.PaintEvent;
import org.eclipse.swt.events.PaintListener;
import org.eclipse.swt.graphics.Point;
import org.eclipse.swt.widgets.Canvas;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Display;
/**
 * <dl>
 * <dt><b>Styles:</b></dt>
 *    <dd>SWT.H_SCROLL</dd>
 *    <dd>SWT.V_SCROLL</dd>
 * </dl>
 * <p>
 * 
 * The <code>ScrollingLabel</code> is a special label that has the ability to 
 * scroll text from right to left using SWT.H_SCROLL or from bottom to top using SWT.V_SCROLL.
 * This behaviour is useful when the text in the label cannot fit into the space allocated to it.
 * 
 * <br><br>
 * Note if the text fits into the space allocated to it the scrolling behaviour will be switched off.
 *
 * 
 * <br><br>
 * Demo of <code>ScrollingLabel</code> is provided in the samples package.
 * <br><br>
 * 
 * @author Code Crofter <br>
 * On behalf Polymorph Systems <br>
 *
 * @since RCP Toolbox v0.1 <br>
 * Working known issue:
 * Text Alignment when vertical left right or centered
 */
public class ScrollingLabel extends Canvas{
	/** The timer used to scrolling the text */
	private final Timer timer = new Timer();
	/** The list of listeners that are interested in the event when the text has scrolled a complete cycle. */
	private final List<ScrollingLabelListener> listeners = new ArrayList<ScrollingLabelListener>();
	/** A lock for the dispose flag*/
	private final Object disposeLock = new Object();
	/** A flag indicating that the widget has been disposed*/
	private boolean disposed = false;
	/** The scrolling task */
	private ScrollTask task;
	/** The message that will be scrolled*/
	private String message;
	/** Current x position of which to draw the text*/
	private int xPos = 0;
	/** Current y position of which to draw the text*/
	private int yPos = 0;
	/** The period between consecutive scrolling tasks*/
	private long periodScrollCharacter = 100;
	/** A flag indicating if the text must be scrolled horizontally or vertically*/
	private boolean verticalScroll = false;
	/** A flag indicating that the textFits in the space allocated for it.*/
	private boolean textFits = false;
	/** A flag indicating that the text will be drawn for the first time*/
	private boolean init = true;
	/** The visible space allocated for the text to be shown in*/
	private Point window;
	/** The extent of the text*/
	private Point textExtent;
	
	/** Used to check if the style requested is valid*/
	private static int checkStyle(int style){
		int newStyle = SWT.NONE;
		if((style&SWT.BORDER) == SWT.BORDER){
			newStyle|=SWT.BORDER;
		}
		if((style&SWT.NO_BACKGROUND) == SWT.NO_BACKGROUND){
			newStyle|=SWT.NO_BACKGROUND;
		}
		return newStyle;
	}
	
	/**
	 * Create scrolling label with 100ms scrolling period
	 * 
	 * @param parent
	 * @param style <code>SWT.V_SCROLL</code> or <code>SWT.H_SCROLL</code>
	 */
	public ScrollingLabel(Composite parent, int style){
		this(parent,style,100);
	}
	/**
	 * Create a scrolling label
	 * 
	 * @param parent
	 * @param style <code>SWT.V_SCROLL</code> or <code>SWT.H_SCROLL</code>
	 * @param scrollPeriod (milliseconds)
	 */
	public ScrollingLabel(Composite parent, int style, long scrollPeriod) {
		super(parent,checkStyle(style)|SWT.DOUBLE_BUFFERED);
		verticalScroll = (style&SWT.V_SCROLL) == SWT.V_SCROLL; 
		periodScrollCharacter = scrollPeriod;
		addPaintListener(new PaintListener(){
			public void paintControl(PaintEvent e) {
				ScrollingLabel.this.paintControl(e);
			}
		});		
		
		addDisposeListener(new DisposeListener(){
			public void widgetDisposed(DisposeEvent arg0) {
				ScrollingLabel.this.widgetDisposed();
			}			
		});
		
		addControlListener(new ControlAdapter(){
			@Override
			public void controlResized(ControlEvent arg0) {
				window = new Point(getClientArea().width,getClientArea().height);
				if(textExtent!=null){
					textFits = ((!verticalScroll && textExtent.x <= window.x) || 
							(verticalScroll && textExtent.y <= window.y));
					if(textFits){
						xPos = 0;
						yPos = 0;
					}
				}				
			}			
		});
	}
	
	/** Add a scroll listener to the label*/
	public void addScrollListener(ScrollingLabelListener listener){
		synchronized (listeners) {
			listeners.add(listener);
		}
	}
	
	/**Updates the listeners */
	private void updateListeners(){
		synchronized (listeners) {
			final Iterator<ScrollingLabelListener> iter = listeners.iterator();
			while(iter.hasNext()){
				iter.next().cycleComplete();
			}
		}
	}
	
	/** Set the period of scrolling, in milliseconds*/
	public void setScrollPeriod(long milliseconds){
		checkWidget();
		periodScrollCharacter = milliseconds;
		if(task != null){
			task.cancel();			
		}		
		task = new ScrollTask();		
		textFits = false;
		init = true;
		timer.schedule(task,0,periodScrollCharacter);
	}
	
	/** Set the text that must be displayed in the label*/
	public void setText(String text){
		checkWidget();
		message=text;
		xPos = 0;
		yPos = 0;
		if(task != null){
			task.cancel();			
		}		
		task = new ScrollTask();		
		textFits = false;
		init = true;
		timer.schedule(task,0,periodScrollCharacter);
	}

	private void widgetDisposed(){
		synchronized (disposeLock) {
			disposed = true;
		}
		if(task != null){
			task.cancel();
		}
		timer.cancel();
		timer.purge();
	}

	private void paintControl(PaintEvent e){
		if(init){
			final Point pnt = e.gc.textExtent(message);
			textExtent = new Point(pnt.x+e.gc.textExtent(message.substring(message.length()-1, 
					message.length())).x,pnt.y);				
			window = new Point(getClientArea().width,getClientArea().height);
			init = false;
			textFits = ((!verticalScroll && textExtent.x <= window.x) || (verticalScroll && textExtent.y <= window.y));
			xPos = 0;
			yPos = 0;			
		}		
		e.gc.setTextAntialias(SWT.ON);
		if(textFits){
			e.gc.drawText(message,0,0,true);			
		}else{
			if((verticalScroll) && (yPos!=0 && textExtent.y+yPos < window.y)){
				e.gc.drawText(message,0,yPos+textExtent.y,true);
			}else if((!verticalScroll) && xPos != 0 && textExtent.x+xPos < window.x){
				e.gc.drawText(message,xPos+textExtent.x,0,true);				
			}
			e.gc.drawText(message,xPos,yPos,true);			
		}
	}
	
	@Override
	public Point computeSize(int wHint, int hHint,boolean changed) {
		if(textExtent != null){
			return super.computeSize(wHint,textExtent.y,changed);
		}
		return super.computeSize(wHint,hHint,changed);
	}
	private class ScrollTask extends TimerTask{
		@Override
		public void run() {
			if(textFits)return;
			if(!init){
				if(verticalScroll){
					yPos--;
					if(Math.abs(yPos) >= textExtent.y){//reset
						yPos = 0;						
					}
					if(yPos!=0 && textExtent.y+yPos == window.y){
						updateListeners();
					}
				}else{
					xPos--;
					if(Math.abs(xPos) >= textExtent.x){//reset
						xPos = 0;
					}
					if(xPos!=0 && textExtent.x+xPos == window.x){
						updateListeners();
					}
				}
			}
			Display.getDefault().syncExec(new Runnable(){
				public void run() {	
					synchronized (disposeLock) {
						if(disposed)return;
					}					
					redraw();
				}				
			});
		}		
	}
}