package org.eib.application.control;

/**
 * 
 * @author Code Crofter <br>
 * On behalf Polymorph Systems
 *
 * @since RCP Toolbox v0.1 <br>
 * 
 * Note the clients implementing this method must be aware that the scrolling will be blocked
 * if this method is blocked. Not Thread Safe
 */
public interface ScrollingLabelListener {
	/** Event informing the listener that full cycle of the message has been shown*/
	public void cycleComplete();
}
