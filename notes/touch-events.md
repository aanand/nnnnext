Event order                              | Desired effect
---------------------------------------- | --------------
touchstart, timeout, touchend            | Highlight on timeout, de-highlight and fire callback on touchend (“long tap”)
touchstart, touchend, timeout            | Fire callback on touchend (“short tap”)
touchstart, timeout, touchmove, touchend | Highlight, then de-highlight on touchmove (“long tap” cancelled by scrolling)
touchstart, touchmove, timeout, touchend | None (scroll)
touchstart, touchmove, touchend, timeout | None (scroll)

touchstart: add 'touch-started' class, start timeout
timeout:    if 'touch-started' class present, add 'touched' class
touchend:   if 'touch-started' class present, remove it, remove 'touched' class and fire callback.
touchmove:  remove 'touchstarted' and 'touched' classes.

